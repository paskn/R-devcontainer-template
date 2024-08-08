## library(dplyr)
## library(lme4)
## library(lmerTest)
## library(simr)

simulate_data <- function(seed) {
  test_data <- readRDS("./data/data_law.rds")
  names(test_data)[7] <- "total_request"

  test_data$reg_type <- as.factor(test_data$reg_type)
  test_data$transformation <- as.factor(test_data$transformation)

  return(test_data)
}

build_model <- function(spec, data) {
  mod <- lmer(as.formula(spec), data=data)
  return(mod)
}

run_analysis <- function(effect_name, model, range_effect,
                         test_type, nsim, seed) {
  ## Holding the sample size constant, for what range of effect sizes
  ## do we have enough power?
  ## y = power, x = effect size
  
  effect_sensitivity <- NULL

  for (effect_size in range_effect) {
    
    fixef(model)[effect_name] <- effect_size

    run_power <- powerSim(
      ## model1,
      model,
      test = fixed(effect_name, method = test_type),
      seed = seed,
      nsim = nsim,
      progress = FALSE)

    effect_sensitivity <- rbind(effect_sensitivity,
                                data.frame(effect_size = effect_size,
                                           power = run_power$x / nsim))
  }
  return(effect_sensitivity)
}

summarize_results <- function(analysis) {
  plot <- analysis |>
    ggplot(aes(y = power, x = effect_size)) +
    geom_line(color = "blue") +
    geom_point(alpha = .5) +
    geom_hline(yintercept = 0.8,
               linetype ="dashed",
               color = "gray") +
    ylab("Power") +
    xlab("Effect Size (Raw)") +
    ggtitle("Effect Size Sensitivity (Achieved Power)",
            subtitle = "Dashed line: power = 80%") +
    theme_bw()
  
  return(plot)
}
