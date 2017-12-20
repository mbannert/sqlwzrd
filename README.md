# sqlwzrd
SQL Wizard - Using R to create SQL code

## Idea 

Call it an ORM for rstats, call it dynamically creating SQL code. Yes, I believe data structure should be 
manifested in a database, not some quirky non type safe business layer. But what if that business layer doesn't represent a workflow, process or GUI, but data? 

When SQL goes beyond SELECT and INSERT one might need to write quite some code. How about creating plain SQL and functions that generate functions to foster bulk INSERTs or UPSERTs?

## Reproducible Example
Here's a reproducible example given you got a local PostgreSQL database running and `lcon` is your connection object. 


### R
```
devtools::install_github("mbannert/sqlwzrd")
library(sqlwizrd)  # yes, I'll switch to RPostgres soon :)

qry <- create_table_sql(starwars[,1:4],"starwars","movies")
dbGetQuery(lcon,qry)
upsert_data(lcon,starwars[1:4],"starwars","movies","name")

```

### SQL
```
SELECT * FROM movies.starwars LIMIT 5;
```

will return 


| name  | height | mass | hair_color |
| ------------- | ------------- | ------------- | ------------- |
|  Luke Skywalker |    172 |   77 | blond  |
| C-3PO          |    167 |   75 | |
| R2-D2          |     96 |   32 | |
| Darth Vader    |    202 |  136 | none |
|  Leia Organa    |    150 |   49 | brown |







