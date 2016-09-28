#!/usr/bin/perl -w -I/usr/share/eprints3/perl_lib
# Deposit an eprint in the repository
#
# This is an educational script to demonstrate how to create an eprint entry
# and add a file to the entry.
# This script is based on the official create_eprint.pl script (http://www.eprints.org/services/training/resources/eprints3/bin-scripts/create_eprint.pl).

use EPrints;
use strict;

# Start session
my $session = new EPrints::Session( 1, "hram" );
exit( 0 ) unless( defined $session );

# Get buffer dataset
my $dataset = $session->get_repository->get_dataset( "buffer" );

# Create new eprint
my $eprint = EPrints::DataObj::EPrint::create( $session, $dataset );
$eprint->set_value( "title", "Hello World" );
$eprint->set_value( "creators_name", 
	[ 
		{ family=>"Smith", given=>"John" },
		{ family=>"Jones", given=>"Mary" },
	] );
$eprint->set_value( "date", "2005-02-02" );
$eprint->set_value( "type", "article" );
$eprint->set_value( "userid", 1);

$eprint->commit();

# Add document to eprint
my $pdf;
my $filename = "demo.pdf";
my $file = "/usr/share/eprints3/bin/hram/demo.pdf";
my $filesize = -s $filename;
if( open( $pdf, $file ) )
{
	my $doc = EPrints::DataObj::Document::create( $session, $eprint );
	$doc->add_file($file, $filename);
	close $pdf;
	$doc->set_value( "main", $filename );
	$doc->commit;
}
else
{
	print STDERR "Failed to open file: $filename: $!\n";
	print STDERR "Did not create document.\n";
}

# Generate abstract page for new eprint
$eprint->generate_static;

print "Created EPrint #" . $eprint->get_id . "\n";

# End session
$session->terminate();
