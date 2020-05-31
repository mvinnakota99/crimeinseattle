library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(stringr)

crime_data <- read.csv('data/updated_crime_data.csv', stringsAsFactors = FALSE) %>% data.frame() %>% na.omit()

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$select_nh <- renderUI({
    selectInput("neighborhood", label = h3("Select Neighborhood"), 
                choices = str_to_title(unique(crime_data$Neighborhood)))
  })
  
  neighborhood_graph <- function(){
    plot_data <- filter(crime_data, Neighborhood == toupper(input$neighborhood))
    crime_subcategories <- plot_data$Crime.Subcategory
    crime_subcategories_count <- as.data.frame(table(crime_subcategories))
    names(crime_subcategories_count)[1] = "Subcategory"
    return(crime_subcategories_count)
  }
  
  output$graphone <- renderPlot({
    crime_subcategories_count <- neighborhood_graph()
    p <- ggplot(crime_subcategories_count) +
      geom_bar(mapping = aes(x = Subcategory, y = Freq, fill = Freq), stat = "identity", colour="gray") +
      scale_fill_gradient(low = "white", high = "red")+
      labs(title = "Frequencies of Crime Subcategories") +
      coord_flip()
    return(p)
  })
  
  output$graphone_intro <- renderText({
    crime_subcategories_count <- neighborhood_graph()
    crime_subcategories_count <- crime_subcategories_count[with(crime_subcategories_count, order(-Freq)), ] 
    
    crime1_name <- crime_subcategories_count[1, ]$Subcategory %>% as.character() %>% str_to_title()
    crime1_frequency <- crime_subcategories_count[1, ]$Freq
    crime2_name <- crime_subcategories_count[2, ]$Subcategory %>% as.character() %>% str_to_title()
    crime2_frequency <- crime_subcategories_count[2, ]$Freq
    crime3_name <- crime_subcategories_count[3, ]$Subcategory %>% as.character() %>% str_to_title()
    crime3_frequency <- crime_subcategories_count[3, ]$Freq
  
    paste0("This graph shows the frequencies of each crime subcategory for the ", input$neighborhood, " neighborhood.",
          " The top three crimes for this neighborhood are ", crime1_name, " (", crime1_frequency, " cases), ", crime2_name,
          " (", crime2_frequency, " cases), and ", crime3_name, " (", crime3_frequency, " cases). People who live in ",
          input$neigborhood, "neighborhood should be more cautious about ", crime1_name, ", ", crime2_name, ", and ",
          crime3_name, ".")
  })
  
  output$select_pc <-renderUI({
    checkboxGroupInput("allprecinct", label = h3("Select Precinct(s)"),
                       str_to_title(unique(crime_data$Precinct)), str_to_title(unique(crime_data$Precinct)))
  })
  
  output$select_type <- renderUI ({
    checkboxGroupInput("allsubcat", label = h3("Select Categories of Crime"),
                       str_to_title(unique(crime_data$Crime.Subcategory)), str_to_title(unique(crime_data$Crime.Subcategory)))
  })

  output$plot <- renderPlot({
    if(is.null(input$allprecinct)| is.null(input$allsubcat))
      return()
    selected_data <- filter(crime_data, crime_data$Year >= input$years[1], crime_data$Year <= input$years[2],
                            crime_data$Precinct %in% toupper(input$allprecinct),
                            crime_data$Crime.Subcategory %in% toupper(input$allsubcat)
    )
    data_use <- count(group_by(selected_data, Year, Precinct))
    ggplot(data_use, aes(Year, n, group = data_use$Precinct)) +
      ggtitle("Seattle Crime Rates") +
      xlab("Year") + ylab("Rate of Crime") +
      geom_line(aes(col = Precinct)) +
      geom_point(aes(col = Precinct))
  })

  output$lowest_rate <- renderText ({
    if(is.null(input$allprecinct)| is.null(input$allsubcat))
      return()
    selected_data <- filter(crime_data, crime_data$Year >= input$years[1], crime_data$Year <= input$years[2],
                            crime_data$Precinct %in% toupper(input$allprecinct),
                            crime_data$Crime.Subcategory %in% toupper(input$allsubcat)
    )
    data_use <- count(group_by(selected_data, Year, Precinct))
    sum_pc <- data_use %>% 
      group_by(Precinct) %>% 
      summarise(sum(n))
    lowest_name <- filter(sum_pc, sum_pc$`sum(n)` == min(sum_pc$`sum(n)`))$Precinct %>% str_to_title()
    highest_name <- filter(sum_pc, sum_pc$`sum(n)` == max(sum_pc$`sum(n)`))$Precinct %>% str_to_title()
    paste("Within the selected precincts, ", lowest_name, 
          " Seattle has the lowest crime rate in general throughout the selected years (",
          input$years[1], "-", input$years[2], "), with the selected categories of crime. 
          In contrast, ", highest_name, " has the highest crime rate.")

  })
  
  output$select_timecrime <- renderUI({
    selectInput("timecrime", label = h3("Select Crime for Hourly Breakdown"), 
                choices = str_to_title(unique(crime_data$Crime.Subcategory)))
  })
  
  output$times <- renderPlot({
    times_data <- filter(crime_data, Crime.Subcategory == toupper(input$timecrime))
    time_hours <- times_data$Occurred.Time
    time_hours_count <- as.data.frame(table(time_hours))
    names(time_hours_count)[1] = "Hour"

    q <- ggplot(time_hours_count) +
      geom_bar(mapping = aes(x = Hour, y = Freq), stat = "identity", fill="#FF9999", colour="red") +
      scale_fill_manual(values = c('black', 'red'), labels = c('1', '2')) +
      labs(title = "Frequencies of Crime Throughout Day")
    return(q)
  })
  
  output$times_intro <- renderText({
    paste0("This graph shows the times of the day and the number of cases that were recorded at each 
           hour of the day for this crime. After analyzing the data about the frequencies of crime
           throughout the day, we realized that there is a certain period when a specific crime happens 
           often:")
  })
  
})