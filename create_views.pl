#!/usr/bin/perl

# create_index_page.pl

use strict;
use warnings;
use File::Slurp;
use Cwd;

use lib '/home/glen/gimmie60/source/x_common';
use utils;


my $SUCCESS                     = 0;
my $FAILURE                     = -1;

my $MINIMAL_FOLDER              = '/home/glen/workspace/Minimal/';
my $IMAGES_FOLDER               = cwd . '/images/';
my $WWW_FOLDER                  = $MINIMAL_FOLDER . 'www/';




sub main;
sub copy_files;
sub create_sitemap;


main;

sub main
{

   my $filename = cwd . '/index.js';
   if(! -e $filename) {
      print "FATAL: $filename does not exist\n";
      exit(0);
   }
   my $folder = cwd . '/js/';
   system("cp $filename $folder");
 
   
   # build the www folder from scratch
   system("rm -r $WWW_FOLDER") if(-e $WWW_FOLDER);
   mkdir($WWW_FOLDER, 0755);
   
   # copy the folders
   my @folders = qw(icons fonts css js);
   foreach my $folder (@folders) {
      my $foldername = cwd . '/' . $folder;
      if(! -e $foldername) {
         print "FATAL: $foldername does not exist\n";
         exit(0);
      }
      system("cp -r $folder $WWW_FOLDER");
   }
   
      # copy the images
   if(! -e $IMAGES_FOLDER) {
      print "FATAL: $IMAGES_FOLDER does not exist\n";
      exit(0);
   }
   my @images = qw(re.png);
   my $image_folder = $WWW_FOLDER . 'images';
   mkdir $image_folder, 0755;
   foreach my $image (@images) {
      my $filename = $IMAGES_FOLDER . $image;
      if(! -e $filename) {
         print "FATAL: $filename not found\n";
         exit(0);
      }
      system("cp $filename $image_folder");
   }
 
   
   # copy the files
   my @files = qw(index.html resultsPart1.html);
   foreach my $file (@files) {
      my $filename = cwd . '/' . $file;
      if(! -e $filename) {
         print "FATAL: $filename does not exist\n";
         exit(0);
      }
      system("cp $filename $WWW_FOLDER");
   }
   
   
   # if config.json wont use index.html this is a workaround
   $filename = cwd . '/index.html';
   system("cp $filename $WWW_FOLDER/results.html");
   
   $filename = cwd . '/resultsPart1.html';
   system("cp $filename $WWW_FOLDER");
   
   # copy the script that syncs the web servers
   @files = qw(syncwww.sh);
   foreach my $file (@files) {
      my $filename = $MINIMAL_FOLDER . $file;
      system("rm $filename") if(-e $filename);
      $filename = cwd . '/' . $file;
      if(! -e $filename) {
         print "FATAL: $filename does not exist\n";
         exit(0);
      }
      system("cp $filename $MINIMAL_FOLDER");
   }
   print "DONE.\n";
}

