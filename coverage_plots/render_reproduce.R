library('rmarkdown')

modes <- c('G', 'noG', 'GaT', 'incG')
mainDir <- getwd()
for(tophat in modes){
    startTime <- Sys.time()
    render('reproduce_fig.Rmd', output_dir = file.path(mainDir, tophat))
}
