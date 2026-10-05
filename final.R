

library(shiny)
library(readxl)
library(DT)
library(ggplot2)
library(plotly)


# BUILT-IN DATASETS

built_in_datasets <- c(
  "mtcars",
  "iris",
  "faithful"
)


# USER INTERFACE

ui <- fluidPage(
  
  titlePanel(
    "Student Survey Data Dashboard"
  ),
  
  sidebarLayout(

    
    # SIDEBAR
    
    sidebarPanel(
      
      width = 3,
      
      h4("Choose Data Source:"),
      
      radioButtons(
        "data_source",
        
        label = NULL,
        
        choices = c(
          "Built-in Dataset",
          "Upload Excel File"
        ),
        
        selected = "Built-in Dataset"
      ),
  
      conditionalPanel(
        
        condition =
          "input.data_source == 'Built-in Dataset'",
        
        selectInput(
          "built_in",
          "Select Built-in Dataset:",
          choices = built_in_datasets
        )
      ),

      
      # EXCEL FILE
      
      conditionalPanel(
        
        condition =
          "input.data_source == 'Upload Excel File'",
        
        fileInput(
          "file",
          "Upload Excel File:",
          accept = c(".xlsx")
        ),
        
        uiOutput(
          "sheet_ui"
        )
      ),
      
      
      br(),
      
      actionButton(
        "submit",
        "Load Data",
        class = "btn-primary"
      )
    ),
    

    # MAIN PANEL
    
    mainPanel(
      
      width = 9,
      
      tabsetPanel(
        
      
        # SUMMARY
        
        tabPanel(
          
          "Summary",
          
          br(),
          
          fluidRow(
            
            column(
              3,
              
              wellPanel(
                h4("Rows"),
                h3(
                  textOutput("num_rows")
                )
              )
            ),
            
            column(
              3,
              
              wellPanel(
                h4("Columns"),
                h3(
                  textOutput("num_columns")
                )
              )
            ),
            
            column(
              3,
              
              wellPanel(
                h4("Missing Values"),
                h3(
                  textOutput("missing_values")
                )
              )
            ),
            
            column(
              3,
              
              wellPanel(
                h4("Numeric Variables"),
                h3(
                  textOutput("numeric_count")
                )
              )
            )
          ),
          
          hr(),
          
          h4("Dataset Summary"),
          
          verbatimTextOutput(
            "dataSummary"
          )
        ),
        

        # DATA TABLE
        
        tabPanel(
          
          "Data Table",
          
          br(),
          
          DTOutput(
            "dataTable"
          )
        ),
        
        
      
        # VISUALIZATION
      
        tabPanel(
          
          "Visualization",
          
          br(),
          
          fluidRow(
            
            column(
              4,
              
             
              
              selectInput(
                
                "var_x",
                
                "Select X Variable",
                
                choices = NULL
              ),
              
              
              selectInput(
                
                "var_y",
                
                "Select Y Variable (Optional)",
                
                choices = NULL
              ),
              
              
              selectInput(
                
                "color_by",
                
                "Color by (Categorical Variable)",
                
                choices = NULL
              ),
              
              
              selectInput(
                
                "plot_type",
                
                "Select Plot Type",
                
                choices = c(
                  "Histogram",
                  "Boxplot",
                  "Scatter Plot"
                )
              ),
              
              
              br(),

              
              actionButton(
                
                "plot_button",
                
                "Generate Plot",
                
                class = "btn-success"
              )
            ),
            

            column(
              
              8,
              
              plotlyOutput(
                
                "plot",
                
                height = "600px"
              )
            )
          )
        ),
        

        # CORRELATION
        
        tabPanel(
          
          "Correlation",
          
          br(),
          
          h4(
            "Correlation Heatmap"
          ),
          
          helpText(
            "The heatmap shows the correlation between numeric variables."
          ),
          
          plotlyOutput(
            
            "correlation_plot",
            
            height = "600px"
          )
        ),

        
        # STATISTICS
        
        tabPanel(
          
          "Statistics",
          
          br(),
          
          h4(
            "Statistical Analysis"
          ),
          
          helpText(
            "Select a numeric variable and a categorical variable to compare groups."
          ),
          
          
          selectInput(
            
            "stat_numeric",
            
            "Numeric Variable:",
            
            choices = NULL
          ),
          
          
          selectInput(
            
            "stat_group",
            
            "Grouping Variable:",
            
            choices = NULL
          ),
          
          
          br(),
          
          
          actionButton(
            
            "run_test",
            
            "Run Statistical Test",
            
            class = "btn-primary"
          ),
          
          
          br(),
          br(),
          
          
          h4(
            "Test Result"
          ),
          
          
          verbatimTextOutput(
            "stat_result"
          )
        )
      )
    )
  )
)



# SERVER


server <- function(input, output, session) {
  
  
  # LOAD DATA

  
  selected_data <- eventReactive(
    
    input$submit,
    
    {
      
      if (
        
        input$data_source ==
        "Built-in Dataset"
        
      ) {
        
        get(
          input$built_in
        )
        
      } else {
        
        req(
          input$file,
          input$sheet
        )
        
        read_excel(
          
          input$file$datapath,
          
          sheet = input$sheet
        )
      }
    }
  )
  
  
  # EXCEL SHEET SELECTION
  
  output$sheet_ui <- renderUI({
    
    req(
      input$file
    )
    
    sheets <- excel_sheets(
      
      input$file$datapath
    )
    
    selectInput(
      
      "sheet",
      
      "Select Sheet:",
      
      choices = sheets,
      
      selected = sheets[1]
    )
  })
  
  
  
  # SUMMARY

  
  output$num_rows <- renderText({
    
    req(
      selected_data()
    )
    
    nrow(
      selected_data()
    )
  })
  
  
  output$num_columns <- renderText({
    
    req(
      selected_data()
    )
    
    ncol(
      selected_data()
    )
  })
  
  
  output$missing_values <- renderText({
    
    req(
      selected_data()
    )
    
    sum(
      is.na(
        selected_data()
      )
    )
  })
  
  
  output$numeric_count <- renderText({
    
    req(
      selected_data()
    )
    
    sum(
      
      sapply(
        
        selected_data(),
        
        is.numeric
      )
    )
  })
  
  
  output$dataSummary <- renderPrint({
    
    req(
      selected_data()
    )
    
    summary(
      selected_data()
    )
  })
  
  
  
  # DATA TABLE
  
  output$dataTable <- renderDT({
    
    req(
      selected_data()
    )
    
    datatable(
      
      selected_data(),
      
      options = list(
        
        pageLength = 10,
        
        scrollX = TRUE
      )
    )
  })
  
  
  
  # NUMERIC VARIABLES
  
  numeric_variables <- reactive({
    
    req(
      selected_data()
    )
    
    names(
      
      selected_data()
    )[
      
      sapply(
        
        selected_data(),
        
        is.numeric
      )
    ]
  })
  
  
  
  # CATEGORICAL VARIABLES
  
  categorical_variables <- reactive({
    
    req(
      selected_data()
    )
    
    names(
      
      selected_data()
    )[
      
      sapply(
        
        selected_data(),
        
        function(x) {
          
          is.character(x) ||
            is.factor(x)
        }
      )
    ]
  })
  
  
  
  # UPDATE VISUALIZATION VARIABLES
  
  
  observeEvent(
    
    selected_data(),
    
    {
      
    
      
      updateSelectInput(
        
        session,
        
        "var_x",
        
        choices =
          numeric_variables(),
        
        selected =
          ifelse(
            
            length(numeric_variables()) > 0,
            
            numeric_variables()[1],
            
            NULL
          )
      )
      
      
      
      
      updateSelectInput(
        
        session,
        
        "var_y",
        
        choices =
          numeric_variables(),
        
        selected =
          ifelse(
            
            length(numeric_variables()) > 0,
            
            numeric_variables()[1],
            
            NULL
          )
      )
      
      
      updateSelectInput(
        
        session,
        
        "color_by",
        
        choices = c(
          
          "None",
          
          categorical_variables()
        ),
        
        selected = "None"
      )
      
      
      
      updateSelectInput(
        
        session,
        
        "stat_numeric",
        
        choices =
          numeric_variables()
      )
      
      
      updateSelectInput(
        
        session,
        
        "stat_group",
        
        choices =
          categorical_variables()
      )
    }
  )
  
  

  
  plot_data <- eventReactive(
    
    input$plot_button,
    
    {
      
      req(
        selected_data(),
        input$var_x
      )
      
      data <- selected_data()
      
      
      
      # HISTOGRAM

      
      if (
        
        input$plot_type ==
        "Histogram"
        
      ) {
        
        
        if (
          
          is.null(input$color_by) ||
          
          input$color_by == "None"
          
        ) {
          
          p <- ggplot(
            
            data,
            
            aes(
              
              x =
                .data[[input$var_x]]
            )
          )
          
        } else {
          
          p <- ggplot(
            
            data,
            
            aes(
              
              x =
                .data[[input$var_x]],
              
              fill =
                .data[[input$color_by]]
            )
          )
        }
        
        
        p <- p +
          
          geom_histogram(
            
            bins = 20,
            
            alpha = 0.7
          ) +
          
          labs(
            
            title =
              paste(
                
                "Histogram of",
                
                input$var_x
              ),
            
            x =
              input$var_x,
            
            y =
              "Frequency"
          ) +
          
          theme_minimal()
        
        
        
        # BOXPLOT
        
        
      } else if (
        
        input$plot_type ==
        "Boxplot"
        
      ) {
        
        
        if (
          
          is.null(input$color_by) ||
          
          input$color_by == "None"
          
        ) {
          
          p <- ggplot(
            
            data,
            
            aes(
              
              x =
                .data[[input$var_x]],
              
              y =
                .data[[input$var_y]]
            )
          )
          
        } else {
          
          p <- ggplot(
            
            data,
            
            aes(
              
              x =
                .data[[input$var_x]],
              
              y =
                .data[[input$var_y]],
              
              fill =
                .data[[input$color_by]]
            )
          )
        }
        
        
        p <- p +
          
          geom_boxplot(
            
            alpha = 0.7
          ) +
          
          labs(
            
            title =
              paste(
                
                "Boxplot of",
                
                input$var_y,
                
                "by",
                
                input$var_x
              ),
            
            x =
              input$var_x,
            
            y =
              input$var_y
          ) +
          
          theme_minimal()
        
        
        
        # SCATTER PLOT
        
        
      } else {
        
        
        if (
          
          is.null(input$color_by) ||
          
          input$color_by == "None"
          
        ) {
          
          p <- ggplot(
            
            data,
            
            aes(
              
              x =
                .data[[input$var_x]],
              
              y =
                .data[[input$var_y]]
            )
          )
          
        } else {
          
          p <- ggplot(
            
            data,
            
            aes(
              
              x =
                .data[[input$var_x]],
              
              y =
                .data[[input$var_y]],
              
              color =
                .data[[input$color_by]]
            )
          )
        }
        
        
        p <- p +
          
          geom_point(
            
            size = 3,
            
            alpha = 0.7
          ) +
          
          labs(
            
            title =
              paste(
                
                "Scatter Plot of",
                
                input$var_x,
                
                "vs",
                
                input$var_y
              ),
            
            x =
              input$var_x,
            
            y =
              input$var_y
          ) +
          
          theme_minimal()
      }
      
      
     
      
      ggplotly(
        p
      )
    }
  )
  
  

  
  output$plot <- renderPlotly({
    
    plot_data()
  })
  
  
  
  # CORRELATION HEATMAP
  
  
  output$correlation_plot <- renderPlotly({
    
    req(
      selected_data()
    )
    
    data <- selected_data()
    
    
    numeric_data <- data[
      
      sapply(
        
        data,
        
        is.numeric
      )
    ]
    
    
    validate(
      
      need(
        
        ncol(numeric_data) >= 2,
        
        "At least two numeric variables are required for correlation analysis."
      )
    )
    
    
    correlation_matrix <- cor(
      
      numeric_data,
      
      use = "complete.obs"
    )
    
    
    plot_ly(
      
      x =
        colnames(
          correlation_matrix
        ),
      
      y =
        colnames(
          correlation_matrix
        ),
      
      z =
        correlation_matrix,
      
      type = "heatmap"
    ) %>%
      
      layout(
        
        title =
          "Correlation Heatmap",
        
        xaxis = list(
          title = ""
        ),
        
        yaxis = list(
          title = ""
        )
      )
  })
  
  
  
  # STATISTICAL TEST
  
  
  stat_result <- eventReactive(
    
    input$run_test,
    
    {
      
      req(
        
        selected_data(),
        
        input$stat_numeric,
        
        input$stat_group
      )
      
      
      data <- selected_data()
      
      
      numeric_variable <-
        data[[input$stat_numeric]]
      
      
      group_variable <-
        as.factor(
          
          data[[input$stat_group]]
        )
      
      
      clean_data <- data.frame(
        
        numeric =
          numeric_variable,
        
        group =
          group_variable
      )
      
      
      clean_data <- na.omit(
        clean_data
      )
      
      
      number_of_groups <-
        
        length(
          
          unique(
            
            clean_data$group
          )
        )
    
      
      if (
        
        number_of_groups == 2
        
      ) {
        
        test <- wilcox.test(
          
          numeric ~ group,
          
          data = clean_data
        )
        
        
        result_text <- paste(
          
          "Wilcoxon Rank-Sum Test\n\n",
          
          "Numeric Variable:",
          
          input$stat_numeric,
          
          "\n\n",
          
          "Grouping Variable:",
          
          input$stat_group,
          
          "\n\n",
          
          "Number of Groups:",
          
          number_of_groups,
          
          "\n\n",
          
          "P-value:",
          
          round(
            
            test$p.value,
            
            6
          ),
          
          "\n\n",
          
          ifelse(
            
            test$p.value < 0.05,
            
            "Interpretation: There is a statistically significant difference between the groups.",
            
            "Interpretation: There is no statistically significant difference between the groups."
          )
        )
        
        
      } else if (
        
        number_of_groups > 2
        
      ) {
        
        test <- kruskal.test(
          
          numeric ~ group,
          
          data = clean_data
        )
        
        
        result_text <- paste(
          
          "Kruskal-Wallis Test\n\n",
          
          "Numeric Variable:",
          
          input$stat_numeric,
          
          "\n\n",
          
          "Grouping Variable:",
          
          input$stat_group,
          
          "\n\n",
          
          "Number of Groups:",
          
          number_of_groups,
          
          "\n\n",
          
          "P-value:",
          
          round(
            
            test$p.value,
            
            6
          ),
          
          "\n\n",
          
          ifelse(
            
            test$p.value < 0.05,
            
            "Interpretation: There is a statistically significant difference between at least two groups.",
            
            "Interpretation: There is no statistically significant difference between the groups."
          )
        )
        
        
      } else {
        
        result_text <-
          
          "Statistical testing requires at least two groups."
      }
      
      
      result_text
    }
  )
  
  
  output$stat_result <- renderPrint({
    
    stat_result()
  })
}


shinyApp(
  ui = ui,
  server = server
)
