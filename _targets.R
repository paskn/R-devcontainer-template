# _targets.R file
library(targets)
library(tarchetypes)

source("R/functions.R")

tar_option_set(packages = c("readr",
                            "dplyr",
                            "ggplot2",
                            "lme4",
                            ## "lmertest",
                            "simr"))

list(
  ## 1. set random seed
  tar_target(seed,
             ## 123
             12435335
             ## generated with random.org
             ## Min: 1, Max: 99999999
             ## 2024-08-06 07:49:22 UTC
             ),

  ## 2. simulate a dataset
  tar_target(syntetic_data,
             simulate_data(seed)),

  ## 3. build the model for a dataset and select effect
  tar_target(model_spec,
             build_model(
               "compliance ~ reg_type + transformation +
                (1|Country) + (1|Country:year)",
                         syntetic_data)),

  tar_target(effect_name, "transformationnothing/dem"),
  
  ## 4. define range for the effect of interest,
  ##    type of test and the number of simulations
  
  tar_target(effect_range,
             seq(-1.0, 1.0, by=.01)),

  tar_target(test_type, "z"),

  tar_target(nsims, 1000),

  ## 5. run simulations and collect power for each value of the effect 
  tar_target(analysis,
             run_analysis(
               effect_name,
               model_spec,
               effect_range,
               test_type,
               nsims,
               seed
             )),

  ## 6. save a plot in ./figs/ with results
  tar_target(record, summarize_results(analysis)),

  tar_render(report, "notebooks/report.Rmd")
)
