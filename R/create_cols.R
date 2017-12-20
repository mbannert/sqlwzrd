create_cols <- function(df){
  sql_dplyr_map <- data_frame(
    dplyr_type = c("chr","int","lgl","list","dbl"),
    pg_type = c("text","integer","boolean","json",
                "double precision")
  )
  type_v <- df %>% 
    lapply(type_sum)
  
  type_df <- data_frame(col_names = names(type_v),
                        dplyr_type = unlist(type_v)) %>% 
    inner_join(sql_dplyr_map)
  
  cols <- paste(type_df$col_names,
                type_df$pg_type,
                collapse=", ")  
  
  cols
}
