
# Load libraries ----------------------------------------------------------
require(pacman)
p_load(geodata, terra, tidyverse, glue, fs)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

# Load data ---------------------------------------------------------------

# URl base
base <- 'https://geodata.ucdavis.edu/cmip6/tiles' # There are 72 tiles

# Parameters
ssps <- c('ssp126', 'ssp245', 'ssp370', 'ssp585')
prds <- c('2021-2040', '2041-2060', '2061-2080', '2081-2100')
mdls <- c("ACCESS-CM2", "ACCESS-ESM1-5", "AWI-CM-1-1-MR", "BCC-CSM2-MR", "CanESM5", "CanESM5-CanOE", "CMCC-ESM2", "CNRM-CM6-1", "CNRM-CM6-1-HR", "CNRM-ESM2-1", "EC-Earth3-Veg", "EC-Earth3-Veg-LR", "FIO-ESM-2-0", "GFDL-ESM4", 
          "GISS-E2-1-G", "GISS-E2-1-H", "HadGEM3-GC31-LL", "INM-CM4-8", "INM-CM5-0", "IPSL-CM6A-LR", "MIROC-ES2L", "MIROC6", "MPI-ESM1-2-HR", "MPI-ESM1-2-LR", "MRI-ESM2-0", "UKESM1-0-LL")
vars <- c('prec', 'tmax', 'tmin')

# Download function -------------------------------------------------------
download_cmip6 <- function(ssp, prd, mdl, tle, out){
  
  # Proof
  # ssp <- ssps[1]
  # prd <- prds[1]
  # tle <- 28
  # out <- 'cmip6'
  # mdl <- mdls[1]
  
  # Code
  try(expr = {
    
    # To download
    cat(ssp, prd, var, sep = ' ', '\n')
    path <- glue('{base}/{mdl}/{ssp}/wc2.1_30s_{vars}_{mdl}_{ssp}_{prd}_tile-{tle}.tif')  
    dout <- glue('{out}/{basename(path)}')
    map(.x = 1:length(path), .f = function(i) download.file(url = path[i], destfile = dout[i], mode = 'wb'))
    cat('Done!\n')
    
    # Check the results
    prec <- grep('prec', dout, value = T) %>% terra::rast()
    tmax <- grep('tmax', dout, value = T) %>% terra::rast()
    tmin <- grep('prec', dout, value = T) %>% terra::rast()
    
    plot(prec)
    plot(tmax)
    plot(tmin)
    
    cat('Finish!\n')

  })
  
}

