#!/usr/bin/env perl

use strict; use warnings;

use Test::Most;
use Furl;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use BigCartel::v0::API::Client;
use JSON qw/decode_json/;

my $sub_domain = $ENV{BIGCARTEL_SUBDOMAIN};
SKIP: {
    skip "Missing BigCartel subdomain environment variable, so we are skipping...", 4 unless ($sub_domain);
    my $client = BigCartel::v0::API::Client->new(sub_domain => $sub_domain);

    my $details_json = $client->get_store_details;
    ok($client->last_query_response->code == 200, "Our response code is OK");
    ok(decode_json($details_json), "Successfully decoded our expected JSON content");

    my $items_json = $client->get_store_products;
    ok($client->last_query_response->code == 200, "Our response code is OK");
    ok(decode_json($items_json), "Successfully decoded our expected JSON content");
}

done_testing;
