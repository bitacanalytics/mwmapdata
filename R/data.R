#' Malawi Administrative Boundaries - Level 0 (Country)
#'
#' National boundary of Malawi at administrative level 0.
#'
#' @format An sf object with 1 feature and 5 fields:
#' \describe{
#'   \item{ADM0_EN}{Country name (Malawi)}
#'   \item{ADM0_PCODE}{Country ISO code (MW)}
#'   \item{area_sqkm}{Area in square kilometres}
#'   \item{center_lat}{Centroid latitude}
#'   \item{center_lon}{Centroid longitude}
#'   \item{geometry}{MULTIPOLYGON geometry for the national boundary}
#' }
#' @source Malawi Spatial Data Platform (MASDAP) / OCHA HDX, version 2 (2023)
#' @keywords datasets
"mw_level_0"

#' Malawi Administrative Boundaries - Level 1 (Regions)
#'
#' The three administrative regions of Malawi: Northern, Central, and Southern.
#'
#' @format An sf object with 3 features and 7 fields:
#' \describe{
#'   \item{ADM1_EN}{Region name (Northern, Central, Southern)}
#'   \item{ADM1_PCODE}{Region code (MW1, MW2, MW3)}
#'   \item{ADM0_EN}{Country name}
#'   \item{ADM0_PCODE}{Country code}
#'   \item{area_sqkm}{Area in square kilometres}
#'   \item{center_lat}{Centroid latitude}
#'   \item{center_lon}{Centroid longitude}
#'   \item{geometry}{MULTIPOLYGON geometry for regional boundaries}
#' }
#' @source Malawi Spatial Data Platform (MASDAP) / OCHA HDX, version 2 (2023)
#' @keywords datasets
"mw_level_1"

#' Malawi Administrative Boundaries - Level 2 (Districts)
#'
#' District-level administrative boundaries for all 32 districts of Malawi,
#' including the four city districts (Blantyre City, Lilongwe City, Mzuzu City,
#' Zomba City) added in the 2023 boundary update.
#'
#' @format An sf object with 32 features and 12 fields:
#' \describe{
#'   \item{ADM2_EN}{District name (e.g., Lilongwe, Blantyre, Mzimba)}
#'   \item{ADM2_PCODE}{District code (e.g., MW201)}
#'   \item{ADM1_EN}{Region name}
#'   \item{ADM1_PCODE}{Region code}
#'   \item{ADM0_EN}{Country name}
#'   \item{ADM0_PCODE}{Country code}
#'   \item{area_sqkm}{Area in square kilometres}
#'   \item{center_lat}{Centroid latitude}
#'   \item{center_lon}{Centroid longitude}
#'   \item{REGION}{Region name (convenience alias for ADM1_EN)}
#'   \item{DISTRICT}{District name (convenience alias for ADM2_EN)}
#'   \item{geometry}{MULTIPOLYGON geometry for district boundaries}
#' }
#' @source Malawi Spatial Data Platform (MASDAP) / OCHA HDX, version 2 (2023)
#' @keywords datasets
"mw_level_2"

#' Malawi Administrative Boundaries - Level 3 (Traditional Authorities)
#'
#' Traditional Authority (TA) level administrative boundaries representing
#' third-level subdivisions within districts, governed by traditional leaders.
#'
#' @format An sf object with 433 features and 15 fields:
#' \describe{
#'   \item{ADM3_EN}{Traditional Authority name}
#'   \item{ADM3_PCODE}{Traditional Authority code}
#'   \item{ADM3_REF}{Reference name for the Traditional Authority}
#'   \item{ADM2_EN}{District name}
#'   \item{ADM2_PCODE}{District code}
#'   \item{ADM1_EN}{Region name}
#'   \item{ADM1_PCODE}{Region code}
#'   \item{ADM0_EN}{Country name}
#'   \item{ADM0_PCODE}{Country code}
#'   \item{area_sqkm}{Area in square kilometres}
#'   \item{center_lat}{Centroid latitude}
#'   \item{center_lon}{Centroid longitude}
#'   \item{DISTRICT}{District name (convenience alias for ADM2_EN)}
#'   \item{TA}{Traditional Authority name (convenience alias for ADM3_EN)}
#'   \item{geometry}{MULTIPOLYGON geometry for TA boundaries}
#' }
#' @source Malawi Spatial Data Platform (MASDAP) / OCHA HDX, version 2 (2023)
#' @keywords datasets
"mw_level_3"

#' Major Lakes of Malawi
#'
#' Spatial data for the major lakes in Malawi:
#' Lake Malawi (Lake Nyasa), Lake Malombe, and Lake Chilwa.
#'
#' @format An sf object with 3 features and 3 fields:
#' \describe{
#'   \item{name}{Lake name}
#'   \item{area_km2}{Approximate surface area in square kilometres}
#'   \item{max_depth_m}{Maximum depth in metres (where available)}
#'   \item{geometry}{MULTIPOLYGON geometry for lake boundaries}
#' }
#' @source Malawi Spatial Data Platform (MASDAP) / Department of Surveys
#' @keywords datasets
"major_lakes"

#' Legacy Malawi States Dataset
#'
#' @description
#' **Deprecated.** Legacy dataset containing Malawi states.
#' Please use \code{mw_level_2} instead.
#'
#' @format An sf object (deprecated)
#' @keywords internal
"malawi_data"


#' Check if mwmapdata spatial data is valid
#'
#' A utility to confirm that the spatial objects in \pkg{mwmapdata} are
#' well-formed sf objects.
#'
#' @param x An sf object to check. Defaults to \code{mw_level_2}.
#' @return Logical. \code{TRUE} if \code{x} is a valid sf object.
#' @importFrom sf st_is_valid
#' @export
mwmapdata_check <- function(x = mw_level_2) {
  inherits(x, "sf") && all(sf::st_is_valid(x))
}
