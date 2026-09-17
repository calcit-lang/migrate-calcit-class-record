
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

### License

MIT
