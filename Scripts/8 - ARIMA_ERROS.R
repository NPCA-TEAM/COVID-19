###################################################################################################################################
#################################                     Cleaner                   ###################################################      
#################################                     Cleaner                   ###################################################      
###################################################################################################################################
rm(list = ls())
Sys.setlocale("LC_TIME", "English")
###################################################################################################################################
#################################                    Packsges                   ###################################################      
#################################                    Packsges                   ###################################################      
###################################################################################################################################
pacman::p_load(tidyverse, hablar, fpp3, hydroGOF, lubridate, gridExtra, grid)
###################################################################################################################################
#################################           Publication of daily cases          ###################################################
#################################           Publication of daily cases          ###################################################
###################################################################################################################################
### best model -> NHITS
### obs -> observed data (Publication of daily cases)
### sim -> output NHITS fitted

#### Experiment 1 - 2020-03-01 to 2022-10-31 (954 days)
last_day <- "31_10_2022"
best_model <- "NHITS"
variable <- "casos_publicacao"
name.var <- "Casos_Publicacao_MM_atual_PA"

#### Experiment 2 - 2020-03-01 to 2022-11-14 (988 days)
#last_day <- "14_11_2022"
#best_model <- "TFT"
#variable <- "casos_publicacao"
#name.var <- "Casos_Publicacao_MM_atual_PA"

#### Experiment 3 - 2020-03-01 to 2022-11-28 (1002 days)
#last_day <- "28_11_2022"
#best_model <- "TRANSFORMER"
#variable <- "casos_publicacao"
#name.var <- "Casos_Publicacao_MM_atual_PA"

set.obs  <- str_c("Dataset_",last_day, ".xlsx")
set.sim  <- str_c(variable,"_forecast_",best_model, "_",last_day,".csv")

read.csv(set.sim) |>
  as_tibble() |>
  mutate(data = as.Date(data)) |> 
  rename("day" = "data", "sim" = name.var) |>
  left_join(
    readxl::read_xlsx(set.obs, sheet = 1) |>
      as_tibble() |>
      mutate(data = as.Date(data)) |> 
      dplyr::select(day = data, obs = name.var)
  ) |>
  filter(!is.na(sim)) |>
  dplyr::select(day, obs, sim) |>
  as_tsibble(index = day) |>
  fill_gaps() -> series

#### Regression with ARIMA erros
series %>% model(arima0 = ARIMA(obs ~ -1 + 1 * sim,  stepwise = FALSE, approx = FALSE),
                 arima1 = ARIMA(obs ~      1 * sim,  stepwise = FALSE, approx = FALSE),
                 arima2 = ARIMA(obs ~ -1 +     sim,  stepwise = FALSE, approx = FALSE),
                 arima3 = ARIMA(obs ~          sim,  stepwise = FALSE, approx = FALSE)) -> fit

#### saving in Rdata
fit_cp <- fit
save(fit_cp, file = "fit_cp.Rdata")

#### loading models
load("fit_cp.Rdata")
fit_cp -> fit

#### criteria selection best models -> AICc
glance(fit) |> arrange(AICc) %>% dplyr::select(.model:BIC) %>% print(n = Inf) -> best_arima
best_arima_fit <- fit |> dplyr::select(best_arima$.model[1])

#### table 6. Report of estimated parameters and standard errors modeled by ARIMA (publication cases).
best_arima_fit |> coef() |> dplyr::select(term, estimate, std.error)

#### Evaluating accuracy -> training
best_arima_fit |> accuracy() |> arrange(RMSE) %>% print(n = Inf)

############## Residual diagnostics
best_arima_fit |> gg_tsresiduals(lag = 30)

############## Forecasting for 7 days
forecast(best_arima_fit, new_data = new_data(series, 7) |> mutate(sim = series$sim[(nrow(series) - 6):nrow(series)])) |> print(n = Inf)

###################################################################################################################################
#################################          Cases by day of first symptom        ###################################################
#################################          Cases by day of first symptom        ###################################################
###################################################################################################################################
### best model -> TCN
### obs -> observed data (Cases by day of first symptom)
### sim -> output TCN fitted
#### Experiment 1 - 2020-03-01 to 2022-10-31 (954 days)
last_day <- "31_10_2022"
best_model <- "TCN"
variable <- "casos_sintoma"
name.var <- "Casos_DataSintoma_MM_atual_PA"

#### Experiment 2 - 2020-03-01 to 2022-11-14 (988 days)
#last_day <- "14_11_2022"
#best_model <- "TFT"
#variable <- "casos_sintoma"
#name.var <- "Casos_DataSintoma_MM_atual_PA"

#### Experiment 3 - 2020-03-01 to 2022-11-28 (1002 days)
#last_day <- "28_11_2022"
#best_model <- "NHITS"
#variable <- "casos_sintoma"
#name.var <- "Casos_DataSintoma_MM_atual_PA"

set.obs  <- str_c("Dataset_",last_day, ".xlsx")
set.sim  <- str_c(variable,"_forecast_",best_model, "_",last_day,".csv")

read.csv(set.sim) |>
  as_tibble() |>
  mutate(data = as.Date(data)) |> 
  rename("day" = "data", "sim" = name.var) |>
  left_join(
    readxl::read_xlsx(set.obs, sheet = 1) |>
      as_tibble() |>
      mutate(data = as.Date(data)) |> 
      dplyr::select(day = data, obs = name.var)
  ) |>
  filter(!is.na(sim)) |>
  dplyr::select(day, obs, sim) |>
  as_tsibble(index = day) |>
  fill_gaps() -> series

#### Regression with ARIMA erros
series %>% model(arima0 = ARIMA(obs ~ -1 + 1 * sim,  stepwise = FALSE, approx = FALSE),
                 arima1 = ARIMA(obs ~      1 * sim,  stepwise = FALSE, approx = FALSE),
                 arima2 = ARIMA(obs ~ -1 +     sim,  stepwise = FALSE, approx = FALSE),
                 arima3 = ARIMA(obs ~          sim,  stepwise = FALSE, approx = FALSE)) -> fit

#### saving in Rdata
fit_cs <- fit
save(fit_cs, file = "fit_cs.Rdata")

#### loading models
load("fit_cs.Rdata")
fit_cs -> fit

#### criteria selection best models -> AICc
glance(fit) |> arrange(AICc) %>% dplyr::select(.model:BIC) %>% print(n = Inf) -> best_arima
best_arima_fit <- fit |> dplyr::select(best_arima$.model[1])

#### table 6. Report of estimated parameters and standard errors modeled by ARIMA (publication cases).
best_arima_fit |> coef() |> dplyr::select(term, estimate, std.error)

#### Evaluating accuracy -> training
best_arima_fit |> accuracy() |> arrange(RMSE) %>% print(n = Inf)

############## Residual diagnostics
best_arima_fit |> gg_tsresiduals(lag = 30)

############## Forecasting for 7 days
forecast(best_arima_fit, new_data = new_data(series, 7) |> mutate(sim = series$sim[(nrow(series) - 6):nrow(series)])) |> print(n = Inf)

###################################################################################################################################
#################################            Publication of daily deaths        ###################################################
#################################            Publication of daily deaths        ###################################################
###################################################################################################################################
### best model -> NHITS
### obs -> observed data (Publication of daily deaths)
### sim -> output NTHIS fitted
last_day <- "31_10_2022"
best_model <- "NHITS"
variable <- "obitos_publicacao"
name.var <- "Obitos_Publicacao_MM_atual_PA"

#### Experiment 2 - 2020-03-01 to 2022-11-14 (988 days)
#last_day <- "14_11_2022"
#best_model <- "NBEATS"
#variable <- "casos_sintoma"
#name.var <- "Obitos_Publicacao_MM_atual_PA"

#### Experiment 3 - 2020-03-01 to 2022-11-28 (1002 days)
#last_day <- "28_11_2022"
#best_model <- "NBEATS"
#variable <- "casos_sintoma"
#name.var <- "Obitos_Publicacao_MM_atual_PA"

set.obs  <- str_c("Dataset_",last_day, ".xlsx")
set.sim  <- str_c(variable,"_forecast_",best_model, "_",last_day,".csv")

read.csv(set.sim) |>
  as_tibble() |>
  mutate(data = as.Date(data)) |> 
  rename("day" = "data", "sim" = name.var) |>
  left_join(
    readxl::read_xlsx(set.obs, sheet = 1) |>
      as_tibble() |>
      mutate(data = as.Date(data)) |> 
      dplyr::select(day = data, obs = name.var)
  ) |>
  filter(!is.na(sim)) |>
  dplyr::select(day, obs, sim) |>
  as_tsibble(index = day) |>
  fill_gaps() -> series

#### Regression with ARIMA erros
series %>% model(arima0 = ARIMA(obs ~ -1 + 1 * sim,  stepwise = FALSE, approx = FALSE),
                 arima1 = ARIMA(obs ~      1 * sim,  stepwise = FALSE, approx = FALSE),
                 arima2 = ARIMA(obs ~ -1 +     sim,  stepwise = FALSE, approx = FALSE),
                 arima3 = ARIMA(obs ~          sim,  stepwise = FALSE, approx = FALSE),
                 arima4 = ARIMA(obs ~ -1 + 1 * sim + lag(sim, 14), stepwise = FALSE, approx = FALSE),
                 arima5 = ARIMA(obs ~ -1 + 1 * sim + lag(sim, 7) + lag(sim, 14), stepwise = FALSE, approx = FALSE)) -> fit

#### saving in Rdata
fit_op <- fit
save(fit_op, file = "fit_op.Rdata")

#### loading models
load("fit_op.Rdata")
fit_op -> fit

#### criteria selection best models -> AICc
glance(fit) |> arrange(AICc) %>% dplyr::select(.model:BIC) %>% print(n = Inf) -> best_arima
best_arima_fit <- fit |> dplyr::select(best_arima$.model[1])

#### table 6. Report of estimated parameters and standard errors modeled by ARIMA (publication cases).
best_arima_fit |> coef() |> dplyr::select(term, estimate, std.error)

#### Evaluating accuracy -> training
best_arima_fit |> accuracy() |> arrange(RMSE) %>% print(n = Inf)

############## Residual diagnostics
best_arima_fit |> gg_tsresiduals(lag = 30)

############## Forecasting for 7 days
forecast(best_arima_fit, new_data = new_data(series, 7) |> mutate(sim = series$sim[(nrow(series) - 6):nrow(series)])) |> print(n = Inf)
###################################################################################################################################
#################################            Deaths by day of occurrence        ###################################################
#################################            Deaths by day of occurrence        ###################################################
###################################################################################################################################
### best model -> NHITS
### obs -> observed data (Deaths by day of occurrence)
### sim -> output NTHIS fitted
### best model -> NHITS
### obs -> observed data (Publication of daily deaths)
### sim -> output NTHIS fitted
last_day <- "31_10_2022"
best_model <- "NHITS"
variable <- "obitos_ocorrencia"
name.var <- "Obitos_DataOcorrencia_MM_atual_PA"

#### Experiment 2 - 2020-03-01 to 2022-11-14 (988 days)
#last_day <- "14_11_2022"
#best_model <- "NBEATS"
#variable <- "obitos_ocorrencia"
#name.var <- "Obitos_DataOcorrencia_MM_atual_PA"

#### Experiment 3 - 2020-03-01 to 2022-11-28 (1002 days)
#last_day <- "28_11_2022"
#best_model <- "NBEATS"
#variable <- "obitos_ocorrencia"
#name.var <- "Obitos_DataOcorrencia_MM_atual_PA"

set.obs  <- str_c("Dataset_",last_day, ".xlsx")
set.sim  <- str_c(variable,"_forecast_",best_model, "_",last_day,".csv")

read.csv(set.sim) |>
  as_tibble() |>
  mutate(data = as.Date(data)) |> 
  rename("day" = "data", "sim" = name.var) |>
  left_join(
    readxl::read_xlsx(set.obs, sheet = 1) |>
      as_tibble() |>
      mutate(data = as.Date(data)) |> 
      dplyr::select(day = data, obs = name.var)
  ) |>
  filter(!is.na(sim)) |>
  dplyr::select(day, obs, sim) |>
  as_tsibble(index = day) |>
  fill_gaps() -> series

#### Regression with ARIMA erros
series %>% model(arima0 = ARIMA(obs ~ -1 + 1 * sim,  stepwise = FALSE, approx = FALSE),
                 arima1 = ARIMA(obs ~      1 * sim,  stepwise = FALSE, approx = FALSE),
                 arima2 = ARIMA(obs ~ -1 +     sim,  stepwise = FALSE, approx = FALSE),
                 arima3 = ARIMA(obs ~          sim,  stepwise = FALSE, approx = FALSE),
                 arima4 = ARIMA(obs ~ -1 + 1 * sim + lag(sim, 14), stepwise = FALSE, approx = FALSE),
                 arima5 = ARIMA(obs ~ -1 + 1 * sim + lag(sim, 7) + lag(sim, 14), stepwise = FALSE, approx = FALSE)) -> fit

#### saving in Rdata
fit_oo <- fit
save(fit_oo, file = "fit_op.Rdata")

#### loading models
load("fit_oo.Rdata")
fit_oo -> fit

#### criteria selection best models -> AICc
glance(fit) |> arrange(AICc) %>% dplyr::select(.model:BIC) %>% print(n = Inf) -> best_arima
best_arima_fit <- fit |> dplyr::select(best_arima$.model[1])

#### table 6. Report of estimated parameters and standard errors modeled by ARIMA (publication cases).
best_arima_fit |> coef() |> dplyr::select(term, estimate, std.error)

#### Evaluating accuracy -> training
best_arima_fit |> accuracy() |> arrange(RMSE) %>% print(n = Inf)

############## Residual diagnostics
best_arima_fit |> gg_tsresiduals(lag = 30)

############## Forecasting for 7 days
forecast(best_arima_fit, new_data = new_data(series, 7) |> mutate(sim = series$sim[(nrow(series) - 6):nrow(series)])) |> print(n = Inf)