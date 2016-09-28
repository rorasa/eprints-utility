#!/usr/bin/perl -w -I/usr/share/eprints3/perl_lib
# Upload a file to eprint entry
# USAGE:
# upload_file.pl <repository_id> <eprint_id> <filename>
#
# This script upload the <filename> file to the chosen repository as a document
# of the <eprint_id> eprint.

use EPrints;
use strict;
use File::Spec;
use File::Basename;

my $repositoryid = $ARGV[0];
my $eprintid = $ARGV[1];
my $file = $ARGV[2];
my $filename = basename( $file );
my $filefull = File::Spec->rel2abs( $file );

print "Adding $filename to entry $eprintid in $repositoryid \n";
print "[ $filefull ]\n";

# Start session
my $session = new EPrints::Session( 1, $repositoryid );
exit( 0 ) unless( defined $session );

# Get eprint object
my $eprint = EPrints::DataObj::EPrint->new( $session , $eprintid );

# Add document to eprint
my $f;
if( open( $f, $filefull ) )
{
    my $doc = EPrints::DataObj::Document::create( $session, $eprint );
    $doc->add_file($filefull, $filename);
    close $f;
    $doc->set_value( "main", $filename );
    $doc->commit;
}
else
{
    print STDERR "Failed to open file: $filename: $!\n";
    print STDERR "Did not create document.\n";
}

# End session
$session->terminate();
