# KorAP-Docker

The [KorAP Corpus Analysis Platform](http://korap.ids-mannheim.de/)
consists of several independent components,
but they can easily be installed together using
[Docker](https://www.docker.com/).
This repository contains a recipe to install all
components needed to run KorAP on your own local machine
with a single command.

## Requirements

Install [docker](https://www.docker.com/) and
[docker compose](https://github.com/docker/compose) (>= v2; as a CLI plugin).

## Starting

To get KorAP running, an index is required.
For testing, there is a test index available as a docker image. Just run

```shell
COMPOSE_PROFILES="open,example" INDEX='example-index' docker compose -p korap up
```

to start the example image and the service with Linux
(See [here](#Windows) for more information on Windows).

To hide the export plugin in Kalamar, set `KALAMAR_EXPORT=false`:

```shell
COMPOSE_PROFILES="open,example" KALAMAR_EXPORT=false INDEX='example-index' docker compose -p korap up
```

It's also possible to download the sample index provided by
[Kustvakt](https://github.com/KorAP/Kustvakt/tree/master/sample-index).
To download, intialize and run KorAP pointing to that index folder
(in this example stored in the `index` folder in the local directory),
run

```shell
COMPOSE_PROFILES="open" INDEX=./index docker compose -p korap up
```

This will make the frontend be available at
`localhost:64543`.

To use a different host port (e.g. to run alongside an existing
KorAP installation), set `KALAMAR_PORT`. It may include a bind address,
e.g. to make the frontend only reachable locally or via an SSH tunnel:

```shell
KALAMAR_PORT=127.0.0.1:3543 COMPOSE_PROFILES="open" INDEX=./index docker compose -p korap up
```

To use your own index, please follow the instructions
on [Corpus Conversion](#corpus-conversion) first.

To run the service with a user management system, first create a directory
`data` in your working directory and then start it with

```shell
COMPOSE_PROFILES="auth" INDEX=./index docker compose -p korap up
```

Login with `user1` and `password1`. To change authentication settings, see the `/kustvakt/ldap` folder inside the docker container and Kustvakt's [LDAP Settings Wiki](https://github.com/KorAP/Kustvakt/wiki/LDAP-Setting) for documentation.

On first start, Kustvakt's default configuration is copied to `data/kustvakt.conf`, where it can be adjusted (e.g. `ldap.config` or the `availability.regex.*` access policies). It is not overwritten on later starts, so remove it to get the default configuration of a newer Kustvakt image.

## Describing Your Own Corpus

The documentation pages of the user interface can be adapted without rebuilding
the Kalamar image: the `custom/` directory of this repository is mounted into
the container, and Kalamar serves a documentation page from there whenever it
does not ship one itself. To describe the corpus you are serving, copy the
example and edit it:

```shell
cp custom/doc/corpus.html.ep.example custom/doc/corpus.html.ep
$EDITOR custom/doc/corpus.html.ep
docker compose restart kalamar
```

The page is then served at `/doc/corpus`. Kalamar's documentation menu has no
corpus entry of its own; to add one, mount your own `templates/doc/navigation.json`
over the one Kalamar ships. `custom/` also contains examples for a references
page listing how to cite your corpus. See [custom/README.md](custom/README.md)
for details, and set `KALAMAR_TEMPLATES` to keep the templates somewhere else:

```shell
KALAMAR_TEMPLATES=/path/to/my-templates COMPOSE_PROFILES="open" INDEX=./index docker compose -p korap up
```

This requires Kalamar 0.66 or later.

## Serving via HTTPS

The export service is reached through Kalamar's internal proxy at
`/plugin/export/`. No separate public port is needed for the export service.

If Kalamar is served via HTTPS (e.g. behind a reverse proxy), the export
plugin has to be referred to by an absolute `https` URL, otherwise it is
rejected as insecure by the browser:

```shell
KALAMAR_EXPORT_URL=https://korap.example.org/plugin/export/export COMPOSE_PROFILES="open" INDEX=./index docker compose -p korap up
```

## Customizing the Configuration

To adapt Kalamar's configuration beyond the environment variables above
(e.g. the title addon, localization or plugins), copy the example
configuration and edit it:

```shell
cp conf/kalamar.conf.example conf/kalamar.conf
```

If `conf/kalamar.conf` exists, it replaces the configuration shipped with
the Kalamar image. See [conf/README.md](conf/README.md) for details, and set
`KALAMAR_CONF_DIR` to keep the configuration somewhere else.

## Corpus Conversion

As of June 2026, the corpus conversion, annotation and indexing process has been significantly simplified and is now orchestrated by [KorAP-Ingestion](https://github.com/KorAP/KorAP-Ingestion). In many cases, a simple `make` command is sufficient to ingest your TEI XML data and launch your own KorAP instance. For comprehensive instructions and advanced options, please refer to the [KorAP-Ingestion](https://github.com/KorAP/KorAP-Ingestion) documentation.

## Windows

Windows with Powershell requires environment variables to pass in a different way.
In addition the `PWD` variable is not set beforehand. To run the KorAP one-liner
with Windows, you have to start

```powershell
$env:INDEX='example-index'; $env:PWD='.'; $env:COMPOSE_PROFILES='open,example'; docker compose -p korap up

```

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
