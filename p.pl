#!/usr/bin/env perl -w

use strict;

package PerlHtmlParser;

use base "HTML::Parser";

use constant START_TAG => 'article';
my $ignore = '';
my $started = 0;

sub text {
	return if !$started;
	return if $ignore;
	my ($self, $str) = @_;
	$str =~ s/^\s+//;
	return if !$str;
	print "$str\n";
}

sub start {
	my ($self, $tag, $attr, $attrseq, $origtext) = @_;
	$ignore = $tag if ($tag eq 'img' or $tag eq 'em' or $tag eq 'span');
	$started=1 if ($tag eq START_TAG);
}

sub end {
	my ($self, $tag, $attr, $attrseq, $origtext) = @_;
	$ignore = '';
	$started = 0 if $tag eq START_TAG;
}

my $p = new PerlHtmlParser;
while (<>) {
	$p->parse($_);
}
