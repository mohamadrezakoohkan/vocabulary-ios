#!/usr/bin/env python3
"""Generate the bundled vocabulary.sqlite database from source CSV files.

Each CSV is expected to have a header row and two columns: ``Term,Translation``.
The CSV's filename (minus extension) becomes a category name (e.g. ``a1.csv``
seeds the ``a1`` category).

Re-run this script whenever the source CSVs change. The output file is
checked into the repo so the app can ship a pre-populated database.

Usage:
    python3 Scripts/seed_vocabulary_db.py
"""
from __future__ import annotations

import csv
import json
import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT_PATH = ROOT / "Core" / "ICoreDatabase" / "Resources" / "vocabulary.sqlite"
SOURCES = [
    ROOT / "Scripts" / "seed_data" / "a1.csv",
]
ENRICHMENTS_PATH = ROOT / "Scripts" / "seed_data" / "enrichments.json"

SCHEMA = """
CREATE TABLE words (
    id TEXT PRIMARY KEY NOT NULL,
    term TEXT NOT NULL,
    phonetic TEXT,
    translation TEXT NOT NULL,
    example TEXT,
    exampleTranslation TEXT
);

CREATE TABLE categories (
    id TEXT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE wordCategories (
    wordID TEXT NOT NULL REFERENCES words(id) ON DELETE CASCADE,
    categoryID TEXT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    PRIMARY KEY (wordID, categoryID)
);

CREATE INDEX idx_wordCategories_categoryID ON wordCategories(categoryID);
"""


def word_id(term: str, translation: str) -> str:
    return f"{term.lower()}_{translation.lower()}"


def load_enrichments() -> dict[str, dict[str, str]]:
    if not ENRICHMENTS_PATH.exists():
        return {}
    with ENRICHMENTS_PATH.open(encoding="utf-8") as f:
        return json.load(f)


def main() -> None:
    OUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    if OUT_PATH.exists():
        OUT_PATH.unlink()

    conn = sqlite3.connect(OUT_PATH)
    conn.executescript(SCHEMA)

    enrichments = load_enrichments()
    enriched_count = 0
    missing_terms: set[str] = set()

    for csv_path in SOURCES:
        if not csv_path.exists():
            print(f"skip: {csv_path} not found")
            continue

        category_name = csv_path.stem
        category_id = category_name.lower()
        conn.execute(
            "INSERT OR IGNORE INTO categories (id, name) VALUES (?, ?)",
            (category_id, category_name),
        )

        with csv_path.open(newline="", encoding="utf-8") as f:
            reader = csv.reader(f)
            next(reader, None)  # skip header
            inserted = 0
            for row in reader:
                if len(row) < 2:
                    continue
                term = row[0].strip()
                translation = row[1].strip()
                if not term or not translation:
                    continue
                wid = word_id(term, translation)
                enrichment = enrichments.get(term)
                if enrichment:
                    enriched_count += 1
                else:
                    missing_terms.add(term)
                conn.execute(
                    "INSERT OR IGNORE INTO words (id, term, phonetic, translation, example, exampleTranslation) VALUES (?, ?, ?, ?, ?, ?)",
                    (
                        wid,
                        term,
                        enrichment.get("phonetic") if enrichment else None,
                        translation,
                        enrichment.get("example") if enrichment else None,
                        enrichment.get("exampleTranslation") if enrichment else None,
                    ),
                )
                conn.execute(
                    "INSERT OR IGNORE INTO wordCategories (wordID, categoryID) VALUES (?, ?)",
                    (wid, category_id),
                )
                inserted += 1

        print(f"seeded {inserted} rows from {csv_path.name} into category '{category_name}'")

    conn.commit()
    conn.close()
    print(f"wrote {OUT_PATH.relative_to(ROOT)}")
    print(f"enriched {enriched_count} word rows from enrichments.json")
    if missing_terms:
        print(f"missing enrichments for {len(missing_terms)} terms (first 10): {sorted(missing_terms)[:10]}")


if __name__ == "__main__":
    main()
