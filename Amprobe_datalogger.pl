#!C:\Strawberry\perl\bin
# Copyright Matthew Cumming 2015 #

#use warnings;
use strict;
use Cwd 'abs_path';						# to get our filepaths
use File::Copy;							# to automate some directory ops
use 5.010;							# To use given/when

print "\n\n\nYou are currently running Matt's Datalogger program: $0.\nPlease ensure that all your data files downloaded from the Amprobe datalogger are in .txt format and that the ID's have no spaces in them.\nMatt is not responsible for your garbled data.\n\n\n";


################# main() ###############################
########################################################
# Filepaths


my $path = abs_path($0);					# $0 is the current filename as set by perl
$path = substr($path, 0, -(length($0)));			# get our absolute filepath.
print "The working directory is currently: $path.\n";

########################################################
# Actual Datafiles

my @datafiles = glob '*.txt';						# Don't delete our files accidentally
my $x = scalar(@datafiles);

print "You have $x datafile(s).\n";
foreach my $file (@datafiles) {						# the file with the data in it

	if (! open DATA, $path.$file) {					# open our .CSV
		 die "Could not open file '$file' $!";
	}

	my @data = ();
	my $i = 0;
	while(<DATA>) {
		chomp;
		my ($a, $b, $c, $d, $e, $f)  = split(' ', $_);		# Split on spaces in the file
		push @{ $data[$i] }, ($a, $b, $c, $d, $e, $f);		# Create references to our arrays
		$i += 1;
	}
	close DATA;

	$i = 0;
	my $fileid = $data[2][1];					# Just cause it's easier
	
	my $newfile = 'data.csv'; 
	if (-e $newfile) {
		print "You already have a datafile called $newfile.\nWould you like to add your new data to the existing file? (y/n) \n";
		chomp (my $answer = <>);
		given ($answer) {
			when ('y') { 
				if (!open OUT, '>>', 'data.csv') {
       					die "Cannot edit data.csv: $!";
				}

				$i = 0;
				my $length = scalar(@data) -1;
				foreach $i (6..$length) {									
					print OUT "$data[2][1],";
					foreach my $j (0..5) {					
						print OUT "$data[$i][$j],";
					}
					print OUT "\n";
				}
				close OUT;
			}
			when ('n') {
				die "Please remove the existing $newfile. From the directory and try again.\n";
			}
			default {
				print "Sorry that is not a valid answer please try again.\n";
			}
		}
	} else {
		print "Creating a new datafile called $newfile.\n";
		if (!open OUT, '>', 'data.csv') {
       					die "Cannot create data.csv: $!";
				}

				my $i = 0;
				my $length = scalar(@data) -1;
				foreach $i (6..$length) {									
					print OUT "$data[2][1],";
					foreach my $j (0..5) {					
						print OUT "$data[$i][$j],";
					}
					print OUT "\n";
				}
				close OUT;
	}
}

#################### EOF() #####################
	


################################################
#$i = 0;
#my $length = scalar(@data) -1;
#foreach $i (5..$length) {					# De-reference our array and make sure we
#	print "\n";						# didn't break the data (does the data looks
#	foreach my $j (0..5) {					# mangled?)
#		print "$data[$i][$j] ";
#	}
#}

#foreach $i (0..5) {i						# We are going to make a couple variables
#	print "\n";						# to help when we append the our .csv 
#	foreach my $j (0..5) {					# with new data. ie. to make the file into 
#		print "$data[$i][$j] ";				# proper long format. This code can print the
#	}							# contents.
#								
#}

#################################################
# Amprobe file format

#22				
#Date: 03-30-2015
#ID= 14
#Sample_Rate= 00:15:00
#Total_Records= 1431
#Unit: C
#1  10-09-2014   15:43:55   30.3    E01     25.3 
#2  10-09-2014   15:58:55   36.6    E01     19.8 
#3  10-09-2014   16:13:55   37.4    E01     19.3 
##     Date        Time     Temp  EXTTemp    RH

#################################################################
