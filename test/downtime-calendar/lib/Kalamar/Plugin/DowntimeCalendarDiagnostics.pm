package Kalamar::Plugin::DowntimeCalendarDiagnostics;
use Mojo::Base 'Mojolicious::Plugin';

# Test-only endpoint. The regular Kalamar adapter defines no public API route.
sub register {
  my ($self, $app) = @_;
  $app->routes->get('/maintenance-test.json')->to(cb => sub {
    my $c = shift;
    $c->res->headers->cache_control('no-store');
    $c->render(json => {
      events => $c->downtime_calendar->public_events,
      status => $c->downtime_calendar->status,
    });
  });
}

1;
