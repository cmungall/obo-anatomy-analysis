#!/usr/bin/perl
use warnings;
use Carp;
use strict;

use Venn::Chart;

my ($n1,$f1,$n2,$f2,$n3,$f3, $outf) = @ARGV;


# Create the Venn::Chart constructor
my $venn_chart = Venn::Chart->new( 400, 400 ) or die("error : $!");

# Set a title and a legend for our chart
$venn_chart->set_options( -title => 'Uberon Ext term sources' );
$venn_chart->set_legends( $n1, $n2, $n3 );

# 3 lists for the Venn diagram
my @team1 = rf($f1);
my @team2 = rf($f2);
my @team3 = rf($f3);

# Create a diagram with gd object
my $gd_venn = $venn_chart->plot( \@team1, \@team2, \@team3 );

$outf = 'VennChart.png' unless $outf;

# Create a Venn diagram image in png, gif and jpeg format
open my $fh_venn, '>', $outf or die("Unable to create png file $outf\n");
binmode $fh_venn;
print {$fh_venn} $gd_venn->png;
close $fh_venn or die('Unable to close file');

exit 0;

sub rf {
    my $f = shift;
    my @ids = ();
    open(F,$f);
    while(<F>) {
        chomp;
        push(@ids,$_);
    }
    return @ids;
}

