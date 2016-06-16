#!/usr/bin/env Rscript

rmarkdown::render(
    input = "index.Rmd", 
    output_format = "html_document", 
    output_file = "index.html"
)
#bookdown::render_book("index.Rmd", "bookdown::pdf_book")
