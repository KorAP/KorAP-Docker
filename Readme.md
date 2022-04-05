# KorAP-Docker

The [KorAP Corpus Analysis Platform](http://korap.ids-mannheim.de/)
consists of several independent components,
but they can easily be installed together using
[Docker](https://www.docker.com/).
This repository contains a recipe to install all
components needed to run KorAP on a local machine
with a single command.

In addition, all relevant tools are installed and
made available that are necessary for data conversion
and indexing of corpora in the widely used TEI-P5
([I5](https://www.ids-mannheim.de/en/digspra/corpus-linguistics/projects/corpus-development/ids-text-model/)) format for KorAP.
For different options of the tools we refer to the
respective repositories.


## Requirements

Install [docker](https://www.docker.com/) and
[docker compose](https://github.com/docker/compose).


## Starting

To download, intialize and run KorAP pointing to an existing index
(in this example `index` in the local directory), run

```shell
$ INDEX=./index docker-compose up
```

This will make the frontend be available at
`localhost:64543`.


## Corpus Conversion

In order to create an index based on existing
corpus data, some conversion steps are usually
necessary.
In the case of a conversion from TEI P5
([I5](https://www.ids-mannheim.de/en/digspra/corpus-linguistics/projects/corpus-development/ids-text-model/)) format,
the tools required for this have already been installed
with the command above.

In the following we take the open part of the
[Dortmunder Chatkorpus 2.2](https://www.uni-due.de/germanistik/chatkorpus/)
(Beißwenger & Storrer 2008) as an example to build an index.

The file is located at `example/dck-part1.i5.xml`.

The command ...

```shell
$ docker run --rm \
  -v ${PWD}/example/:/data korap/kalamar:latest-conv \
  tei2korapxml \
  --inline-tokens '!cmc#morpho' \
  --input /data/dck-part1.i5.xml > dck.zip
```

... will convert the i5 file into a
[KorAP-XML](https://github.com/KorAP/KorAP-XML-Krill#about-korap-xml)
file using
[tei2korapxml](https://github.com/KorAP/KorAP-XML-TEI).

This format is designed to add further arbitrary annotations
to the primary data. In this example, however, we will stick
with the inline annotations that the example corpus already
contains and will make available later under the label `cmc`.

To convert the KorAP-XML archive in a second step
into individual [Krill](https://github.com/KorAP/Krill) compatible
JSON files, the following command ...

```shell
$ mkdir json
$ docker run --rm -u root \
  -v ${PWD}/:/kalamar/data/ korap/kalamar:latest-conv\
  korapxml2krill archive \
  -z \
  -i /kalamar/data/dck.zip \
  --jobs -1 \
  --token 'cmc#morpho' \
  --base-paragraphs 'DeReKo#Structure' \
  --base-sentences 'DeReKo#Structure' \
  -o ./data/json/
```

... will use [korapxml2krill](https://github.com/KorAP/KorAP-XML-Krill).

Depending on how the source data is designed,
different parameters must be specified for the conversion.

Here, the inline token annotation is used as the basis for
word tokenization, and the included document structure is 
used for default annotation of sentence and paragraph boundaries.


## Index Creation

[Krill](https://github.com/KorAP/Krill)'s indexer tool can now
be used to index the JSON files:

```shell
$ mkdir index
$ docker run -u root --rm -v ${PWD}/:/data/ korap/kustvakt \
  Krill-Indexer.jar -c kustvakt-lite.conf \
  -i /data/json -o /data/index/
```

After that, the index can be loaded with the aforementioned
call and is searchable via the browser.

## Development and License

**Authors**: [Nils Diewald](https://www.nils-diewald.de/), Harald Lüngen, Marc Kupietz

Copyright (c) 2022, [IDS Mannheim](https://www.ids-mannheim.de/), Germany

KorAP-Docker is published under the BSD-2 License.

TODO:
```
Das Beispiel-Korpus entspricht dem Release-Korpus des
Dortmunder-Chat Corpus in der Aufbereitung von
[DeReKo](https://www.ids-mannheim.de/digspra/kl/projekte/korpora/).
Die Lizenz von DCK ist angegeben mit:

> Die zur freien Nutzung zur Verfügung gestellten Korpusdokumente bleiben Eigentum des
Projekts „Dortmunder Chat-Korpus“ am Institut für deutsche Sprache und Literatur der
Universität Dortmund. Eine Verwertung zu kommerziellen Zwecken bedarf einer
vorherigen Genehmigung.
```

## Bibliography

Beißwenger, Michael / Storrer, Angelika (2008):
Corpora of Computer-Mediated Communication.
In: Anke Lüdeling & Merja Kytö (Eds): Corpus Linguistics. An International Handbook.
Volume 1. Berlin. New York (Handbooks of Linguistics and Communication Science 29.1),
pp. 292--308.
