---
  title: "Analyzing data"
author: "Luke Hembling"
date: "5/17/2022"
output: html_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

### Install packages
```{r}
install.packages("tidyverse")
```

#### Loading packages
```{r}
library(tidyverse)
library(readr)
library(dplyr)
library(lubridate)
```

#### Loading data
```{r}
finaltripdatav3 <- read_csv("Desktop/finaltripdatav3.csv")
```

### Summary of tripdata
```{r}
tripdata_summary <- 
  finaltripdatav3 %>% 
  group_by(customer_type) %>% 
  summarise(average_tripduration=mean(tripduration),
            min_tripduration=min(tripduration),
            max_tripduration=max(tripduration))
```
* Casual members have longer trip duration on average
* They also have the longest trip duration

### Total customer types
```{r}
finaltripdatav3 %>% 
  group_by(customer_type) %>% 
  summarise(total = n())
```
* More rides for members compared to casual riders.

### Duplicate dataset
```{r}
tripdata <- finaltripdatav3
```

### Extract day of the week
```{r}
tripdata$weekday <- weekdays(tripdata$started_at)
```

### Extract month
```{r}
tripdata$month <- months(tripdata$started_at)
```

### Extract hour
```{r}
tripdata$hour <- hour(tripdata$started_at)
```



### Compare casual vs member total sum of trips per day
```{r}
tripdata %>% 
  group_by(weekday, customer_type) %>% 
  summarise(total = n()) %>% 
  arrange(total)
```
* Members total more trips in general, however being more popular during the week
* Casual riders total more trips on the the weekends with Saturday being the most popular day

### Seeing member or casual only
```{r}
tripdata %>% 
  filter(customer_type == "member") %>% 
  group_by(weekday) %>% 
  summarise(total = n()) %>% 
  arrange(total)
```

### Compare most popular months for Casual riders
```{r}
tripdata %>% 
  filter(customer_type == "casual") %>% 
  group_by(month) %>% 
  summarise(total = n()) %>% 
  arrange(total)
```
* Casual riders are ore popular over summer months
* Least popular over winter months

### Compare most popular months for Members
```{r}
tripdata %>% 
  filter(customer_type == "member") %>% 
  group_by(month) %>% 
  summarise(total = n()) %>% 
  arrange(total)
```
* Least popular over winter season also
* Most popular over summer to autumn 

### Most popular station
```{r}
tripdata %>% 
  group_by(start_station_name) %>% 
  summarise(total = n()) %>%
  arrange(desc(total))
```
* Streeter Dr & Grand Ave	is the most popular starting station 

### Most popular stations for casual riders
```{r}
tripdata %>% 
  filter(customer_type == "casual") %>% 
  group_by(start_station_name) %>% 
  summarise(total = n()) %>%
  arrange(desc(total))
```
* Streeter Dr & Grand Ave	is the most popular starting station for casual riders

### Most popular stations for member riders
```{r}
tripdata %>% 
  filter(customer_type == "member") %>% 
  group_by(start_station_name) %>% 
  summarise(total = n()) %>%
  arrange(desc(total))
```
* Kingsbury St & Kinzie St is the most popular station with less totals compared to casual riders.

### Trips by hour of the day for casual riders
```{r}
tripdata %>% 
  filter(customer_type == "casual") %>% 
  group_by(hour) %>% 
  summarise(total = n()) %>% 
  arrange(desc(total))
```
* Most popular times for casual riders is during the afternoon to evening.

### Trips by hour of the day for member riders
```{r}
tripdata %>% 
  filter(customer_type == "member") %>% 
  group_by(hour) %>% 
  summarise(total = n()) %>% 
  arrange(desc(total))
```
* More rides in the evening as well as rides at 7 am and 8 am.


### Most popular rideable types
```{r}
tripdata %>% 
  group_by(rideable_type, customer_type) %>% 
  summarise(total = n()) %>% 
  arrange(desc(total))
```


### Export the data
```{r}
write.csv(tripdata, "analyzetripdata.csv", row.names=FALSE)
```

```{r}
write.csv(hourdata, "hourdata.csv", row.names=FALSE)
```

```{r}
hourdata <- tripdata %>% 
  group_by(hour, customer_type) %>% 
  summarise(total = n()) %>% 
  arrange(desc(total))
```

```{r}
tripdata %>% 
  select(started_at, customer_type)
summarise(total = n()) %>% 
  ```
