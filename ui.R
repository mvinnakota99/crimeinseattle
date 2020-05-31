library(shiny)
library(shinythemes)

navbarPage(theme = shinytheme("united"),
  "Criminal Activity",
  tabPanel("About",
           tags$style(type="text/css",
                      ".shiny-output-error {visibility: hidden;}",
                      ".shiny-output-error:before {visibility: hidden;}"
           ),
           h1("Crime Rates in Seattle"),
           mainPanel(
             img(src = 'crime.jpg', height = 500, width = 800, align="center"),
             h2("Overview"),
             p("The data that we explored for our final group project 
               is ‘Crime Data’ data set, which includes crime reports 
               logged in the Departments Records Management System (RMS) 
               since 2008, downloaded from", 
               a("Data.gov.",
                href = "https://catalog.data.gov/dataset/crime-data-76bd0?fbclid=IwAR34NWjPQ1rvBMGHJqf21mUXiI35vi7ul8zNjMGkmAekaRXyxx-LYgQ7A_c"),
               "The data set is provided by the Seattle Police Department 
               with reports around the Seattle area and is updated daily."),
             p("Our goal is to inform to our target audience, students and 
               homeowners who primarily work/study in or inhabit the Seattle 
               Area, which areas are the least safe around Seattle so they 
               can be more careful around those parts of town. By looking at 
               the information and statistics, people can take the necessary precautions
               to protect their safety and their possessions."),
             p("This can be achieved through various interactive graphs that show:"),
             tags$b(tags$ol(
               tags$li("Frequencies of each type of crime in a selected neighborhood
                       in Seattle"),
               tags$li("Crime rates of selected categories of crime in a selected 
                       precinct in Seattle and their trends over time"), 
               tags$li("Frequencies of a selected crime throughout the day ")
               )),
             p("We chose this data set because, living in a large and busy city like Seattle, it
               important to keep yourself and your belongings safe. With out primary target 
               auidence as homeowners and people that live in Seattle, this data set tells them
               which neighborhoods are safer than others and also which ones are more prone to some
               crimes than others. Our data intepretations and graphs allow users to take the
               necessary precautions to be safe in Seattle.")
             )
  ), 
  tabPanel("Neighborhood",
           titlePanel("Crime Rates in Seattle by Neighborhood"),
             sidebarPanel(
               helpText("You can see the distribution of the crimes 
                        for a selected neighborhood."),
               uiOutput("select_nh")),
             
             # Show a bar chart of neighborhood vs. subcatagories of crimes. 
             mainPanel(
               plotOutput("graphone"),
               br(),
               textOutput("graphone_intro")
             )
  ),
  tabPanel("Trend", 
           titlePanel("Trends of Crime Occurance throughout years"),
           sidebarPanel(
           uiOutput("select_pc"),
           uiOutput("select_type"),
           sliderInput("years", h3("Years:"),
                       2008, 2018, 
                       c(2008, 2018))),
           mainPanel(
             plotOutput("plot"),
             br(),
             uiOutput("lowest_rate"),
             img(src = 'precincts.png', height = 500, width = 450)
             )
           ),
  tabPanel("Day", 
           titlePanel("Crime Rates in Seattle by Time"),
           sidebarPanel(
             uiOutput("select_timecrime")
           ),
           mainPanel(
             plotOutput("times"),
             br(),
             textOutput("times_intro"),
             br(), 
             tags$li("Morning: Crime does not often happen during the morning."),
             tags$li("Afternoon: Family offense, theft, and pornography."), 
             tags$li("Evening: Trespass and loitering."),
             tags$li("Night: Car prowl, sex offense, weapon, burglary, robbery, 
                     aggravated assault, DUI, motor vehicle theft, narcotic, 
                     arson, prostitution, rape, homicide, liquor law violation, 
                     disorderly conduct, and gamble."),
             br(),
             p("As you can see, 16 crimes out of 21 crimes mostly happen during 
                the night. For your safety, we strongly suggest that not to travel 
                alone during the night.", tags$b("If you have to go somewhere during the night,
                make sure you travel in groups.")),
             br(),
             tags$i(p("Helpful information about hour(s):")),
             tags$b(tags$ol(
               tags$li("Morning: Hours 0 - 6"),
               tags$li("Afternoon: Hours 6 - 12"), 
               tags$li("Evening: Hours 12 - 18"),
               tags$li("Night: Hours 18 - 23")
             ))
           )
          )
)