#!/usr/bin/perl

use strict;
use warnings;

my $previous_line_was_blank = 0;

# Read the input from the standard input (pipe)
while (<>) {
    # Check if the line is blank
    my $is_blank = /^\s*$/;
    
    # Skip the line if it's a consecutive blank line
    next if $is_blank && $previous_line_was_blank;
    
    # Print the line
    print $_;
    
    # Update the flag indicating if the previous line was blank
    $previous_line_was_blank = $is_blank;
}

