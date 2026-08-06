# Custom Kalamar templates

This directory is mounted into the Kalamar container at
`/kalamar/templates/custom`. Kalamar renders a documentation page from here
whenever it does not ship one of its own -- so a `doc/corpus.html.ep` becomes
the corpus page -- and templates here can be referred to explicitly as
`custom/...`. No configuration, no rebuilt image.

To describe your own corpus, copy an example, drop the `.example` suffix and
edit it:

```bash
cp custom/doc/corpus.html.ep.example custom/doc/corpus.html.ep
$EDITOR custom/doc/corpus.html.ep
docker compose restart kalamar
```

| file | replaces |
|------|----------|
| `doc/corpus.html.ep` | the corpus page, served at `/doc/corpus` |
| `doc/citation.html.ep` | adds a references page at `/doc/citation` |
| `partial/citation/corpus.html.ep` | the corpus part of the references page, passed to it as `corpus_citation` |

The references page assembles three sections: your corpus references plus the
shipped KorAP and annotation-tool references, which you normally keep as they
are.

Templates are [Mojolicious templates][mojo-templates]: mostly HTML, with
`<%= ... %>` for embedded Perl. Files ending in `.html.md` are rendered as
Markdown instead, which is handy for longer prose.

For a translated page, put a copy under a language directory, e.g.
`de/doc/corpus.html.ep` for German; visitors get it based on their browser
language, with the unprefixed file as the default.

Files that do not correspond to a Kalamar template -- such as the `.example`
files here -- are simply ignored.

[mojo-templates]: https://docs.mojolicious.org/Mojolicious/Guides/Rendering#Embedded-Perl
