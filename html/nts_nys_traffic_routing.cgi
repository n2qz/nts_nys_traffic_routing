#! /usr/bin/perl -wT

use strict;

use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);

my $cgi = new CGI;

print STDOUT $cgi->header(-type => 'text/html');
print STDOUT $cgi->start_html(-title=> 'NTS New York State Traffic Routing Database',
			      -meta => {'author' => 'Nicholas S. Castellano N2QZ'},
			      -style => {-src => '/nts_nys_traffic_routing.css'},
			      );

my $search = $cgi->param('search');
my @fields = $cgi->multi_param('fields');
if (@fields == 0) {
    @fields = ('city', 'zip');
}

my %match;
foreach my $field (@fields) {
    $match{$field} = 1;
}

print STDOUT $cgi->h1('NTS New York State Traffic Routing Database');

print STDOUT $cgi->start_form(-enctype => &CGI::MULTIPART,
			      -action => $cgi->url());
print STDOUT $cgi->p();
print STDOUT "<LABEL>Search:\n";
print STDOUT $cgi->textfield('search');
print STDOUT $cgi->p();
print STDOUT "<LABEL>Match fields:\n";
print STDOUT $cgi->checkbox_group(-name => 'fields',
				  -values => ['city', 'zip', 'county', 'net'],
				  -defaults => [ @fields ]
				  );
print STDOUT $cgi->p();
print STDOUT $cgi->submit();
print STDOUT $cgi->defaults('Reset Defaults');
print STDOUT $cgi->end_form();

if ($search eq '') {
    print STDOUT $cgi->img({-src => "/nts.png",	-alt => "NTS", -class => "textwrap"});

    print STDOUT $cgi->p('This database contains routing information
			 for the American Radio Relay League <A
			 HREF="http://www.arrl.org/nts">National
			 Traffic System</A> in New York State.');

    print STDOUT $cgi->p('The routing tables were originally compiled
			 by <A HREF="https://www.qrz.com/db/KU2N">Carl
			 R. Preddy KU2N</A> and <A
			 HREF="https://www.qrz.com/db/NE2W">Edward
			 Krymowski NE2W</A> in the <A
			 HREF="/new_york_state_traffic_routing_guide.pdf">
			 <cite>New York State Traffic Routing
			 Guide</cite></A> in 1986.');

    print STDOUT $cgi->p('The guide was scanned and processed by <A
			 HREF="https://www.qrz.com/db/W2YGW">Art
			 DeBruycker W2YGW</A> in 2005.');

    print STDOUT $cgi->p('<A HREF="https://www.qrz.com/db/N2QZ">Nick
			 Castellano N2QZ</A> started with Art\'s
			 spreadsheet in 2008, cleaned up hundreds of
			 OCR errors, updated the data to bring it
			 closer to current reality, and created this
			 CGI web search form.');

    print STDOUT $cgi->p('<A HREF="https://www.qrz.com/db/N2JRS">Vince
			 Harzewski N2JRS</A> provided significant
			 corrections in December 2020.');

    print STDOUT $cgi->p('Please contact <A
			 HREF="http://www.qrz.com/db/N2QZ">N2QZ</A>
			 with any updates or corrections.');

} else {
    open(NTS, "</nts_nys_traffic_routing.csv") || die "$!";
    print $cgi->start_table({-border=>'2'});
    print Tr(th(['City', 'Zip', 'County', 'Net']));
    my $match = 0;    
    while (my $line = <NTS>) {
	chomp($line);
	my ($city, $zip, $county, $net) = split(/,/, $line);
	if (($match{'city'} && ($city =~ /$search/i))
	    || ($match{'zip'} && ($zip =~ /$search/i))
	    || ($match{'county'} && ($county =~ /$search/i))
	    || ($match{'net'} && ($net =~ /$search/i))) {
	    print Tr(td([$city, $zip, $county, $net]));
	    $match++;
	}
    }
    close(NTS);
    print STDOUT $cgi->end_table();
    print STDOUT $cgi->p();
    print STDOUT $match, " match", (($match == 1) ? "" : "es"), " found.\n";
}

#print STDOUT $cgi->p();
#@counter = `/arpa/ns/n/n2qz/html/counter.cgi`;
#shift(@counter);
#print STDOUT "Page hits: ", @counter;

print STDOUT $cgi->end_html();

