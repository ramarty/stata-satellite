    * This test file use utilities from the repkit package - https://github.com/worldbank/repkit
    * Test if package is installed, otherwise throw error telling user to install repkit
	if 1 == 0{
		cap which repkit
		if _rc == 111 {
			di as error "{pstd}You need to have {cmd:repkit} installed to run this reproducibility package. Click {stata ssc install repkit, replace} to do so.{p_end}"
		}

		************************
		* Set up root paths (if not already set), and set up dev environment

		* Always important to version control built-in Stata functions
		version 14.1

		* Use reproot to manage root path
		reproot, project("statasat") roots("clone") prefix("statasat_")

		* Use locals for all non-root paths
		local testfldr "${statasat_clone}/src/tests"

		* Use the /dev-env folder as a dev environment
		cap mkdir    "`testfldr'/dev-env"
		repado using "`testfldr'/dev-env"

		* Make sure repkit is installed also in the dev environment
		cap which repkit
		if _rc == 111 ssc install repkit

		* Make sure the version of statasat in the dev environment is up to date with all edits.
		cap net uninstall statasat
		net install statasat, from("${statasat_clone}/src") replace
	}
    ************************
    * Run tests
	
    * Test basic case of the command query_satellite_data
    query_satellite_data, geo_dataset("gadm_410") adm_level("ADM_0") iso("ABW AFG") ///
						  sat_dataset("blackmarble") ///
					      date_unit("annual") date_start("2020") date_end("2023") ///
					      file_name("~/Desktop/ntl_annual.dta")

    // Add more tests here...
