*! version XX XXXXXXXXX ADAUTHORNAME ADCONTACTINFO

cap program drop   statasat
    program define statasat

qui {

    version /* ADD VERSION NUMBER HERE */

    * Do not manually edit these locals. They are updated with ad_publish in the adodown workflow
    local version     ""
    local versionDate ""
    local cmd         "statasat"

    * Update the syntax. This is only a placeholder to make the command run
    syntax [anything]

    //TODO : implement command here
    
}
end
