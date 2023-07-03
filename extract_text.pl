#!/usr/bin/perl

use strict;
use warnings;
use HTML::Parser;

# Subclass HTML::Parser
package TextExtractor;
use base 'HTML::Parser';

# Initialize variables
my $current_tag;
my %ignore_tags;
my $target_tag = lc($ARGV[0]);  # Command line argument for the target tag
my $ignore_text = 1;

# Override start and end tag methods
sub start {
    my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
    $current_tag = lc($tagname);
    if (exists $ignore_tags{$current_tag}) {
        $ignore_tags{$current_tag}++;
    }
    if (lc($tagname) eq $target_tag) {
        $ignore_text = 0;  # Stop ignoring text when target tag is found
    }
}

sub end {
    my ($self, $tagname, $origtext) = @_;
    my $tag = lc($tagname);
    if (exists $ignore_tags{$tag}) {
        $ignore_tags{$tag}--;
    }
    if ($tag eq $target_tag) {
        $ignore_text = 1;  # Start ignoring text again after target tag ends
    }
}

# Override text method
sub text {
    my ($self, $text) = @_;
    #printf STDERR "(%s) %s", $current_tag, $text unless $ignore_tags{$current_tag} || $ignore_text;
    print $text unless !$current_tag || $ignore_tags{$current_tag} || $ignore_text;
}

# Main program
my $html = do { local $/; <STDIN> };

# Get the list of tags to ignore from command line arguments
my @ignore_tag_list = @ARGV[1..$#ARGV];

# Create a hash to store the ignore tags
foreach my $ignore_tag (@ignore_tag_list) {
    $ignore_tags{lc($ignore_tag)} = 1;
}

# Create an instance of TextExtractor
my $parser = TextExtractor->new();

# Parse the HTML
$parser->parse($html);
