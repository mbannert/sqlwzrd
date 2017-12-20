#' @export
upsert_data <- function(db_con, df, tbl_name, schema,
                        pk){
  
  cols <- create_cols(df)
  
  sql_query <- sprintf("BEGIN;
                       CREATE TEMPORARY TABLE 
                       data_updates(%s) ON COMMIT DROP;
                       COPY data_updates FROM STDIN;",
                       cols)
  class(sql_query) <- "SQL"
  dbGetQuery(db_con,sql_query)
  postgresqlCopyInDataframe(db_con, df)
  col_chunk <- sprintf("LOCK TABLE %s.%s IN EXCLUSIVE MODE;
                       UPDATE %s.%s SET",schema,tbl_name,schema,tbl_name)
  up_cols <- paste(sprintf("%s = data_updates.%s",names(df),
                           names(df)),collapse=", ")
  
  where_chunk <- sprintf("%s FROM data_updates
                         WHERE data_updates.%s = %s.%s;",
                         up_cols, pk,
                         tbl_name, pk)
  
  selected_cols <- paste(sprintf("data_updates.%s",names(df)),
                         collapse=", ")
  
  update_chunk <- paste(col_chunk, where_chunk)
  
  insert_chunk <- sprintf("INSERT INTO %s.%s
                          SELECT %s
                          FROM data_updates
                          LEFT OUTER JOIN %s.%s
                          ON %s.%s = data_updates.%s
                          WHERE %s.%s IS NULL;
                          COMMIT;
                          ", schema, tbl_name,
                          selected_cols,
                          schema, tbl_name,
                          tbl_name, pk, pk,
                          tbl_name, pk
  )
  class(insert_chunk) <- "SQL"
  
  dbGetQuery(db_con, paste(update_chunk, insert_chunk,
                           sep = "---\n"))
  
}
