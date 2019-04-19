library(shiny)

source("function.R")
#ui
ui = fluidPage(
  downloadButton("downloadData", "Salva csv"),
  fluidRow( rpivotTable::rpivotTableOutput("pivot")))


#server
server = function(input, output) { 
  output$pivot <- rpivotTable::renderRpivotTable(
    rpivotTable::rpivotTable(mtcars
      , aggregatorName = "Sum"
      , rendererName =  "Table"
      #,rows=c("vs","cyl"),cols=c("am","gear"),vals="mpg"
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
