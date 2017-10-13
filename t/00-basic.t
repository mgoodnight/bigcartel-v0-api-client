#!/usr/bin/env perl

use strict; use warnings;

use Test::Most;
use Furl;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use BigCartel::v0::API::Client;

my $sub_domain = $ENV{BIGCARTEL_SUBDOMAIN} || 'PLACEHOLDER';

use_ok('BigCartel::v0::API::Client');
require_ok('BigCartel::v0::API::Client');
dies_ok { BigCartel::v0::API::Client->new() } "Dies on missing required attributes.";

my $client = BigCartel::v0::API::Client->new(sub_domain => $sub_domain);
isa_ok($client, 'BigCartel::v0::API::Client');

foreach my $method ( map { chomp $_; $_; } <DATA> ) {
    can_ok('BigCartel::v0::API::Client', $method);
}

ok defined($client->ua), "We built our UserAgent.";
isa_ok($client->ua, 'Furl');

dies_ok { $client->api_url('http://mgoodnight.com') } "Dies when trying to modify a read-only attribute (api_url).";
dies_ok { $client->ua(Furl->new()) } "Dies when trying to modify a read-only attribute (ua).";

done_testing();

__DATA__
api_url
sub_domain
ua
last_query_response
last_query_error
_query
get_store_details
get_store_products
get_store_custom_page
