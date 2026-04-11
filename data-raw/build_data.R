# =============================================================================
# build_data.R
# Rebuilds mwmapdata .rda files from source shapefiles.
#
# Source: OCHA HDX / Malawi Spatial Data Platform (MASDAP), version 2 (2023)
# Download: https://data.humdata.org/dataset/cod-ab-mwi
#
# Usage: run from the package root with devtools::load_all() active, or:
#   source("data-raw/build_data.R")
# =============================================================================

library(sf)

shp_dir <- "data-raw/shp"   # place the .shp files here
out_dir  <- "data"

# ── Helper functions ──────────────────────────────────────────────────────────

rename_adm_cols <- function(sf_obj, level) {
  n <- names(sf_obj)
  for (lv in 0:level) {
    n[n == paste0("adm", lv, "_name")]  <- paste0("ADM", lv, "_EN")
    n[n == paste0("adm", lv, "_pcode")] <- paste0("ADM", lv, "_PCODE")
  }
  names(sf_obj) <- n
  sf_obj
}

keep_core_cols <- function(sf_obj, level) {
  core <- c(
    if (level >= 3) c("ADM3_EN", "ADM3_PCODE"),
    if (level >= 2) c("ADM2_EN", "ADM2_PCODE"),
    if (level >= 1) c("ADM1_EN", "ADM1_PCODE"),
    "ADM0_EN", "ADM0_PCODE",
    "area_sqkm", "center_lat", "center_lon"
  )
  if ("adm3_ref_n" %in% names(sf_obj)) {
    names(sf_obj)[names(sf_obj) == "adm3_ref_n"] <- "ADM3_REF"
    core <- c(core, "ADM3_REF")
  }
  sf_obj[, intersect(core, names(sf_obj))]
}

# ── Build each level ──────────────────────────────────────────────────────────

mw_level_0 <- st_read(file.path(shp_dir, "mwi_admin0.shp"), quiet = TRUE)
mw_level_0 <- rename_adm_cols(mw_level_0, 0)
mw_level_0 <- keep_core_cols(mw_level_0, 0)

mw_level_1 <- st_read(file.path(shp_dir, "mwi_admin1.shp"), quiet = TRUE)
mw_level_1 <- rename_adm_cols(mw_level_1, 1)
mw_level_1 <- keep_core_cols(mw_level_1, 1)

mw_level_2 <- st_read(file.path(shp_dir, "mwi_admin2.shp"), quiet = TRUE)
mw_level_2 <- rename_adm_cols(mw_level_2, 2)
mw_level_2 <- keep_core_cols(mw_level_2, 2)
mw_level_2$REGION   <- mw_level_2$ADM1_EN
mw_level_2$DISTRICT <- mw_level_2$ADM2_EN

mw_level_3 <- st_read(file.path(shp_dir, "mwi_admin3.shp"), quiet = TRUE)
mw_level_3 <- rename_adm_cols(mw_level_3, 3)
mw_level_3 <- keep_core_cols(mw_level_3, 3)
mw_level_3$DISTRICT <- mw_level_3$ADM2_EN
mw_level_3$TA       <- mw_level_3$ADM3_EN

# ── Save ──────────────────────────────────────────────────────────────────────

save(mw_level_0, file = file.path(out_dir, "mw_level_0.rda"), compress = "xz")
save(mw_level_1, file = file.path(out_dir, "mw_level_1.rda"), compress = "xz")
save(mw_level_2, file = file.path(out_dir, "mw_level_2.rda"), compress = "xz")
save(mw_level_3, file = file.path(out_dir, "mw_level_3.rda"), compress = "xz")

message("Done. Files saved to ", out_dir)
