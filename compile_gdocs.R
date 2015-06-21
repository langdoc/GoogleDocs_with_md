header <- '---
title: "Collaborative authoring in Google Docs"
author: "Niko Partanen"
date: "19 Jun 2015"
pdf_document:
        keep_tex: yes
bibliography: ./bibtex/FRibliography_example.bib
---
'

library(readr)

doc <- read_file("https://docs.google.com/document/d/1D1C_79nLDM25r96dWinufVUd70-ipsHzv6cK-9cK-Io/export?format=txt")

fileConn <- file("temp.txt")
writeLines(doc, fileConn)
close(fileConn)

system("cat temp.txt | tail -c +4 > temp_clean.txt")

doc <- read_file("temp_clean.txt")

doc <- gsub("(.+## References).+", "\\1", doc)
doc <- gsub("\\[.\\]", "", doc)

full_paper <- paste0(header, doc)

fileConn <- file("example.md")
writeLines(full_paper, fileConn)
close(fileConn)

library(rmarkdown)

render('example.md', output_format = "html_document")

system("pandoc example.md --latex-engine=xelatex --biblio ./bibtex/FRibliography_example.bib -o example.pdf --variable mainfont=Georgia")

system("convert -density 300  example.pdf example.jpg")
