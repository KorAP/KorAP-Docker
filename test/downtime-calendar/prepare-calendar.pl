#!/usr/bin/env perl
use Mojo::Base -strict;
use FindBin;
use lib "$FindBin::Bin/../../../Mojolicious-Plugin-DowntimeCalendar/lib";
use Getopt::Long qw(GetOptions);
use Mojo::File qw(path);
use Mojo::UserAgent;
use Mojo::Util qw(encode);
use Mojolicious::Plugin::DowntimeCalendar::Feed;

my $config;
GetOptions('config=s' => \$config) or die "Usage: $0 --config PATH\n";
my $url = $ENV{DOWNTIME_CALENDAR_URL};
if (!$url && $config) {
  ($url) = path($config)->slurp =~ /downtime_calendar_url\s*=>\s*"([^"]+)"/;
}
die "Set DOWNTIME_CALENDAR_URL or pass --config PATH\n" unless $url;
my $tx = Mojo::UserAgent->new->request_timeout(10)->max_response_size(2 * 1024 * 1024)->get($url);
die "Calendar download failed\n" unless $tx->result->is_success;
my $calendar = Mojolicious::Plugin::DowntimeCalendar::Feed->new(data => $tx->result->text);
die "Invalid calendar\n" unless $calendar;
my @events = sort {
  $b->properties->{dtstart}[0]->value cmp $a->properties->{dtstart}[0]->value
} grep {
  $_->ical_entry_type eq 'VEVENT'
    && ($_->properties->{summary}[0]->value // '') =~ /worker-05/i
} @{$calendar->entries};
die "No worker-05 event found\n" unless @events;
my $event = $events[0];
# Change only the local copy; never write to Nextcloud.
delete $event->properties->{location};
$event->add_property(location => 'worker-05');
my $fixture = Mojolicious::Plugin::DowntimeCalendar::Feed->new;
$fixture->add_entry($event);
my $state = path($FindBin::Bin, 'state')->make_path;
$state->child('calendar.ics')->spew(encode('UTF-8', $fixture->as_string));
print "Prepared local worker-05 calendar with Location=worker-05\n";
