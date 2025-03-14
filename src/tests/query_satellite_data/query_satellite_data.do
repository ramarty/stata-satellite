net install ietoolkit , from("https://raw.githubusercontent.com/ramarty/stata-satellite/main/src") replace

query_satellite_data, geo_dataset("gadm_410") adm_level("ADM_0") iso("ABW AFG") ///
					  sat_dataset("blackmarble") ///
					  date_unit("annual") date_start("2020") date_end("2023") ///
					  file_name("~/Desktop/ntl_annual.dta")
