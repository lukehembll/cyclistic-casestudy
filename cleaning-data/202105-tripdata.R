---
  title: "Cleaning May 2021"
author: "Luke Hembling"
date: '2022-05-12'
output: html_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

#### Installing packages
```{r}
install.packages("tidyverse")
install.packages("lubridate")
install.packages("skimr")
install.packages("janitor")
```

#### Loading packages
```{r}
library(tidyverse)
library(lubridate)
library(skimr)
library(janitor)
library(dplyr)
```

#### Loading the data
```{r}
tripdata <- read_csv("/cloud/project/202105-divvy-tripdata.csv")
```

#### Understanding the data
```{r}
glimpse(tripdata)
```

```{r}
str(tripdata)
```

```{r}
colnames(tripdata)
```

#### Using skim to summarise data
```{r}
skim(tripdata)
```

### Observations
* total rows in dataset is 531633

#### ride_id
* no missing data
* every row is unique (no duplicates) with 531633 id's

#### rideable_type
```{r}
unique(tripdata$rideable_type)
```
* no missing data
* 3 unique values which is correct (classic bike, docked bike and electric bike)

#### started_at
* no missing data
* datetime value
* all dates are after 2021-05-01

#### ended_at
* no missing data
* datetime value
* there are dates up to 2021-06-10

#### start_station_name
* there are 53744 missing values
* 687 unique stations

#### start_station_id
* there are missing values
* 686 unique id's
* there's one more station name than id which should not be the case
* id's are inconsistent in naming and length

#### end_station_name
* there are 58194 missing values
* 683 unique stations

#### end_station_id
* there are missing values
* 682 unique id's
* there's one more station name than id which should not be the case
* id's are inconsistent in naming and length

#### start_lat
* no missing values

#### start_lng
* no missing values

#### end_lat
* there are 452 missing values

#### end_lng
* there are 452 missing values

#### member_casual
```{r}
unique(tripdata$member_casual)
```
* no missing values
* only 2 unique values which is correct (member, casual)

### Clean names
Most names are clear and clean, however member_casual was confusing so changed to customer_type
```{r}
tripdata <-rename(tripdata,customer_type=member_casual)
```

### Drop missing rows
We can view the data with missing rows by using the following code:
```{r}
tripdata %>%
  select_all() %>%
  filter(!complete.cases(.))
```

Now to create a new data frame with NA fields omitted:
```{r}
tripdatav2 <- tripdata %>%
  select_all() %>%
  filter(complete.cases(.))
```
Viewing this data:
```{r}
head(tripdatav2)
```

We can check if the rows were removed by running the check again:
```{r}
tripdatav2 %>%
  select_all() %>%
  filter(!complete.cases(.))
```

#### Finding the extra id
Find all the unique station names to narrow it down
```{r}
uniquestations <- tripdatav2[!duplicated(tripdatav2$start_station_name), ]
```
Count all the station id's where it occurs more than once
```{r}
uniquestations %>% 
  count(start_station_id) %>% 
  filter(n > 1)
```
We can see that TA1305000039 has appeared twice, according to the other data set, the correct station name for this id is "Marshfield Ave & Cortland St so we have to remove the other rows which we can see here:
```{r}
uniquestations %>% 
  select(ride_id,start_station_id,start_station_name) %>% 
  filter(start_station_id == "TA1305000039")
```
* Elston Ave & Cortland St is the incorrect row, and we can see how many exist with:
```{r}
tripdatav2 %>% 
  filter(start_station_id == "TA1305000039" & start_station_name == "Elston Ave & Cortland St")
```
* We can see there are 114 rows of this data so we remove this data with:
```{r}
tripdatav3 <-tripdatav2[!(tripdatav2$start_station_name=="Elston Ave & Cortland St" & tripdatav2$start_station_id=="TA1305000039"),]
```
* Now the incorrect rows have been removed
* We have to do the same with the end_station_id and end_station_name now
* create a table with unique end stations:
```{r}
uniquestations2 <- tripdatav3[!duplicated(tripdatav3$end_station_name), ]
```
* filter for id's that appear twice:
```{r}
uniquestations2 %>% 
  count(end_station_id) %>% 
  filter(n > 1)
```
* TA1305000039 is the id with multiple stations here as well, and we can also see that the incorrect station name is Elston Ave & Cortland St.
```{r}
uniquestations2 %>% 
  select(ride_id,end_station_id,end_station_name) %>% 
  filter(end_station_id == "TA1305000039")
```
* See how many exist:
```{r}
tripdatav3 %>% 
  filter(end_station_id == "TA1305000039" & end_station_name == "Elston Ave & Cortland St")
```
* There are 117 that match this criteria
* Now to remove them:
```{r}
tripdatav3 <-tripdatav3[!(tripdatav3$end_station_name=="Elston Ave & Cortland St" & tripdatav3$end_station_id=="TA1305000039"),]
```
* Now the total records for the data is 450763
```{r}
skim(tripdatav3)
```
* We can see that there are no more extra id's compared to station names.

### Calculating and creating a new column for the trip duration
Calculating the trip duration column:
```{r}
tripdatav4 <- tripdatav3 %>% 
  mutate(tripduration = ended_at - started_at)
```
Checking the column has been created, should now be 14 variables:
```{r}
colnames(tripdatav4)
```
A trip duration below 0 should not exist as that would mean the ended_at time was before the start_at, so we can check by using the following:
```{r}
tripdatav4 %>% 
  filter(tripduration <= 0) %>% 
  select(ride_id,tripduration)
```
* there are 16 rows here where the trip duration is a negative value or equal to 0
* these rows need to be dropped
```{r}
tripdatav4 <- tripdatav4 %>% 
  filter(tripduration > 0) %>% 
  arrange(desc(tripduration))
```

Rows have been removed and we can look at the data again:
```{r}
skim(tripdatav4)
```
* all missing values are removed and every id is unique.

#### Round values
Rounding the values in latitude and longitude to make sure they are consistent.
```{r}
tripdatafinal <- tripdatav4 %>% 
    mutate_if(is.numeric, round, digits = 3)
```
Which is visible here:
```{r}
glimpse(tripdatafinal)
```
#### Export the data
```{r}
write.csv(tripdatafinal, "202105_tripdata_cleaned.csv", row.names=FALSE)
```





