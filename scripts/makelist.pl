#!/usr/bin/perl

use strict;

my %a = ();
while (<>) {

    open FILE, "<$_" or die $!;
    warn "Opening $_\n";
    my $uri;
    my $user;
    while (<FILE>) {
      chomp;
      if (/<oa:hasBody rdf:resource="(https:\/\/hypothes.is\/a\/.*?)"/ims) {
        $uri = $1;  
      } elsif (/<foaf:Person rdf:about="(.*?)"/) {
        $user = $1;
      } else {
        next;
      }
      if ($uri && $user) {
        $a{$uri} = $user;
        $uri = $user = undef;
      }
    }
    close FILE;
}

for my $uri (sort keys %a) {
    print "$uri,$a{$uri}\n";
}
