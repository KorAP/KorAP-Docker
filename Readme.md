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

To run without the export plugin, set `KALAMAR_EXPORT=false` or omit `export` from `COMPOSE_PROFILES`:

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

To use your own index, please follow the instructions
on [Corpus Conversion](#corpus-conversion) first.

To run the service with a user management system, first create a directory
`data` in your working directory and then start it with

```shell
COMPOSE_PROFILES="auth" INDEX=./index docker compose -p korap up
```

Login with `user1` and `password1`. To change authentication settings, see the `/kusvakt/ldap` folder inside the docker container and Kustvakt's [LDAP Settings Wiki](https://github.com/KorAP/Kustvakt/wiki/LDAP-Setting) for documentation.

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
