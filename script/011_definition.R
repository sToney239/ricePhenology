reverse_name <- c(
  "播种" = "seedling",
  "出苗" = "emergence",
  "三叶" = "3-leaf",
  "移栽" = "transplanting",
  "返青" = "regreening",
  "分蘖" = "tillering",
  "孕穗" = "boot",
  "抽穗" = "heading",
  "乳熟" = "milk",
  "成熟" = "mature"
) %>% 
  names() %>% 
  set_names(
    c(
      "播种" = "seedling",
      "出苗" = "emergence",
      "三叶" = "3-leaf",
      "移栽" = "transplanting",
      "返青" = "regreening",
      "分蘖" = "tillering",
      "孕穗" = "boot",
      "抽穗" = "heading",
      "乳熟" = "milk",
      "成熟" = "mature"
    ) %>%
      as.vector()
  )
phenology_level <- c("seedling", "emergence" ,"3-leaf" ,
                     "transplanting","regreening", "tillering", 
                     "boot", "heading", "milk", "mature")

indicator_ref <- tribble(
  ~name, ~meaning, ~order,
  # temp
  "pctl_5_ave_tem", "low_temp", 1,
  "pctl_95_ave_tem", "high_temp", 1,
  "cons_pctl_5_ave_tem", "consecutive_low_temp", 2,
  "cons_pctl_95_ave_tem", "consecutive_high_temp", 2,
  # prcp
  "cons_cum_prcp", "describing_prcp", 0,
  "drought", "drought", 1,
  "pctl_95_cons_sum_prcp", "high_prcp", 1,
  "cons_pctl_95_cons_sum_prcp", "consecutive_high_prcp",2,
  "cons_drought","consecutive_drought",2,
  # ssd
  "cons_ave_ssd", "describing_ssd", 0,
  "pctl_5_cons_ave_ssd", "low_sunshine",1,
  "pctl_95_cons_ave_ssd","high_sunshine",1,
  "cons_pctl_5_cons_ave_ssd","consecutive_low_sunshine",2,
  "cons_pctl_95_cons_ave_ssd","consecutive_high_sunshine",2
)