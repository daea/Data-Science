#!C:\Strawberry\perl\bin
# Copyright Matthew Cumming 2015 #

use warnings;
use strict;
use Cwd 'abs_path';						# to get our filepaths
use File::Copy;							# to automate some directory ops
use 5.010;							# To use given/when

# Program to sample photo's at a given frequency from a population of GOPRO photos sampled over an experiments duration.
# Idea is to make an appropriate timelapse of the plants growing.

my @pics = glob '*.jpg';					# Grab the Extant File Id's
my @timelapse = ();						# New Names and ID's

my $filepath = abs_path($0);
my $path = substr($filepath, 0, -(length($0)));		
print "The working directory is currently: $path.\n";
print "\n";

foreach (@pics) {						
	push @timelapse, "Week1_".substr($_, -11);		# "GOPROXXXX.jpg"
}							

my $length = scalar(@pics) - 1;					# for the Final control loop

my $dest = $path."Lapsed\\";						# Need to set your destination path
print $dest;

foreach my $i (0..$length) {
	print $pics[$i] if $i % 30 == 0;
	if ($i % 30 == 0) {	
		copy($path.$pics[$i], $dest.$timelapse[$i]) or die "You're a goon: $!";	
	}
}

