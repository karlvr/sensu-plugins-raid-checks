#!/usr/bin/perl -w
# Generic software raid check
# Based on https://github.com/VeselaHouba/sensu-plugins-raid-checks/blob/master/bin/check-raid.rb

use Getopt::Long qw(:config no_auto_abbrev no_ignore_case);
use Pod::Usage;

sub check_software_raid {
	return if (! -e "/proc/mdstat");

	open(my $fh, "<", "/proc/mdstat") or die("Cannot read /proc/mdstat");
	while (<$fh>) {
		next unless /active|blocks/;
		if (/\]\(F\)|[\[U]_/) {
			system("cat /proc/mdstat");
			print "Problems in software RAID\n";
			exit 2;
		}
	}

	print "Software RAID OK\n";
}

check_software_raid();
