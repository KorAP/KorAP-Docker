# KorAP-Docker

Run the [KorAP Corpus Analysis Platform](https://korap.ids-mannheim.de/) locally
with Docker Compose.

## Quick start with the example index

Start Docker with Compose installed, then run the following commands. The
example index is included as a Docker image and is loaded automatically.

```shell
git clone https://github.com/KorAP/KorAP-Docker.git
cd KorAP-Docker
COMPOSE_PROFILES=open,example INDEX=example-index docker compose -p korap up -d
```

Open [http://localhost:64543](http://localhost:64543) and search for `geht`.
The download button above the results opens the export form.

To stop the example:

```shell
COMPOSE_PROFILES=open,example INDEX=example-index docker compose -p korap down
```

See [Windows](#windows) for the PowerShell commands.

## Use your own index

Put a KorAP index in `./index` or set `INDEX` to its location. If you need to
build an index from TEI XML, see [KorAP-Ingestion](https://github.com/KorAP/KorAP-Ingestion).

```shell
COMPOSE_PROFILES=open INDEX=./index docker compose -p korap up -d
```

Set `KALAMAR_PORT` if port `64543` is already in use. For example,
`KALAMAR_PORT=127.0.0.1:3543` serves the UI at `http://localhost:3543`.

### Run with login

Stop the `open` profile before starting `auth`. Create `data/` for the
Kustvakt configuration and start the authenticated profile:

```shell
mkdir -p data
COMPOSE_PROFILES=auth INDEX=./index docker compose -p korap up -d
```

The default test login is `user1` with password `password1`. Configure access
policies in `data/kustvakt.conf`, which Compose creates on first start. See
[Kustvakt's LDAP settings](https://github.com/KorAP/Kustvakt/wiki/LDAP-Setting)
for custom authentication.

## Customize your instance

- To describe your corpus, copy `custom/doc/corpus.html.ep.example` to
  `custom/doc/corpus.html.ep`, edit it, and restart Kalamar. The page appears
  at `/doc/corpus`. See [custom/README.md](custom/README.md) for more examples.
- To change Kalamar settings, copy `conf/kalamar.conf.example` to
  `conf/kalamar.conf` and edit it. See [conf/README.md](conf/README.md).
- To serve KorAP over HTTPS, point your reverse proxy at Kalamar and forward
  all paths, including `/export/`.
- On Linux, maintenance notices use the physical hostname automatically.
  Set `KORAP_HOSTNAME` if your calendar uses a fixed hostname. Restart Kalamar
  after renaming the host.

## Windows

After cloning the repository and changing into its directory, run the example
in PowerShell:

```powershell
$env:INDEX = 'example-index'
$env:PWD = (Get-Location).Path
$env:COMPOSE_PROFILES = 'open,example'
docker compose -p korap up -d
```

Open [http://localhost:64543](http://localhost:64543) and search for `geht`.
Use `down` in place of `up -d` to stop the example.

## Rootless Podman on Linux

With [Podman](https://podman.io/), point `docker compose` at the user socket
and run the same commands as above:

```shell
systemctl --user enable --now podman.socket
export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
```

To keep containers running across logout and reboot, run
`loginctl enable-linger "$USER"` and `systemctl --user enable podman-restart`.
Use `docker compose` with the socket for the `auth` profile, which needs to wait
for its init containers. `podman-compose` supports the `open` profile.

## Development and License

**Authors**: [Nils Diewald](https://www.nils-diewald.de/), Harald Lüngen, Marc Kupietz

Copyright (c) 2022-2026, [IDS Mannheim](https://www.ids-mannheim.de/), Germany

KorAP-Docker is published under the BSD-2 License.

The example corpus corresponds to the *release part* of the
[Dortmunder Chatkorpus 2.2](https://www.uni-due.de/germanistik/chatkorpus/)
as prepared by
[DeReKo](https://www.ids-mannheim.de/digspra/kl/projekte/korpora/).
The corpus is released under the [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) License.
Legal restrictions may arise from data protection legislation.


## Bibliography

Beißwenger, Michael / Storrer, Angelika (2008):
Corpora of Computer-Mediated Communication.
In: Anke Lüdeling & Merja Kytö (Eds): *Corpus Linguistics. An International Handbook.*
Volume 1. Berlin. New York (Handbooks of Linguistics and Communication Science 29.1),
pp. 292--308.
