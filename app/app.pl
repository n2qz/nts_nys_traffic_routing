#!/usr/bin/env -S perl -T
 
use strict;
use warnings;
use Dancer2;

set 'template'     => 'template_toolkit';
set 'logger'       => 'console';
set 'log'          => 'debug';
set 'show_errors'  => 1;
set 'startup_info' => 1;
set 'warnings'     => 1;

hook before_template_render => sub {
    my $tokens = shift;
 
    $tokens->{'css_url'} = 'css/style.css';
};

any [ 'get','post' ] => '/' => sub {

    my $search = body_parameters->get('search');

    my @fields = body_parameters->get_all('fields');
    if (@fields == 0) {
	@fields = ('city', 'zip');
    }

    my %match = map {$_ => 1} @fields;
    
    my @tabledata = ();
    if (defined($search)) {
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

    template 'nts_nys_traffic_routing.html.tt', {
	'search'    => $search,
	'match'     => \%match,
	'tabledata' => \@tabledata,
    };
};
  
start;
die "Dancer2 start unexpectedtly returned";
