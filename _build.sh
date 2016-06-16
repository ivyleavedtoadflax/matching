#!/usr/bin/env Rscript

rmarkdown::render(
    input = "index.Rmd", 
    out_format = "html", 
    out_file = "index.html"
)
#bookdown::render_book("index.Rmd", "bookdown::pdf_book")
