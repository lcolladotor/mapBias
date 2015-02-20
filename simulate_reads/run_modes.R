library('rmarkdown')

modes <- c('G', 'noG', 'GaT', 'incG')
mainDir <- getwd()
for(tophat in modes){
    dir.create(tophat, recursive = TRUE)
    startTime <- Sys.time()
    render('simulate_reads.Rmd', output_dir = file.path(mainDir, tophat))
    setwd(mainDir)
}
