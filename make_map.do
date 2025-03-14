* Example of Making a Map

* Install packages -------------------------------------------------------------
* net install statasat , from("https://raw.githubusercontent.com/ramarty/stata-satellite/master/src") replace
capture ssc install geojson2dta
capture ssc install spmap

* Download data ----------------------------------------------------------------
query_satellite_data, geo_dataset("gadm_410") adm_level("ADM_1") iso("AFG") ///
					  sat_dataset("blackmarble") ///
					  date_unit("annual") date_start("2021") date_end("2021") ///
					  file_name("~/Desktop/afg_annual_2021.dta")
						  
query_geojson, geo_dataset("gadm_410") adm_level("ADM_1") iso("AFG") file_name("~/Desktop/AFG.geojson")

* Make map ---------------------------------------------------------------------

// Clear any existing data
clear all

// Load the Stata dataset
use "~/Desktop/afg_annual_2021.dta", clear

// Save a temporary version of our data for merging later
tempfile data_file
save `data_file'

// Import the GeoJSON file using the geojson2dta command
// First, we need to install the necessary package if not already installed
geojson2dta using "~/Desktop/AFG.geojson", ///
    geocoord(coord) geodata(geodata) id(GID_1) replace

// Load the coordinate data created from the GeoJSON
use geodata, clear

// Merge with our original dataset based on GID_1
merge 1:1 GID_1 using `data_file'
keep if _merge == 3  // Keep only matched observations
drop _merge

// Install spmap if not already installed

// Create color categories for the map
egen ntl_categories = cut(ntl_sum), group(5)

// Generate a color scheme for the map
colorpalette viridis, n(5) nograph
local colors `r(p)'

// Create the map
spmap ntl_categories using coord, ///
    id(id) ///
    title("Night Time Lights in Afghanistan (2021)") ///
    legend(title("NTL Sum", size(medium)) position(5) size(*1.2)) ///
    fcolor(`colors') ///
    plotregion(margin(zero)) ///
    name(afg_ntl_map, replace)

// Add a note to the map
graph note "Data source: afg_annual_2021.dta", position(7) size(vsmall)

// Save the map as an image
graph export "~/Desktop/afghanistan_ntl_map.png", replace width(1500)
