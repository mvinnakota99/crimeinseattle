# Data Cleaning + Manipulation Changes

library(lubridate)
library(dplyr)

# Read in Data to work with
crime_data <- read.csv('data/Crime_Data.csv') %>% data.frame()

# Remove the 'UNKNOWN' neighborhood
crime_data <- crime_data %>% filter(Neighborhood != 'UNKNOWN')
crime_data <- crime_data %>% filter(Precinct != 'UNKNOWN')

# Remove the 'UNKNOWN' precinct
crime_data <- crime_data %>% filter(Precinct != '')

# Change Date Formats
crime_data$Occurred.Date <- as.Date(crime_data$Occurred.Date, format = "%m/%d/%Y")
crime_data$Day <- crime_data$Occurred.Date %>% day()
crime_data$Month <- crime_data$Occurred.Date %>% month()
crime_data$Year <- crime_data$Occurred.Date %>% year()

# Year > 2008 to remove outliers
crime_data <- filter(crime_data, crime_data$Year > 2007)

# Select only needed variables
crime_data <- crime_data %>% select("Month", "Day", "Year", "Occurred.Time", "Crime.Subcategory", "Neighborhood", "Precinct")

# Fix Time 
crime_data$Occurred.Time <- as.POSIXct(sprintf("%04d", crime_data$Occurred.Time), format="%H%M")
crime_data$Occurred.Time <- hour(crime_data$Occurred.Time)

crime_data <- crime_data %>%
  filter(Crime.Subcategory != "NA")
# Function to remove long category and retain only the main category
main_category <- function(word){
  vector <- strsplit(word, "-")
  value <- vector[[1]]
  main_value <- value[1]
}

# Apply main_category function to column
crime_data$Crime.Subcategory <- crime_data$Crime.Subcategory %>% as.character() %>% lapply(main_category)

crime_data <- crime_data %>% as.matrix()

# Write to update csv
write.csv(crime_data, file = "data/updated_crime_data.csv", row.names = FALSE)

