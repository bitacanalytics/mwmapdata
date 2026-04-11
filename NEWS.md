# mwmapdata 0.2.0

- Updated all boundary data to OCHA HDX (National Statistics Office of Malawi), Common Operational Datasets (COD-AB) version 02, valid from 05 April 2023 <https://data.humdata.org/dataset/cod-ab-mwi>.
- `mw_level_2` now contains **32 districts** (previously 28), reflecting the addition of Blantyre City, Lilongwe City, Mzuzu City, and Zomba City as separate administrative units.
- `mw_level_3` now contains **433 traditional authorities** (previously \~250).
- New columns available in all levels: `area_sqkm`, `center_lat`, `center_lon`.
- `mw_level_3` gains an `ADM3_REF` column with reference TA names.
- Convenience columns `REGION`, `DISTRICT`, and `TA` are preserved.

# mwmapdata 0.1.0

- Initial release.
- Provides Malawi administrative boundary data at levels 0–3.
- Includes major lakes spatial data.
- Split from the `mwmap` package to satisfy CRAN size requirements.
