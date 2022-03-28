# Requirements

Install [docker](https://www.docker.com/) and [docker compose](https://github.com/docker/compose).

# Starting

To download, intialize and run KorAP pointing to a certain directory index
(in this example `myindex` in the local directory), run

```shell
$ INDEX=./myindex docker-compose up
```

This will make the frontend be available at
`localhost:64543`.

# Index conversion

Depending on the corpus data to be indexed, it must first be converted.
In the case of a conversion from TEI p5/i5 format, the tools
required for this have already been installed with the above command.

In the following we assume that an i5 file `mycorpus.i5.xml` is
located in the local folder.

The command ...

```shell
$ docker run --rm -v ${PWD}:/data korap/kalamar tei2korapxml --input /data/mycorpus.i5.xml > mycorpus.zip
```

... will convert the i5 file into a KorAP-XML file using
[tei2korapxml](https://github.com/KorAP/KorAP-XML-TEI).
