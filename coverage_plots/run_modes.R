library('rmarkdown')

#modes <- c('G', 'noG', 'GaT', 'incG')
modes <- c('incG')
mainDir <- getwd()
for(tophat in modes){
    dir.create(tophat, recursive = TRUE)
    startTime <- Sys.time()
    render('coverage_plots.Rmd', output_dir = file.path(mainDir, tophat), clean = FALSE)
}
