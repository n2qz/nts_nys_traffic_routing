#! /usr/bin/perl -T

use strict;
use warnings;

use FindBin qw/ $Bin /;
use Template;
use CGI qw/ -utf8 /; 
use CGI::Carp qw(fatalsToBrowser);

my $cgi = CGI->new;
my $tt  = Template->new({
    INCLUDE_PATH => [
	"$Bin/templates",
	"$Bin",
	]
});
 
my $search = $cgi->param('search') || "";
my @fields = $cgi->multi_param('fields');
if (@fields == 0) {
    @fields = ('city', 'zip');
}

my %match;
foreach my $field (@fields) {
    $match{$field} = 1;
}

my @tabledata = ();
if ($search ne '') {
    open(NTS, "</nts_nys_traffic_routing.csv") || die "$!";
    my $match = 0;    
    while (my $line = <NTS>) {
	chomp($line);
	my ($city, $zip, $county, $net) = split(/,/, $line);
	if (($match{'city'} && ($city =~ /$search/i))
	    || ($match{'zip'} && ($zip =~ /$search/i))
	    || ($match{'county'} && ($county =~ /$search/i))
	    || ($match{'net'} && ($net =~ /$search/i))) {
	    push(@tabledata, ($city, $zip, $county, $net));
	    $match++;
	}
    }
    close(NTS);
}

my $out = $cgi->header(
    -type    => 'text/html',
    -charset => 'utf-8',
);
 
$tt->process(
    "nts_nys_traffic_routing.html.tt",
    {
        search => $search,
	match => \%match,
	tabledata => \@tabledata,
    },
    \$out,
) or die $tt->error;
 
print $out;

exit 0;
