*! version 0.1 20250314 Robert Marty rmarty@worldbank.org

cap program drop query_shp
program define query_shp

qui {
    version 14.1
    syntax, geo_dataset(string) adm_level(string) iso(string) dest_folder(string) [replace]
    
    // Create destination folder if it doesn't exist
    capture mkdir "`dest_folder'"
    
    // Define file extensions for shapefile components
    local extensions ".shp" ".prj" ".dbf" ".shx"
    
    // Base S3 URL without file extension
    local s3_base_url "https://wb-blackmarble.s3.us-east-2.amazonaws.com/`geo_dataset'/`adm_level'/`iso'/`iso'"
    
    // Download each component of the shapefile
    local success = 1
    foreach ext of local extensions {
        // Construct full URL for this extension
        local s3_url "`s3_base_url'`ext'"
        
        // Construct destination filename
        local dest_file "`dest_folder'/`iso'`ext'"
        
        // Display information about the download
        display as text "Downloading from: `s3_url'"
        display as text "Saving to: `dest_file'"
        
        // Use Stata's copy command to download the file
        capture copy "`s3_url'" "`dest_file'", `replace'
        
        // Check if the download was successful
        if _rc != 0 {
            display as error "Error downloading file: `s3_url'"
            display as error "Check your parameters and internet connection."
            local success = 0
            continue, break
        }
    }
    
    // Final success message
    if `success' == 1 {
        display as result "Download successful: Complete shapefile set saved to `dest_folder'/`iso'"
    }
}
end
