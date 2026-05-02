# =============================================================================
# build_data.R
# Rebuilds mwmapdata .rda files from source shapefiles.
#
# Source: OCHA HDX / Malawi Spatial Data Platform (MASDAP), version 2 (2023)
# Download: https://data.humdata.org/dataset/cod-ab-mwi
#
# Usage: run from the package root:
#   source("data-raw/build_data.R")
# =============================================================================

library(sf)

shp_dir <- "mwi_admin_boundaries.shp"
out_dir <- "data"

expected_rows <- c(
  mw_level_0 = 1L,
  mw_level_1 = 3L,
  mw_level_2 = 32L,
  mw_level_3 = 433L
)

# ── Helper functions ──────────────────────────────────────────────────────────

read_boundary <- function(filename) {
  path <- file.path(shp_dir, filename)
  if (!file.exists(path)) {
    stop("Missing source shapefile: ", path, call. = FALSE)
  }

  st_read(path, quiet = TRUE)
}

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

add_alias_cols <- function(sf_obj, level) {
  if (level >= 2) {
    sf_obj$REGION <- sf_obj$ADM1_EN
    sf_obj$DISTRICT <- sf_obj$ADM2_EN
  }
  if (level >= 3) {
    sf_obj$TA <- sf_obj$ADM3_EN
  }

  sf_obj
}

put_geometry_last <- function(sf_obj) {
  geom_col <- attr(sf_obj, "sf_column")
  sf_obj[, c(setdiff(names(sf_obj), geom_col), geom_col)]
}

finalize_boundary <- function(sf_obj, level, object_name) {
  sf_obj <- rename_adm_cols(sf_obj, level)
  sf_obj <- keep_core_cols(sf_obj, level)
  sf_obj <- add_alias_cols(sf_obj, level)
  sf_obj <- st_transform(sf_obj, 4326)
  sf_obj <- st_make_valid(sf_obj)
  sf_obj <- put_geometry_last(sf_obj)

  expected <- expected_rows[[object_name]]
  if (!is.null(expected) && nrow(sf_obj) != expected) {
    stop(
      object_name, " has ", nrow(sf_obj), " rows; expected ", expected,
      call. = FALSE
    )
  }
  if (any(!st_is_valid(sf_obj))) {
    stop(object_name, " contains invalid geometries after st_make_valid().",
         call. = FALSE)
  }

  sf_obj
}

save_dataset <- function(object, name) {
  env <- list2env(stats::setNames(list(object), name), parent = emptyenv())
  save(list = name, file = file.path(out_dir, paste0(name, ".rda")),
       envir = env, compress = "xz")
}

# ── Build each level ──────────────────────────────────────────────────────────

mw_level_0 <- read_boundary("mwi_admin0.shp")
mw_level_0 <- finalize_boundary(mw_level_0, 0, "mw_level_0")

mw_level_1 <- read_boundary("mwi_admin1.shp")
mw_level_1 <- finalize_boundary(mw_level_1, 1, "mw_level_1")

mw_level_2 <- read_boundary("mwi_admin2.shp")
mw_level_2 <- finalize_boundary(mw_level_2, 2, "mw_level_2")

mw_level_3 <- read_boundary("mwi_admin3.shp")
mw_level_3 <- finalize_boundary(mw_level_3, 3, "mw_level_3")

# Retain the deprecated object as an alias to current district boundaries.
malawi_data <- mw_level_2

# ── Save ──────────────────────────────────────────────────────────────────────

dir.create(out_dir, showWarnings = FALSE)

save_dataset(mw_level_0, "mw_level_0")
save_dataset(mw_level_1, "mw_level_1")
save_dataset(mw_level_2, "mw_level_2")
save_dataset(mw_level_3, "mw_level_3")
save_dataset(malawi_data, "malawi_data")

message("Done. Files saved to ", out_dir)
