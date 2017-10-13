package BigCartel::v0::API::Client;

# ABSTRACT: Very simple API client module to work with the now depracated API of BigCartel

use strict;
use warnings;

use Moo;
use Furl;
use IO::Socket::SSL;
use Try::Tiny;
use JSON qw/decode_json/;

has sub_domain => (
    is => 'rw',
    required => 1
);

has api_url => (
    is => 'ro',
    default => sub {
        return "https://api.bigcartel.com";
    }
);

has ua => (
    is      => 'ro',
    builder => sub {
        return Furl->new(
            timeout  => 300,
            ssl_opts => {
                SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_PEER(),
            }
        );
    }
);

has last_query_response => (
    is => 'rwp'
);

has last_query_error => (
    is => 'rwp'
);

sub get_store_details {
    my $self = shift;
    my $url = sprintf "%s/%s/store.json", $self->api_url, $self->sub_domain;

    my $content = $self->_query($url);
	my $deserialized_content;
    try {
        $deserialized_content = decode_json($content);
    }
    catch {
        warn "There was an issue deserializing response content.";
    };

	return $deserialized_content;
}

sub get_store_products {
	my $self = shift;
    my $url = sprintf "%s/%s/products.json", $self->api_url, $self->sub_domain;

    my $content = $self->_query($url);
	my $deserialized_content;
    try {
        $deserialized_content = decode_json($content);
    }
    catch {
        warn "There was an issue deserializing response content.";
    };

	return $deserialized_content;
}

sub get_store_custom_page {
	my ($self, $permalink) = @_;
    my $url = sprintf "%s/%s/page/%s.json", $self->api_url, $self->sub_domain, $permalink;

    my $content = $self->_query($url);
	my $deserialized_content;
    try {
        $deserialized_content = decode_json($content);
    }
    catch {
        warn "There was an issue deserializing response content.";
    };

	return $deserialized_content;
}

sub _query {
    my ($self, $extractor_url, $headers) = @_;

    my $response = $self->ua->get($extractor_url, $headers);
    $self->_set_last_query_response($response);
    
    my $content_decoded = $response->decoded_content;
    $self->_set_last_query_error($content_decoded) if !$response->is_success;
    
    return $content_decoded;
}

=head1 NAME
=head1 SYNOPSIS
    use BigCartel::v0::API::Client;
    
    my $client = BigCartel::v0::API::Client->new({
        sub_domain  => 'my_store'
    });

    my $products = $client->get_store_products;

=head1 DESCRIPTION
    Client module to interface with the deprecated v0 API from BigCartel

=head2 METHODS
=item C<get_store_details>
    Request a store's details
=item C<get_store_products>
    Request a store's list of products
=item C<get_store_custom_page>
    Return a store's custom page details
=cut

1;
