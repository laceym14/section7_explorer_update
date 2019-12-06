# setwd("/home/jacobmalcom/open/five_year_review")

print(Sys.Date())

library(digest)
library(readr)

cur_lis <- suppressMessages(read_csv("ESA_listed.csv"))
attempt <- try(
  listed <- suppressMessages(read_csv("https://ecos.fws.gov/ecp/pullreports/catalog/species/report/species/export?format=csv&distinct=true&columns=%2Fspecies%40sn%2Ccn%2Cstatus%2Cdesc%2Clisting_date%2Ccountry%3B%2Fspecies%2Ftaxonomy%40group%3B%2Fspecies%2Ffws_region%40desc&sort=%2Fspecies%40sn%20asc&filter=%2Fspecies%40country%20!%3D%20'Foreign'&filter=%2Fspecies%40status%20in%20('Endangered'%2C'Threatened')"))
)

if(class(attempt) == "try-error") {
  att2 <- try(
    listed <- suppressMessages(read_csv("https://ecos.fws.gov/ecp/pullreports/catalog/species/report/species/export?format=csv&distinct=true&columns=%2Fspecies%40sn%2Ccn%2Cstatus%2Cdesc%2Clisting_date%2Ccountry%3B%2Fspecies%2Ftaxonomy%40group%3B%2Fspecies%2Ffws_region%40desc&sort=%2Fspecies%40sn%20asc&filter=%2Fspecies%40country%20!%3D%20'Foreign'&filter=%2Fspecies%40status%20in%20('Endangered'%2C'Threatened')"))
  )
}

if(exists("listed")) {
  if(dim(listed)[1] < 1000) {
    stop("Something is amiss.")
  } else {
    if(digest(listed) !=  digest(cur_lis)) { 
      file.rename("ESA_listed.csv", 
                  paste0("ESA_listed", Sys.Date(), ".csv"))
      write_csv(listed, "ESA_listed.csv")
      print("File backed up and new data written.")
    } else {
      print("No listing changes.")
    }
  }
} else {
  stop("Listing not downloaded from FWS.")
}


cur_5yr <- suppressMessages(read_csv("5yr_data.csv"))
att3 <- try(
  fiveyr <- suppressMessages(read_csv("https://ecos.fws.gov/ecp/pullreports/catalog/species/report/species/export?format=csv&distinct=true&columns=%2Fspecies%40sn%2Ccn%2Cstatus%2Cdesc%2Clisting_date%2Ccountry%3B%2Fspecies%2Fdocument%40doc_date%2Ctitle&sort=%2Fspecies%40cn%20asc%3B%2Fspecies%40sn%20asc%3B%2Fspecies%40country%20desc&filter=%2Fspecies%40status%20in%20('Endangered'%2C'Threatened')&filter=%2Fspecies%40country%20!%3D%20'Foreign'&filter=%2Fspecies%2Fdocument%40doc_type%20%3D%20'Five%20Year%20Review'"))
)
if(class(att3) == "try-error") {
  att4 <- try(
    fiveyr <- suppressMessages(read_csv("https://ecos.fws.gov/ecp/pullreports/catalog/species/report/species/export?format=csv&distinct=true&columns=%2Fspecies%40sn%2Ccn%2Cstatus%2Cdesc%2Clisting_date%2Ccountry%3B%2Fspecies%2Fdocument%40doc_date%2Ctitle&sort=%2Fspecies%40cn%20asc%3B%2Fspecies%40sn%20asc%3B%2Fspecies%40country%20desc&filter=%2Fspecies%40status%20in%20('Endangered'%2C'Threatened')&filter=%2Fspecies%40country%20!%3D%20'Foreign'&filter=%2Fspecies%2Fdocument%40doc_type%20%3D%20'Five%20Year%20Review'"))
  )
}

if(exists("fiveyr")) {
  if(dim(fiveyr)[1] < 1000) {
    stop("Something is amiss.")
  } else {
    if(digest(fiveyr) !=  digest(cur_5yr)) { 
      file.rename("5yr_data.csv", 
                  paste0("5yr_data", Sys.Date(), ".csv"))
      write_csv(fiveyr, "5yr_data.csv")
    } else {
      print("no 5-year review change")
    }
  }
} else {
  stop("Fiveyr data not downloaded from FWS.")
}
