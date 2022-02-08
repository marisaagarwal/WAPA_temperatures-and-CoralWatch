# updated as of 2022-02-08


## 1. Set up

  # point to data locale
  data_locale = "data/CoralWatchFeb22/"
  
  # point to data file
  data_file = "data.xlsx"
  
  # call to data
  CoralWatch_data =
    paste0(data_locale, data_file) %>%
    read_excel(sheet = "CoralWatch Random Survey")


## 2. Beautify data
  
  # check structure of data
  str(CoralWatch_data)

  # prune unneccesary data columns
  unused_cols = c("Project ID", "Project Activity ID", "Activity ID", "Start date",
                  "End date", "Description", "Status", "Attribution", "Site External Id",
                  "Participating as", "Photo of the reef surveyed", "location", 
                  "I used a GPS device to obtain coordinates", "Photo", 
                  "The count of unique values for colour code average.", 
                  "The count of unique values for type of coral.", "Not applicable", 
                  "Not available...22", "Not available...25", "Country")

  CoralWatch_data %<>%
    dplyr::select(!unused_cols)
  
  # rename columns 
  CoralWatch_data %<>% 
    rename(site = `Site Name`,
           group = `Group name`, 
           submitted_by = `Submitted by`,
           date = `Observation date`,
           light_condition = `Light condition`,
           depth_m = `Depth (metres)`,
           depth_ft = `Depth (feet)`,
           water_temp_C = `Water temperature (deg. C)`,
           water_temp_F = `Water temperature (deg. F)`,
           coral_number = `Coral No.`,
           colorcode_darkest = `Colour Code Darkest`,
           colorcode_lightest = `Colour Code Lightest`,
           colorcode_average = `Average.`,
           coral_type = `Coral Type`)

  # filter for only NPS affiliated CoralWatch surveys
  CoralWatch_data %<>%
    filter(group %in% c("NPS", "Charles Hambley"))

  # see which sites are present in the data
  unique(CoralWatch_data$site)
  
  # rename sites
  CoralWatch_data %<>%
    mutate(site = recode(site, 
                         `Asan Beach Gov Complex, Guam` = "adelup",
                         `Asan Beach Unit, Site A, Guam` = "asan_A",
                         `Asan Beach Unit, Site B, Guam` = "asan_B",
                         `Agat Cemetery, Guam` = "agat"))
  

## 3. Input the first row of data bc the download from CoralNet removes it
## NEED TO MANUALLY UPDATE THIS EVERYTIME YOU DOWNLOAD AN UPDATED DATA FILE FROM CORALNET
  
  # find the contents of the first row 
  first_row = c(13.47568, 144.703613, "asan_A", "Charles Hambley", "Charles Hambley", "2021-05-24",
               "09:00 AM", "Full sunshine", 0, 0, 0, 0, "Snorkeling", "transect 5",
               1, "D2", "D3", 2.5, "Branching corals")
  
  # add the true first row to the bigger data frame
  CoralWatch_data = rbind(first_row, CoralWatch_data)
  
  # delete the weird latitude input added to Species in that new first row
  CoralWatch_data[1, "Species"] = NA

  
    
  