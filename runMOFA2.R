##########################
# Run before code:
# ml python/3.10.2
# source /apps/where/you/install/mofapy2_07/bin/activate
# ml R
##########################

##########################
# Order of loading libraries is important!!!
##########################
library(data.table)
library(MOFA2)

lmodt<-fread('mofa2_dataset_kegg.csv')
MOFAobject <- create_mofa(lmodt)
data_opts <- get_default_data_options(MOFAobject)
model_opts <- get_default_model_options(MOFAobject)
train_opts <- get_default_training_options(MOFAobject)
model_opts$num_factors<-6
train_opts$maxiter <- 100000
train_opts$convergence_mode <- 'slow'
MOFAobject <- prepare_mofa(
  object = MOFAobject,
  data_options = data_opts,
  model_options = model_opts,
  training_options = train_opts
)
outfile = file.path(getwd(),"model_kegg.hdf5")
MOFAobject.trained <- run_mofa(MOFAobject, outfile)
model <- load_model(outfile)
head(model@cache$variance_explained$r2_per_factor[[1]]) 
saveRDS(model,'mofa2_model_kegg.rds')