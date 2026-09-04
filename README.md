
# Calcit class/record migration tool

Legacy browser utility for migrating data in older `calcit.cirru` files that use class records.

Demo: <https://repo.calcit-lang.org/migrate-calcit-class-record/>.

## Development

```bash
corepack yarn install --immutable
caps --ci --strict
calcit calcit.cirru edit format
calcit calcit.cirru --check-only
yarn build
```

The 0.13.77 migration checkpoint is currently waiting for the published Respo fix tracked in [calcit-lang/calcit#670](https://github.com/calcit-lang/calcit/issues/670). The repository-local warnings are fixed; released Respo 0.16.90 still reports the `decorate-defcomp` type mismatch.

Static debt that predates this upgrade is locked by `config/calcit-quality.cirru`; CI rejects regressions against that baseline.

## License

MIT
