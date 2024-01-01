library(shiny)
library(ggplot2)
library(dplyr)

# Star Wars veri
data("starwars")

ui <- fluidPage(
  # Başlık 
  titlePanel("Star Wars Karakterleri"),
  
  # SelectizeInput
  selectizeInput("selected_species",
                 label = "Minion Türü Seçiniz:",
                 choices = c("All", unique(starwars$species)),
                 selected = "All",
                 multiple = TRUE),
  
  # Grafik alanını tanımlayın
  mainPanel(
    plotOutput("plot")
  )
)

# Server fonksiyonunu tanımlayın
server <- function(input, output) {
  
  # Seçilen türleri filtrele
  filtered_data <- reactive({
    if (input$selected_species != "All") {
      filter(starwars, species %in% input$selected_species)
    } else {
      starwars
    }
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
