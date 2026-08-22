# Development Import

This folder holds **development import files only**.

## Primary workbook (read-only)

- **`Bonsai Database Olaf Barmen 3.xlsx`** — Olaf’s master Excel catalog used for the one-time development migration.

Treat the workbook as **read-only**. Never modify or overwrite it from the app or migration scripts.

## Migrated development catalog

- **`OlafDevelopmentTrees.json`** — output of the one-time development migration (Tree catalog).
- **`OlafDevelopmentMigrationReport.json`** — mapping / validation report from that migration.

Regenerate with:

```bash
python3 Scripts/dev_migrate_olaf_excel.py
```

## Rules

- These files are **not** the future user Import Wizard.
- They must **not** become a parallel runtime database outside the Bonsai World Library package.
- Production libraries remain under Storage / Library Management (`Database/Trees.json` in the active library).
- Do not invent placeholder workbooks here.

## Xcode note

The synchronized `Bonsai Hub` group includes this folder. Prefer keeping the `.xlsx` for development reference; the migrated `.json` is what PreviewData / first-run seeding reads.
