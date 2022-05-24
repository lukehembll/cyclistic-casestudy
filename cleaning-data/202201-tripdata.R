---
  title: "Cleaning January 2022"
author: "Luke Hembling"
date: '2022-05-14'
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
tripdata <- read_csv("/cloud/project/202201-divvy-tripdata.csv")
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

* total rows in dataset is 103770

#### ride_id

* no missing data
* every row is unique (no duplicates) with 103770 id's

#### rideable_type

```{r}
unique(tripdata$rideable_type)
```

* no missing data
* 3 unique values which is correct (classic bike, docked bike and electric bike)

#### started_at

* no missing data
* datetime value
* all dates are after 2022-01-01

#### ended_at

* no missing data
* datetime value
* there are dates up to 2022-02-01 

#### start_station_name

* there are 16260 missing values
* 758 unique stations

#### start_station_id

* there are 16260 missing values
* 758 unique id's
* id's are inconsistent in naming and length

#### end_station_name

* there are 17927 missing values
* 724 unique stations

#### end_station_id

* there are 17927 missing values
* 724 unique id's
* id's are inconsistent in naming and length

#### start_lat

* no missing values

#### start_lng

* no missing values

#### end_lat

* there are 86 missing values

#### end_lng

* there are 86 missing values

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
* 23,642 records with missing data
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

### Calculating and creating a new column for the trip duration
Calculating the trip duration column:
```{r}
tripdatav3 <- tripdatav2 %>% 
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
* there are none

```{r}
skim(tripdatav3)
```

* all missing values are removed and every id is unique.

#### Round values
Rounding the values in latitude and longitude to make sure they are consistent.
```{r}
tripdatafinal <- tripdatav3 %>% 
    mutate_if(is.numeric, round, digits = 3)
```
Which is visible here:
```{r}
glimpse(tripdatafinal)
```
#### Export the data
```{r}
write.csv(tripdatafinal, "202201_tripdata_cleaned.csv", row.names=FALSE)
```










