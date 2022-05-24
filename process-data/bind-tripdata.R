install.packages("tidyverse")

library(tidyverse)

trip2104 <- read_csv("/cloud/project/202104_tripdata_cleaned.csv")
trip2105 <- read_csv("/cloud/project/202105_tripdata_cleaned.csv")
trip2106 <- read_csv("/cloud/project/202106_tripdata_cleaned.csv")
trip2107 <- read_csv("/cloud/project/202107_tripdata_cleaned.csv")
trip2108 <- read_csv("/cloud/project/202108_tripdata_cleaned.csv")
trip2109 <- read_csv("/cloud/project/202109_tripdata_cleaned.csv")
trip2110 <- read_csv("/cloud/project/202110_tripdata_cleaned.csv")
trip2111 <- read_csv("/cloud/project/202111_tripdata_cleaned.csv")
trip2112 <- read_csv("/cloud/project/202112_tripdata_cleaned.csv")
trip2201 <- read_csv("/cloud/project/202201_tripdata_cleaned.csv")
trip2202 <- read_csv("/cloud/project/202202_tripdata_cleaned.csv")
trip2203 <- read_csv("/cloud/project/202203_tripdata_cleaned.csv")

finaltripdata <- bind_rows(trip2104, trip2105, trip2106, trip2107, trip2108, trip2109, trip2110, trip2111, trip2112, trip2201, trip2202, trip2203)

write.csv(finaltripdata, "finaltripdata.csv", row.names=FALSE)


