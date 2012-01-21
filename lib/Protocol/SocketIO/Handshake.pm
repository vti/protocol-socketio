package Protocol::SocketIO::Handshake;

use strict;
use warnings;

use overload '""' => sub { $_[0]->to_bytes }, fallback => 1;

sub new {
    my $class = shift;

    my $self = bless {@_}, $class;

    return $self;
}

sub to_bytes {
    my $self = shift;

    $self->{transports}
      ||= [qw/websocket flashsocket htmlfile xhr-polling jsonp-polling/];

    my $transports = join ',', @{$self->{transports}};

    for (qw/session_id heartbeat_timeout close_timeout/) {
        die "$_ is required" unless defined $self->{$_};
    }

    return join ':', $self->{session_id}, $self->{heartbeat_timeout},
      $self->{close_timeout}, $transports;
}

1;
