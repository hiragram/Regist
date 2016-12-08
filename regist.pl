#!/usr/bin/perl

use strict;
use warnings;

my $current = `pwd`;
chomp($current);
my $root = ".";

my $filelist = &get_files($root);

my $status = 0;
foreach my $file (@$filelist) {
  my @lines = split("\n", `cat $file`);
  my $i = 1;
  foreach my $line (@lines) {
    if ($line =~ /[rR]egist[^e]/) {
      print STDERR "$current/$file:$i:1: error: 💢😡\n";
      $status = 2;
    }
    $i++;
  }
}

exit($status);

sub get_files {
  my $dir = shift;
  my $filelist = shift;
  opendir(DIR, "$dir");
  my @list = grep /^[^\.]/, readdir DIR;
  foreach my $file (@list) {
    if (-d "$dir/$file") {
      $filelist = &get_files("$dir/$file", $filelist);
    } else {
      if ($file =~ /.swift$/) {
        push @$filelist, "$dir/$file";
      }
    }
  }
  return $filelist;
}
