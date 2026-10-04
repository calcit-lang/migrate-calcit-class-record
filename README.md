
Script tool to migrate `calcit.cirru` into data with class records
----

Demo http://repo.calcit-lang.org/migrate-calcit-class-record/ .

### Usages

```bash
caps --strict --ci
caps verify --toolchain
calcit calcit.cirru js
yarn vite build --base=./
```

Before changing the Snapshot, read `calcit docs read upgrade` and preview the
current stable syntax rules with
`calcit fix --preset surface-latest-v2 --format edn`.

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

Frontend assets use COS Action 1.2.0's built-in public URL verification; no
additional upload checker is needed. PR previews have independent
`<repository>/pr/<number>/<run>/<attempt>/` CDN paths. Uploads queue without
cancelling an in-progress upload. The production COS prefix and server
deployment path stay unchanged.

This deployment update retains Calcit/procs 0.27.0 and the existing dependency
versions and Caps conflict policy; it is not completion of the 0.28 migration.

### License

MIT
