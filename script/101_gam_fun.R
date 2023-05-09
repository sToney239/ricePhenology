library(mgcv)
phenology_level <- c("seedling", "emergence" ,"3-leaf" ,
                     "transplanting","regreening", "tillering", 
                     "boot", "heading", "milk", "mature")

rmse_fun <- \(x) {mean(sqrt(x^2)) }
phenology_interpolation <- function(i, phenology) {
  before_i <- phenology_level[i-1]
  exact_i <- phenology_level[i]
  after_i <- phenology_level[i+1]
  
  base_transform <- phenology %>% 
    mutate(whole_range=.data[[after_i]]-.data[[before_i]],
           phenology_range = .data[[exact_i]] - .data[[before_i]]) %>% 
    mutate(station = as.factor(station),
           period = as.factor(period)) 
  data_train <- base_transform %>% 
    filter(!is.na(whole_range) & !is.na(phenology_range))
  
  gam_fit_p <- mgcv::gam(
    phenology_range~s(year, station, bs = "fs") + period + s(whole_range),
    family = poisson(),
    data = data_train
  )
  # note here  return(rmse_fun(fix_fit$residuals))
  
  fitted <- as.numeric(round(exp(predict(gam_fit_p, base_transform))))
  
  res <-
    if_else(
      is.na(base_transform[[exact_i]]),
      base_transform[[before_i]] + fitted,
      base_transform[[exact_i]])
  
  res <- if_else(
    res != base_transform[[before_i]] | is.na(base_transform[[before_i]]), 
    res , res + 1)
  return(
    list(
      interpolation = res,
      rmse = rmse_fun(data_train$phenology_range - gam_fit_p$fitted.values),
      model = gam_fit_p
    )
  )
}


write_gam_output <- function(phenology_interpolation_res) {
  if(!file.exists(here::here("data/1_index"))) {
    dir.create(here::here("data/1_index"))
  }
  phenology %>% 
    select(-c(emergence:milk)) %>% 
    bind_cols(
      map_dfc(phenology_interpolation_res, pluck, "interpolation") %>% 
        set_names(phenology_level[2:9])
    ) %>% 
    relocate(emergence:milk, .before = mature) %>% 
    write_csv(here::here("data/1_index/phenology_interpolation.csv"))
}

phenology_read_transform <- function() {
  here::here("data/0_basic/phenology.csv") %>% 
    read_csv() %>% rowwise() %>% 
    mutate(na_filter = sum(is.na(c_across(seedling:mature)))) %>% 
    filter(na_filter < 7) %>% 
    as_tibble() %>% 
    select(-na_filter)
}