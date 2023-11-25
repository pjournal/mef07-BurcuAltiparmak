
library(shiny)
library(ggplot2)
library(dplyr)

# Star Wars veri
data("starwars")

ui <- fluidPage(
  # Başlık 
  titlePanel("Star Wars Karakterleri"),
  
  # Slidebar ve SelectInput
  sidebarLayout(
    sidebarPanel(
      sliderInput("height",
                  "Minion Yüksekliği:",
                  min = 0,
                  max = 250,
                  value = c(0, 250),
                  step = 10),
      selectInput("species",
                  "Minion Türü:",
                  choices = unique(starwars$species),
                  multiple = TRUE)
    ),
    mainPanel(
      # Grafik alanını tanımlayın
      plotOutput("plot")
    )
  )
)

# Server fonksiyonunu tanımlayın
server <- function(input, output) {
  # Slidebar ve SelectInput'a bağlı olarak verileri alt kümeleyin
  filtered_data <- reactive({
    filter(starwars,
           height >= input$height[1] & height <= input$height[2],
           if (!is.null(input$species)) species %in% input$species else TRUE)
  })
  
  # Grafik çizin
  output$plot <- renderPlot({
    ggplot(filtered_data(), aes(x = height, y = mass, color = species)) +
      geom_point(size = 3) +
      labs(title = "Minion Yükseklik ve Ağırlık",
           x = "Yükseklik",
           y = "Ağırlık",
           color = "Minion Türü") +
      theme_minimal()
  })
}

# Shiny uygulamasını çalıştırın
shinyApp(ui = ui, server = server)
