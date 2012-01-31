#!/usr/bin/env perl

# Based on work from http://cedric.bosdonnat.free.fr/wordpress/?p=183

use strict;
use warnings;

eval {
    require XML::LibXML;
    XML::LibXML->import();
};

if ($@) {
  # Give people a kinder more gentle fail...
  print "Perl module XML::LibXML is missing. Please install it.\n";
  exit(1);
}

my ( $xmlFilename, $xpath, $realName ) = @ARGV;

if ( ! defined $realName ) {
    $realName = $xmlFilename;
}

# Create the parser with line numbers so that the 
# quickfix window can be used to view the output

my $parser     = XML::LibXML->new({ line_numbers => 1 }); # Original code was missing the 'line_numbers' parameter
my $xmlDoc     = $parser->parse_file( $xmlFilename );
my $xmlContext = XML::LibXML::XPathContext->new( $xmlDoc );
my $nodes      = $xmlContext->findnodes( $xpath );

if ( $nodes->size() ) {
    foreach my $node ( $nodes->get_nodelist ) {
        print $realName, ":", $node->line_number(), " ", $node->nodePath( ) ,"\n";
    }
}
else {
    print "No nodes found for ['$xpath']\n";
}
