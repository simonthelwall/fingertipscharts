context("map")

library(dplyr)

df <- mapdata
ons_api <- "https://opendata.arcgis.com/datasets/687f346f5023410ba86615655ff33ca9_4.geojson"

p <- map(df,
         ons_api = ons_api,
         area_code = AreaCode,
         fill = Significance,
         title = "Life expectancy at birth",
         subtitle = "Males in Upper Tier Local Authorities England",
         copyright_year = 2019)
p1 <- map(df,
          ons_api = ons_api,
          area_code = AreaCode,
          fill = Significance,
          title = "Life expectancy at birth",
          subtitle = "Males in Upper Tier Local Authorities England",
          copyright_year = as.Date("2019-01-01"))

ons_regions <- "https://opendata.arcgis.com/datasets/f99b145881724e15a04a8a113544dfc5_3.geojson"

# Visual tests ------------------------------------------------------------

test_that("map draws correctly despite difference date inputs", {
        skip_if_offline()
        vdiffr::expect_doppelganger("map", p)
        vdiffr::expect_doppelganger("map p1", p1)
})

test_that("error messages work for map", {
        expect_error(map(df,
                         ons_api = ons_api,
                         area_code = AreaCode,
                         fill = Significance,
                         title = "Life expectancy at birth",
                         subtitle = "Males in Upper Tier Local Authorities England",
                         copyright_year = "2018"),
                     "copyright_year must be either a 4 digit numeric class or Date class")
        expect_error(map(df,
                         ons_api = ons_regions,
                         area_code = AreaCode,
                         fill = Significance,
                         title = "Life expectancy at birth",
                         subtitle = "Males in Upper Tier Local Authorities England"),
                     "There is no clear field in the shape file that contains the area codes in the field you have identified")
        expect_error(map(df,
                         ons_api = "httpstat.us/500",
                         area_code = AreaCode,
                         fill = Significance,
                         title = "Life expectancy at birth",
                         subtitle = "Males in Upper Tier Local Authorities England"),
                     "The ons_api provided is currently unavailable")
        expect_error(map(df,
                         area_code = AreaCode,
                         fill = Significance,
                         title = "Life expectancy at birth",
                         subtitle = "Males in Upper Tier Local Authorities England"),
                     "ons_api must contain a string to a geojson url on the ONS geography portal")
})

