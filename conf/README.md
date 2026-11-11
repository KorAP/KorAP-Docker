# Custom Kalamar configuration

This directory is mounted into the Kalamar container at `/kalamar/conf`.
If it contains a file `kalamar.conf`, it is used as Kalamar's configuration
instead of the one shipped with the image -- including the `Kalamar`
section, plugins, localization and everything else.

```bash
cp conf/kalamar.conf.example conf/kalamar.conf
$EDITOR conf/kalamar.conf
docker compose -p korap up -d --force-recreate kalamar
```

The configuration is copied to `/kalamar/kalamar.production.conf` on every
start of the container, so changes take effect after a restart.

Things to keep in mind:

- The file is a [Mojolicious configuration][mojo-config] in Perl syntax,
  i.e. a single hash reference.
- Keep the placeholders `'PROXY_STUB'` (in `Kalamar => { proxies => [...] }`)
  and `'PLUGIN_STUB'` (in `'Kalamar-Plugins' => { default => [...] }`), unless
  you run with `KALAMAR_EXPORT=false`. They are replaced by the settings of the
  export plugin on start.
- Settings passed as environment variables, such as `KALAMAR_API` or
  `KALAMAR_PLUGINS`, still apply.
- Further files, e.g. additional localization dictionaries, can be put here
  as well and referred to as `conf/...`, e.g.
  `Localize => { resources => ['conf/kalamar.ro.dict'] }`.
- With `KALAMAR_EXPORT` enabled, the resulting configuration is printed to the
  container log on start, so better keep secrets in separate files.

To keep your configuration somewhere else, set `KALAMAR_CONF_DIR` to that
directory.

[mojo-config]: https://docs.mojolicious.org/Mojolicious/Plugin/Config
