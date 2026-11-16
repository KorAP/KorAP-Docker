use Mojolicious::Lite;
app->static->paths(['/test/state']);
get '/calendar.ics' => sub { shift->reply->static('calendar.ics') };
app->start;
