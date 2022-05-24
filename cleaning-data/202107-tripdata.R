---
  title: "Cleaning July 2021"
author: "Luke Hembling"
date: '2022-05-15'
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
tripdata <- read_csv("/cloud/project/202107-divvy-tripdata.csv")
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

* total rows in dataset is 822410

#### ride_id

* no missing data
* every row is unique (no duplicates) with 822410 id's

#### rideable_type

```{r}
unique(tripdata$rideable_type)
```

* no missing data
* 3 unique values which is correct (classic bike, docked bike and electric bike)

#### started_at

* no missing data
* datetime value
* all dates are after 2021-07-01

#### ended_at

* no missing data
* datetime value
* there are dates up to 2021-08-12

#### start_station_name

* there are 87263 missing values
* 717 unique stations

#### start_station_id

* there are 87263 missing values
* 710 unique id's
* there's seven more station name than id which should not be the case
* id's are inconsistent in naming and length

#### end_station_name

* there are 93158 missing values
* 714 unique stations

#### end_station_id

* there are 93158 missing values
* 707 unique id's
* there's seven more station name than id which should not be the case
* id's are inconsistent in naming and length

#### start_lat

* no missing values

#### start_lng

* no missing values

#### end_lat

* there are 731 missing values

#### end_lng

* there are 731 missing values

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
* 130,089 records with missing data
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
* checking the data using skim again, there is still 7 more unique id's than station names:
  ```{r}
skim(tripdatav2)
```


#### Finding the extra id's
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
* id's 13099, 13300, LF-005, TA1306000029, TA1307000041, TA1309000039, TA1309000049 have appeared twice.
* The correct station names for each station according to the other data set compared to the incorrect value:
  1. 13099 = Halsted St & 18th St // Halsted St & 18th St (Temp)

2. 13300 = DuSable Lake Shore Dr & Monroe St // Lake Shore Dr & Monroe St

3. LF-005 = DuSable Lake Shore Dr & North Blvd // Lake Shore Dr & North Blvd

4. TA1306000029 =  McClurg Ct & Ohio St // Lake Shore Dr & Ohio St

5. TA1307000041 = DuSable Lake Shore Dr & Wellington Ave // Lake Shore Dr & Wellington Ave	

6. TA1309000039 = DuSable Lake Shore Dr & Diversey Pkwy // Lake Shore Dr & Diversey Pkwy	

7. TA1309000049 = DuSable Lake Shore Dr & Belmont Ave // Lake Shore Dr & Belmont Ave	

* Most of them are very similar just missing the word "DuSable"
* While "TA1306000029" is completely different.

1.
```{r}
tripdatav3 <-tripdatav2[!(tripdatav2$start_station_name=="Halsted St & 18th St (Temp)" & tripdatav2$start_station_id=="13099"),]
```
2.
```{r}
tripdatav3 <-tripdatav3[!(tripdatav3$start_station_name=="Lake Shore Dr & Monroe St" & tripdatav3$start_station_id=="13300"),]
```
3. 
```{r}
tripdatav3 <-tripdatav3[!(tripdatav3$start_station_name=="Lake Shore Dr & North Blvd" & tripdatav3$start_station_id=="LF-005"),]
```
4. 
```{r}
tripdatav3 <-tripdatav3[!(tripdatav3$start_station_name=="Lake Shore Dr & Ohio St" & tripdatav3$start_station_id=="TA1306000029"),]
```
5.
```{r}
tripdatav3 <-tripdatav3[!(tripdatav3$start_station_name=="Lake Shore Dr & Wellington Ave" & tripdatav3$start_station_id=="TA1307000041"),]
```
6. 
```{r}
tripdatav3 <-tripdatav3[!(tripdatav3$start_station_name=="Lake Shore Dr & Diversey Pkwy" & tripdatav3$start_station_id=="TA1309000039"),]
```
7.
```{r}
tripdatav3 <-tripdatav3[!(tripdatav3$start_station_name=="Lake Shore Dr & Belmont Ave" & tripdatav3$start_station_id=="TA1309000049"),]
```
* Extra rows are removed
* Now the same with the end station data
```{r}
uniquestations2 <- tripdatav3[!duplicated(tripdatav3$end_station_name), ]
```

```{r}
uniquestations2 %>% 
  count(end_station_id) %>% 
  filter(n > 1)
```

1. 13099  Halsted St & 18th St // Halsted St & 18th St (Temp)
2. 13300 DuSable Lake Shore Dr & Monroe St // Lake Shore Dr & Monroe St
3. LF-005 DuSable Lake Shore Dr & North Blvd // Lake Shore Dr & North Blvd
4. TA1306000029 McClurg Ct & Ohio St // Lake Shore Dr & Ohio St AND DuSable Lake Shore Dr & Ohio St
5. TA1307000041 DuSable Lake Shore Dr & Wellington Ave // Lake Shore Dr & Wellington Ave
6. TA1309000039 DuSable Lake Shore Dr & Diversey Pkwy // Lake Shore Dr & Diversey Pkwy
7. TA1309000049 DuSable Lake Shore Dr & Belmont Ave // Lake Shore Dr & Belmont Ave

```{r}
uniquestations2 %>% 
  select(ride_id,end_station_id,end_station_name) %>% 
  filter(end_station_id == "TA1306000029")
```

1.
```{r}
tripdatav4 <-tripdatav3[!(tripdatav3$end_station_name=="Halsted St & 18th St (Temp)" & tripdatav3$end_station_id=="13099"),]
```
2.
```{r}
tripdatav4 <-tripdatav4[!(tripdatav4$end_station_name=="Lake Shore Dr & Monroe St" & tripdatav4$end_station_id=="13300"),]
```
3. 
```{r}
tripdatav4 <-tripdatav4[!(tripdatav4$end_station_name=="Lake Shore Dr & North Blvd" & tripdatav4$end_station_id=="LF-005"),]
```
4. 
```{r}
tripdatav4 <-tripdatav4[!(tripdatav4$end_station_id=="TA1306000029"),]
```
5. 
```{r}
tripdatav4 <-tripdatav4[!(tripdatav4$end_station_name=="Lake Shore Dr & Wellington Ave" & tripdatav4$end_station_id=="TA1307000041"),]
```
6.
```{r}
tripdatav4 <-tripdatav4[!(tripdatav4$end_station_name=="Lake Shore Dr & Diversey Pkwy" & tripdatav4$end_station_id=="TA1309000039"),]
```
7.
```{r}
tripdatav4 <-tripdatav4[!(tripdatav4$end_station_name=="Lake Shore Dr & Belmont Ave" & tripdatav4$end_station_id=="TA1309000049"),]
```
*Have a look at the data again
```{r}
skim(tripdatav4)
```


### Calculating and creating a new column for the trip duration
Calculating the trip duration column:
  ```{r}
tripdatav4 <- tripdatav4 %>% 
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
* there are 28 rows here where the trip duration is a negative value or equal to 0
* these rows need to be dropped
```{r}
tripdatav5 <- tripdatav4 %>% 
  filter(tripduration > 0) %>% 
  arrange(desc(tripduration))
```

Rows have been removed and we can look at the data again:
  ```{r}
skim(tripdatav5)
```

* all missing values are removed and every id is unique.

#### Round values
Rounding the values in latitude and longitude to make sure they are consistent.
```{r}
tripdatafinal <- tripdatav5 %>% 
  mutate_if(is.numeric, round, digits = 3)
```
Which is visible here:
  ```{r}
glimpse(tripdatafinal)
```
#### Export the data
```{r}
write.csv(tripdatafinal, "202107_tripdata_cleaned.csv", row.names=FALSE)
```

