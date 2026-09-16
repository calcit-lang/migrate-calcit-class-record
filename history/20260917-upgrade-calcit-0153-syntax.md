# Upgrade Calcit 0.15.3 and audit syntax rules

- Raise Calcit and `@calcit/procs` from 0.14.17 to 0.15.3; all Calcit modules remain on their latest published releases.
- Read the current upgrade guide and preview `surface-latest-v2` across the complete Snapshot; no source rewrite is applicable.
- Stop marking `calcit.cirru` as generated so future migrations remain visible in review.
- Document the reproducible dependency, toolchain, JavaScript, and production-build commands.
- Record zero dynamic method dispatch and zero deprecated calls; the existing 12 schema-Dynamic slots remain confined to the tool's arbitrary legacy-Snapshot ingestion and transformation boundary.
