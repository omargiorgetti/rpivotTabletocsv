library(shiny)
library(dragulaR)

dTitanic<-as.data.frame(Titanic)

#style = "border-width:1px;border-style:solid;"
makeElement <- function(data, name)
{
  if (class(data[[name]])=='numeric'){
    div(
      drag = name,
      div(type="button",class="btn btn-success btn-sm btn-block", name)
      #div(class = "active content", p(sprintf("Class: %s", class(data[[name]]))))
    )
  }else{
    div(
      drag = name,
      div(type="button",class="btn btn-info btn-sm btn-block", name)
      #div(class = "active content", p(sprintf("Class: %s", class(data[[name]]))))
      )
  }
}
source("function.R")
#ui
ui = fluidPage(
  fluidRow(
    column(12,
      fluidRow(
        column(4,
          h3("Dimensioni,misure:"),
          div(class="jumbotron",
            div(id = "variabili", class="container",
              lapply(colnames(dTitanic), makeElement, data = dTitanic)
            )
          )
        ),  
        column(8,
          fluidRow(     
            column(4,
              h3("Righe"),
              div(id = "righe",class="jumbotron")     
            ),
            column(4,
              h3("Colonne"),
              div(id = "colonne",class="jumbotron")  
            )
          ),
          fluidRow(
            downloadButton("downloadData", "Salva csv"),
            rpivotTable::rpivotTableOutput("pivot"),
            verbatimTextOutput("print")
          )
        )
      )
    ) 
  ),
  dragulaOutput("sel")
  
)


#server
server = function(input, output) { 
  state<-reactive({dragulaValue(input$sel)})
  output$sel <- renderDragula({
    dragula(c("variabili", "colonne","righe"))})
  
  output$pivot <- rpivotTable::renderRpivotTable(
    rpivotTable::rpivotTable(dTitanic
     , aggregatorName = "Sum"
     , rendererName =  "Table"
     ,rows=state()$righe
     ,cols=state()$colonne
     , width="50%"
     , height="550px"
     ,onRefresh=htmlwidgets::JS("
        function() { 
                    var rend = document.getElementsByClassName('pvtRenderer')['0'].value;
          var misura = document.getElementsByClassName('pvtAttrDropdown')['0'].value;
          var aggr = document.getElementsByClassName('pvtAggregator')['0'].value;
          var source = document.getElementsByClassName('pvtTable')['0'];
          var r=0;
          var data='[{\"data\":{';
          var nrow=source.rows.length
          var lastc;
          while(row=source.rows[r++])
          {
            var rowt='\"row'+r+'\":{';
            var col;
            var c=0;
            
            
            var ncol=row.cells.length
            while(cell=row.cells[c++])
            {
              col='\"col'+c+'\":{\"tagName\":\"'+cell.tagName+'\",\"innerhtml\":\"'+cell.innerHTML+'\",\"cellIndex\":'+cell.cellIndex+',\"rowSpan\":'+cell.rowSpan+',\"colSpan\":'+cell.colSpan+'}'
              if (c<ncol){col=col+','}
              rowt=rowt+col;
            }

            if (r<nrow){
              rowt=rowt+'},';
            }
            else{
              rowt=rowt+'}}';
            }
            data=data+rowt;
          }
          data=data+'}]';
          
          Shiny.onInputChange('misura', misura); 
          Shiny.onInputChange('aggr', aggr); 
          Shiny.onInputChange('data',data);
          Shiny.onInputChange('rend',rend);
        }"
      )
    )
  )
  output$print <- renderText({
    state <- dragulaValue(input$sel)
        sprintf("Variabili:\n  %s\n\nColonne:\n  %s\n\nRighe:\n  %s",
            paste(state$variabili, collapse = ", "),
            paste(state$colonne, collapse = ", "),
            paste(state$righe, collapse = ", "))
    
  })
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("pivot.csv", sep = "")
    },
    content = function(file) {
      ris<-createcsv(input$misura,input$aggr,input$data)
      print(ris)
      write.csv(ris, file, row.names = FALSE)
    }
  )
}  
shinyApp(ui = ui, server = server)
