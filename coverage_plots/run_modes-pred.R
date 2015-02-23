library('rmarkdown')

#modes <- c('G', 'noG', 'GaT', 'incG')
modes <- c('incG')
mainDir <- getwd()
for(tophat in modes){
    startTime <- Sys.time()
    render('predict_coverage.Rmd', output_dir = file.path(mainDir, tophat), clean = FALSE)
}
