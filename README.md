# mwmapdata

**mwmapdata** provides official spatial boundary datasets for Malawi, for use with the [mwmap](https://github.com/bitacanalytics/mwmap) package or any spatial analysis workflow requiring Malawi administrative boundaries.

## Datasets

| Object        | Level | Features | Description                                    |
|---------------|---------------|---------------|-----------------------------|
| `mw_level_0`  | 0     | 1        | National boundary                              |
| `mw_level_1`  | 1     | 3        | Administrative regions (N, C, S)               |
| `mw_level_2`  | 2     | 32       | Districts (incl. 4 city districts)             |
| `mw_level_3`  | 3     | 433      | Traditional authorities                        |
| `major_lakes` | —     | 1        | Lake Malawi / Lake Nyasa                       |
| `malawi_data` | 2     | 32       | Legacy alias for `mw_level_2` (**deprecated**) |

All levels include `area_sqkm`, `center_lat`, and `center_lon` columns.

Boundary data are the official **Common Operational Datasets (COD-AB)** sourced from the **National Statistics Office of Malawi**, distributed via [OCHA Humanitarian Data Exchange (HDX)](https://data.humdata.org/dataset/cod-ab-mwi), version 02 (valid from 05 April 2023).

## Installation

``` r
# From CRAN (once available)
install.packages("mwmapdata")

# Development version
remotes::install_github("bitacanalytics/mwmapdata")
```

## Usage

``` r
library(mwmapdata)
library(sf)

# Plot all 32 districts
plot(st_geometry(mw_level_2))

# Plot traditional authorities in a single district
lilongwe_tas <- mw_level_3[mw_level_3$DISTRICT == "Lilongwe", ]
plot(st_geometry(lilongwe_tas))

# Check data validity
mwmapdata_check()
```

## Data notes

- `mw_level_2` contains **32 districts**, including the 4 city districts (Blantyre City, Lilongwe City, Mzuzu City, Zomba City) added in the 2023 boundary update. Earlier datasets had 28 districts.
- `mw_level_3` contains **433 traditional authorities**, up from \~250 in earlier boundary versions.
- The `major_lakes` object contains Lake Malawi / Lake Nyasa. The administrative boundary source files do not include Lake Malombe or Lake Chilwa polygons.
- The `malawi_data` object is retained for backwards compatibility only and mirrors `mw_level_2`. Use `mw_level_2` instead.

## License

MIT © Chifundo Bita

Data: [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/) — National Statistics Office of Malawi / OCHA HDX
