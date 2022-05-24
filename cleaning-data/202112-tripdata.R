---
  title: "Cleaning December 2021"
output: html_document
date: '2022-05-13'
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
tripdata <- read_csv("/cloud/project/202112-divvy-tripdata.csv")
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

* total rows in dataset is 247540

#### ride_id

* no missing data
* every row is unique (no duplicates) with 247540 id's

#### rideable_type

```{r}
unique(tripdata$rideable_type)
```

* no missing data
* 3 unique values which is correct (classic bike, docked bike and electric bike)

#### started_at

* no missing data
* datetime value
* all dates are after 2021-12-01

#### ended_at

* no missing data
* datetime value
* there are dates up to 2022-01-03

#### start_station_name

* there are 51063 missing values
* 818 unique stations

#### start_station_id

* there are 51063 missing values
* 816 unique id's
* there's two more station names than id
* id's are inconsistent in naming and length

#### end_station_name

* there are 53498 missing values
* 800 unique stations

#### end_station_id

* there are 53498 missing values
* 798 unique id's
* two more end station names than id's
* id's are inconsistent in naming and length

#### start_lat

* no missing values

#### start_lng

* no missing values

#### end_lat

* there are 144 missing values

#### end_lng

* there are 144 missing values

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
* 71,169 records with missing data
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
* checking the data using skim again, there is still 2 more unique name than station id:
```{r}
skim(tripdatav2)
```

#### Finding the extra station
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
* start_station_id 13099 and TA1306000029 appear more than once meaning they have multiple station names.
```{r}
uniquestations %>% 
  select(start_station_id, start_station_name) %>% 
  filter(start_station_id == "13099")
```

```{r}
uniquestations %>% 
  select(start_station_id, start_station_name) %>% 
  filter(start_station_id == "TA1306000029")
```
* "Halsted St & 18th St (Temp)" is the correct value for 13099 station name while "Halsted St & 18th St" is incorrect after looking at the other datasets.
* "DuSable Lake Shore Dr & Ohio St" is the correct value for TA1306000029 while McClurg Ct & Ohio St is incorrect
* removing the record:
  ```{r}
tripdatav2 <- tripdatav2[!(tripdatav2$start_station_name=="McClurg Ct & Ohio St" & tripdatav2$start_station_id=="TA1306000029"),]
```

```{r}
tripdatav2 <- tripdatav2[!(tripdatav2$start_station_name=="Halsted St & 18th St" & tripdatav2$start_station_id=="13099"),]
```
* extra rows are now removed
```{r}
skim(tripdatav2)
```
* Now we have to do the same thing with end station data:
  ```{r}
uniquestations2 <- tripdatav2[!duplicated(tripdatav2$end_station_name), ]
```
Count all the station id's where it occurs more than once
```{r}
uniquestations2 %>% 
  count(end_station_id) %>% 
  filter(n > 1)
```
* same two from earlier
```{r}
uniquestations2 %>% 
  select(end_station_id, end_station_name) %>% 
  filter(end_station_id == "13099")
```
* two values here are "Halsted St & 18th St (Temp)" and "Halsted St & 18th St"
```{r}
uniquestations2 %>% 
  select(end_station_id, end_station_name) %>% 
  filter(end_station_id == "TA1306000029")
```
* two values here are "DuSable Lake Shore Dr & Ohio St"	and "McClurg Ct & Ohio St"
* removing the records
```{r}
tripdatav3 <- tripdatav2[!(tripdatav2$end_station_name=="Halsted St & 18th St" & tripdatav2$end_station_id=="13099"),]
```

```{r}
tripdatav3 <- tripdatav3[!(tripdatav3$end_station_name=="McClurg Ct & Ohio St" & tripdatav3$end_station_id=="TA1306000029"),]
```
* these rows have been removed


### Calculating and creating a new column for the trip duration
Calculating the trip duration column:
```{r}
tripdatav3 <- tripdatav3 %>% 
  mutate(tripduration = ended_at - started_at)
```

Checking the column has been created, should now be 14 variables:
```{r}
colnames(tripdatav3)
```
A trip duration below 0 should not exist as that would mean the ended_at time was before the start_at, so we can check by using the following:
```{r}
tripdatav3 %>% 
  filter(tripduration <= 0) %>% 
  select(ride_id,tripduration)
```
* there are 2 rows here where the trip duration is a negative value or equal to 0
* these rows need to be dropped
```{r}
tripdatav4 <- tripdatav3 %>% 
  filter(tripduration > 0) %>% 
  arrange(desc(tripduration))
```

Rows have been removed and we can look at the data again:
```{r}
skim(tripdatav3)
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
write.csv(tripdatafinal, "202112_tripdata_cleaned.csv", row.names=FALSE)
```













