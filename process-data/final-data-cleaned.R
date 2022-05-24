#### Install packages
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
```

```{r}
skim(tripdata)
```

* Final checks for data before performing analysis
* Upon checking, there are a few inconsistencies to deal with after merging the data

### START STATIONS
```{r}
uniquestations <- tripdata[!duplicated(tripdata$start_station_id), ]
```

```{r}
uniquestations %>% 
  count(start_station_name) %>% 
  filter(n > 1)
```

* Performing this check with each of the duplicate id/station to find the wrong value.
```{r}
uniquestations %>% 
  select(start_station_id, start_station_name) %>% 
  filter(start_station_name == "Loomis St & 89th St")
```

```{r}
tripdata %>% 
  filter(start_station_id == "KA1504000152")
```

```{r}
class(finaltripdata$start_station_id)
```

```{r}
tripdata <- finaltripdata
```

### Changing value 1 for name consistency
```{r}
tripdata$start_station_name[tripdata$start_station_name=="Halsted St & 18th St (Temp)"] <- "Halsted St & 18th St"
```

### Changing value 2
```{r}
tripdata$start_station_name[tripdata$start_station_name=="Lake Shore Dr & Monroe St"] <- "DuSable Lake Shore Dr & Monroe St"
```

### Changing value 3
```{r}
tripdata$start_station_name[tripdata$start_station_name=="N Shore Channel Trail & Argyle Ave"] <- "N Shore Channel Trail & Argyle St"
```

### Changing value 4
```{r}
tripdata$start_station_name[tripdata$start_station_name=="Lake Shore Dr & North Blvd"] <- "DuSable Lake Shore Dr & North Blvd"
```

### Changing value 7
```{r}
tripdata$start_station_name[tripdata$start_station_name=="Lake Shore Dr & Wellington Ave"] <- "DuSable Lake Shore Dr & Wellington Ave"
```

### Changing value 8
```{r}
tripdata$start_station_name[tripdata$start_station_name=="Lake Shore Dr & Diversey Pkwy"] <- "DuSable Lake Shore Dr & Diversey Pkwy"
```

### Changing value 9
```{r}
tripdata$start_station_name[tripdata$start_station_name=="Lake Shore Dr & Belmont Ave"] <- "DuSable Lake Shore Dr & Belmont Ave"
```

### Changing value 5
```{r}
tripdata <- tripdata[!(tripdata$start_station_name=="Marshfield Ave & Cortland St" & tripdata$start_station_id=="TA1305000039"),]
```

### Changing value 6 & Removing wrong value
```{r}
tripdata$start_station_name[tripdata$start_station_name=="Lake Shore Dr & Ohio St"] <- "DuSable Lake Shore Dr & Ohio St"
```

```{r}
tripdata <- tripdata[!(tripdata$start_station_name=="McClurg Ct & Ohio St" & tripdata$start_station_id=="TA1306000029"),]
```

### Changing id's
### Station id 1
```{r}
tripdata$start_station_id[tripdata$start_station_id=="15576"] <- "KA1504000152"
```

### Station id 2
```{r}
tripdata$start_station_id[tripdata$start_station_id=="20102"] <- "201022"
```

### END STATIONS
```{r}
uniquestations <- tripdata[!duplicated(tripdata$end_station_name), ]
```

```{r}
uniquestations %>% 
  count(end_station_id) %>% 
  filter(n > 1)
```

* Performing this check with each of the duplicate id/station to find the wrong value.
```{r}
uniquestations %>% 
  select(end_station_id, end_station_name) %>% 
  filter(end_station_id == "TA1309000049")
```

```{r}
tripdata %>% 
  filter(start_station_id == "KA1504000152")
```

```{r}
tripdata %>% 
  filter(end_station_name == "Halsted St & 18th St (Temp)")
```

### Changing value 1 for name consistency
```{r}
tripdata$end_station_name[tripdata$end_station_name=="Halsted St & 18th St (Temp)"] <- "Halsted St & 18th St"
```

### Changing value 2
```{r}
tripdata$end_station_name[tripdata$end_station_name=="Lake Shore Dr & Monroe St"] <- "DuSable Lake Shore Dr & Monroe St"
```

### Changing value 3
```{r}
tripdata$end_station_name[tripdata$end_station_name=="N Shore Channel Trail & Argyle Ave"] <- "N Shore Channel Trail & Argyle St"
```

### Changing value 4
```{r}
tripdata$end_station_name[tripdata$end_station_name=="Lake Shore Dr & North Blvd"] <- "DuSable Lake Shore Dr & North Blvd"
```

### Changing value 7
```{r}
tripdata$end_station_name[tripdata$end_station_name=="Lake Shore Dr & Wellington Ave"] <- "DuSable Lake Shore Dr & Wellington Ave"
```

### Changing value 8
```{r}
tripdata$end_station_name[tripdata$end_station_name=="Lake Shore Dr & Diversey Pkwy"] <- "DuSable Lake Shore Dr & Diversey Pkwy"
```

### Changing value 9
```{r}
tripdata$end_station_name[tripdata$end_station_name=="Lake Shore Dr & Belmont Ave"] <- "DuSable Lake Shore Dr & Belmont Ave"
```

### Changing value 5
```{r}
tripdata <- tripdata[!(tripdata$end_station_name=="Marshfield Ave & Cortland St" & tripdata$end_station_id=="TA1305000039"),]
```

### Changing value 6 & Removing wrong value
```{r}
tripdata$end_station_name[tripdata$end_station_name=="Lake Shore Dr & Ohio St"] <- "DuSable Lake Shore Dr & Ohio St"
```

```{r}
tripdata2 <- tripdata[!(tripdata$end_station_name=="McClurg Ct & Ohio St" & tripdata$end_station_id=="TA1306000029"),]
```

```{r}
skim(tripdata2)
```
### Changing id's
### Station id 1
```{r}
tripdata2$end_station_id[tripdata2$end_station_id=="15576"] <- "KA1504000152"
```

### Station id 2
```{r}
tripdata2$end_station_id[tripdata2$end_station_id=="20102"] <- "201022"
```

```{r}
write.csv(tripdata2, "tripdatacleaned.csv", row.names=FALSE)
```


