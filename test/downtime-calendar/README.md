This test is maintained on the dedicated `downtime-calendar-test` branch.
The test builds the regular `../Kalamar/Dockerfile` from a checkout containing
the bundled calendar sources. The general KorAP-Docker recipe stays unchanged.

# Local downtime-calendar test

Runs a separate Kalamar frontend against the existing local `korap` backend.
The normal Compose recipe and the shared Nextcloud calendar are unchanged.

The test uses the most recent **worker-05** event from the shared calendar. Its
Location is empty in Nextcloud, so `prepare-calendar.pl` sets **Location=worker-05
in a local copy only**. The original event dates and summary are retained. The
generated ICS is ignored by Git and served only on the private test network.

## Prepare and start

First start the backend from the repository root, if it is not already running:

```sh
COMPOSE_PROFILES=open INDEX=./index docker compose -p korap up -d kustvakt
```

Prepare the fixture using the plugin checkout next to this repository. The
host's Perl environment needs the plugin's dependencies. Pass the DeReKoVecs
configuration file containing `downtime_calendar_url`, or set
`DOWNTIME_CALENDAR_URL` instead:

```sh
perl test/downtime-calendar/prepare-calendar.pl --config "$HOME/derekovecs/example.conf"
```

Port 64543 must be free. Stop any other local frontend using it, or set
`DOWNTIME_TEST_PORT=64544` below. Build and start the test; the regular Kalamar source tree already contains the
calendar implementation, and its dependencies use the normal Perl setup:

```sh
docker compose -f test/downtime-calendar/compose.yaml build kalamar
KORAP_HOSTNAME=worker-05 docker compose -f test/downtime-calendar/compose.yaml up -d
```

Open **http://localhost:64543/**. The first request warms the cache; reload to
see the maintenance notice. German and English landing pages use the same understated maintenance box
to the right of the introduction. On narrow screens the box sits below the
introduction. Each notice emphasizes its date/time first, followed by
a neutral “Systemwartung” / “System maintenance” label in smaller type.
Internal calendar titles, descriptions and host locations are not rendered. Its heading is “Mögliche Dienstunterbrechungen” / “Possible service
interruptions”. `/maintenance-test.json` reports public scheduling fields and cache state
for this local test. The port binds to all IPv4 interfaces, so the frontend is
also available at `http://<host-ip>:64543/`. Set
`DOWNTIME_TEST_BIND=127.0.0.1` to restrict it to loopback.

`KORAP_HOSTNAME=worker-05` deliberately pretends to be the affected host for this
Compose invocation. With no override, `uts: host` discovers the physical host
automatically, just like the regular recipe. No machine hostname is changed. By default the backend is reached through the
existing external Docker network `korap_default`; override
`DOWNTIME_BACKEND_NETWORK` if needed. The test starts no additional Kustvakt.

The worker-05 event downloaded on November 16, 2026 runs November 16–17
(all day). The plugin intentionally hides it after its exclusive end at
midnight on November 18. For later tests, select a current calendar event or
prepare a separate fixture with current dates.

## Verify both host identities

```sh
python3 test/downtime-calendar/verify.py worker-05
KORAP_HOSTNAME=korap-head-02 docker compose -f test/downtime-calendar/compose.yaml up -d --no-deps kalamar
python3 test/downtime-calendar/verify.py korap-head-02
KORAP_HOSTNAME=worker-05 docker compose -f test/downtime-calendar/compose.yaml up -d --no-deps kalamar
python3 test/downtime-calendar/verify.py worker-05
```

This checks both the diagnostic endpoint and the rendered landing page, and
leaves the frontend displaying worker-05's maintenance notice.

## Stop the test

```sh
docker compose -f test/downtime-calendar/compose.yaml down
```

This removes only the test frontend, fixture server and test network; the
external backend network and the backend containers remain available. Any
previously stopped stack can then be started again using its original recipe.

The test uses the regular optional Kalamar adapter, versioned partial and built
SCSS through the regular `../Kalamar/Dockerfile`, exactly like a normal image
build. IDS activation lives in its existing instance configuration.
There are no copied or mounted intro templates/stylesheets. Only the fixture
server and the schedule-only diagnostic route are test-specific. The regular
production adapter defines no diagnostic endpoint. The integration must be
reviewed and published before it is available in a public base-image release.
