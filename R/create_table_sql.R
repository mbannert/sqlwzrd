#' @export
create_table_sql <- function(df,
                             tbl_name,
                             schema,
                             pk = NULL){
  
  cols <- create_cols(df)
  
  
  if(is.null(pk)) pk <- names(df)[1]
  
  sql <- sprintf("CREATE TABLE %s.%s (%s,
                 PRIMARY KEY (%s));",
                 schema, tbl_name, cols,
                 pk)
  sql
}
