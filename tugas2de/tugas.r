#loading libraries
library(tidyr)
library(ggplot2)
library(dplyr)
library(naniar)



customer_data <- read.csv("../input/energy-industry/ml_case_training_data.csv", na.strings=c('', 'NA'))
price_data <- read.csv("../input/energy-industry/ml_case_training_hist_data.csv", na.strings=c('', 'NA'))
churn_data <- read.csv("../input/energy-industry/ml_case_training_output.csv", na.strings=c('', 'NA'))

#merging customer and churn data
customer_churn <- merge(customer_data, churn_data, by="id")




summary(customer_churn)



#checking for dublicated data
anyDuplicated(customer_churn)
#exploring class of the data
sapply(customer_churn, class)



#exploring churn rate
churn_rate <- customer_churn %>%
  group_by(churn) %>%
  summarize(Count=n()) %>%
  mutate(TotalCount=sum(Count)) %>%
  mutate(Percentage=round(Count/TotalCount*100))
churn_rate

options(repr.plot.width = 20, repr.plot.height = 10)
ggplot(churn_rate, aes(x=churn, y=Percentage, fill=churn)) +
  geom_bar(stat="identity") +
  labs(title="Churn Rate") + 
  geom_text(aes(label=Percentage), vjust=1.6, color="white", size=10) +
  theme(legend.title = element_text(size = 20), legend.text = element_text(size = 20), 
        plot.title = element_text(size = 30),axis.title.x = element_text(size = 25),
        axis.title.y = element_text(size = 25) )



ggplot(customer_churn, aes(x=cons_12m)) + geom_histogram(fill="orange") + 
labs(title="Electricity consumption of the past 12 months") +
theme(plot.title = element_text(size = 30),axis.title.x = element_text(size = 25),
        axis.title.y = element_text(size = 25))

ggplot(customer_churn, aes(x=cons_gas_12m)) + geom_histogram(fill="orange") + 
labs(title="Gas consumption of the past 12 months") +
theme(plot.title = element_text(size = 30),axis.title.x = element_text(size = 25),
        axis.title.y = element_text(size = 25))



anyDuplicated(price_data)
summary(price_data)



#price_data
price_data$price_date=as.POSIXct(price_data$price_date, 
                                 tryFormats = c("%Y-%m-%d %H:%M:%OS",
                                                "%Y/%m/%d %H:%M:%OS",
                                                "%Y-%m-%d %H:%M",
                                                "%Y/%m/%d %H:%M",
                                                "%Y-%m-%d",
                                                "%Y/%m/%d"),tz=Sys.timezone())
#customer_churn
customer_churn$date_activ=as.POSIXct(customer_churn$date_activ, 
                                     tryFormats = c("%Y-%m-%d %H:%M:%OS",
                                                    "%Y/%m/%d %H:%M:%OS",
                                                    "%Y-%m-%d %H:%M",
                                                    "%Y/%m/%d %H:%M",
                                                    "%Y-%m-%d",
                                                    "%Y/%m/%d"),tz=Sys.timezone())
customer_churn$date_end=as.POSIXct(customer_churn$date_end, 
                                   tryFormats = c("%Y-%m-%d %H:%M:%OS",
                                                  "%Y/%m/%d %H:%M:%OS",
                                                  "%Y-%m-%d %H:%M",
                                                  "%Y/%m/%d %H:%M",
                                                  "%Y-%m-%d",
                                                  "%Y/%m/%d"),tz=Sys.timezone())
customer_churn$date_modif_prod=as.POSIXct(customer_churn$date_modif_prod, 
                                          tryFormats = c("%Y-%m-%d %H:%M:%OS",
                                                         "%Y/%m/%d %H:%M:%OS",
                                                         "%Y-%m-%d %H:%M",
                                                         "%Y/%m/%d %H:%M",
                                                         "%Y-%m-%d",
                                                         "%Y/%m/%d"),tz=Sys.timezone())
customer_churn$date_renewal=as.POSIXct(customer_churn$date_renewal, 
                                       tryFormats = c("%Y-%m-%d %H:%M:%OS",
                                                      "%Y/%m/%d %H:%M:%OS",
                                                      "%Y-%m-%d %H:%M",
                                                      "%Y/%m/%d %H:%M",
                                                      "%Y-%m-%d",
                                                      "%Y/%m/%d"),tz=Sys.timezone())



summary(customer_churn)



#dropping columns
customer_churn <- select(customer_churn, -c(campaign_disc_ele,
                                            date_first_activ, forecast_base_bill_ele,
                                            forecast_base_bill_year, forecast_bill_12m,
                                            forecast_cons))



#let's look how many unique categories there are
unique(customer_churn$activity_new)

#let's look how many values of each category sales we have
activity <- customer_churn %>%
  group_by(activity_new) %>%
  summarize(Count=n())
activity

#assign a new value to NA
customer_churn$activity_new <- replace_na(customer_churn$activity_new, "new_category")



#let's look how many unique channels there are
unique(customer_churn$channel_sales)
#let's look how many values of each channel sales we have
num_channel <- customer_churn %>%
  group_by(channel_sales) %>%
  summarize(Count=n())
num_channel
#assigning NA values to the most frequent channel
customer_churn$channel_sales <- replace_na(customer_churn$channel_sales, "foosdfpfkusacimwkcsosbicdxkicaua")



#unique codes
unique(customer_churn$origin_up)
#number of values in each code
num_origin <- customer_churn %>%
  group_by(origin_up) %>%
  summarize(Count=n())
num_origin
#assigning NA values to the most frequent code
customer_churn$origin_up <- replace_na(customer_churn$origin_up, "lxidpiddsbxsbosboudacockeimpuepw")



customer_churn <- customer_churn %>%
  mutate(has_gas=ifelse(has_gas=="f", 0, 1))




customer_churn$forecast_discount_energy[is.na(customer_churn$forecast_discount_energy)]<-median(customer_churn$forecast_discount_energy,na.rm=TRUE)
customer_churn$forecast_price_energy_p1[is.na(customer_churn$forecast_price_energy_p1)]<-median(customer_churn$forecast_price_energy_p1,na.rm=TRUE)
customer_churn$forecast_price_energy_p2[is.na(customer_churn$forecast_price_energy_p2)]<-median(customer_churn$forecast_price_energy_p2,na.rm=TRUE)
customer_churn$forecast_price_pow_p1[is.na(customer_churn$forecast_price_pow_p1)]<-median(customer_churn$forecast_price_pow_p1,na.rm=TRUE)
customer_churn$margin_gross_pow_ele[is.na(customer_churn$margin_gross_pow_ele)]<-median(customer_churn$margin_gross_pow_ele,na.rm=TRUE)
customer_churn$margin_net_pow_ele[is.na(customer_churn$margin_net_pow_ele)]<-median(customer_churn$margin_net_pow_ele,na.rm=TRUE)
customer_churn$net_margin[is.na(customer_churn$net_margin)]<-median(customer_churn$net_margin,na.rm=TRUE)
customer_churn$pow_max[is.na(customer_churn$pow_max)]<-median(customer_churn$pow_max,na.rm=TRUE)



customer_churn$date_end[is.na(customer_churn$date_end)]<-median(customer_churn$date_end,na.rm=TRUE)
customer_churn$date_modif_prod[is.na(customer_churn$date_modif_prod)]<-median(customer_churn$date_modif_prod,na.rm=TRUE)
customer_churn$date_renewal[is.na(customer_churn$date_renewal)]<-median(customer_churn$date_renewal,na.rm=TRUE)



vis_miss(customer_churn)



#customer_churn
customer_churn$cons_12m[customer_churn$cons_12m <0] <- median(customer_churn$cons_12m)
customer_churn$cons_gas_12m[customer_churn$cons_gas_12m <0] <- median(customer_churn$cons_gas_12m)
customer_churn$cons_last_month[customer_churn$cons_last_month <0] <- median(customer_churn$cons_last_month)
customer_churn$forecast_cons_12m[customer_churn$forecast_cons_12m <0] <- median(customer_churn$forecast_cons_12m)
customer_churn$forecast_cons_year[customer_churn$forecast_cons_year <0] <- median(customer_churn$forecast_cons_year)
customer_churn$forecast_meter_rent_12m[customer_churn$forecast_meter_rent_12m <0] <- median(customer_churn$forecast_meter_rent_12m)
customer_churn$forecast_price_pow_p1[customer_churn$forecast_price_pow_p1 <0] <- median(customer_churn$forecast_price_pow_p1)
customer_churn$imp_cons[customer_churn$imp_cons <0] <- median(customer_churn$imp_cons)
customer_churn$margin_gross_pow_ele[customer_churn$margin_gross_pow_ele <0] <- median(customer_churn$margin_gross_pow_ele)
customer_churn$margin_net_pow_ele[customer_churn$margin_net_pow_ele <0] <- median(customer_churn$margin_net_pow_ele)
customer_churn$net_margin[customer_churn$net_margin <0] <- median(customer_churn$net_margin)

#price_data
price_data$price_p1_fix[price_data$price_p1_fix <0] <- median(price_data$price_p1_fix)
price_data$price_p2_fix[price_data$price_p2_fix <0] <- median(price_data$price_p2_fix)
price_data$price_p3_fix[price_data$price_p3_fix <0] <- median(price_data$price_p3_fix)



#cons_12m
ggplot(customer_churn, aes(y = "", x = cons_12m)) +
  geom_boxplot()
#forecast_cons_12m
ggplot(customer_churn, aes(y = "", x = forecast_cons_12m)) +
  geom_boxplot()



#loading R library
library(outliers)
#computing z-scores
z.cons_12m <- customer_churn$cons_12m %>% scores(type = "z")
head(z.cons_12m)
#let's look how many outliers with z>3 we got:
length(which(abs(z.cons_12m) >3)) #408
#I'm going to impute these values with the median
customer_churn$cons_12m[which(abs(z.cons_12m) >3 )] <- median(customer_churn$cons_12m, na.rm = TRUE)
#check the box plot again
ggplot(customer_churn, aes(y = "", x = cons_12m)) +
  geom_boxplot()



#let's combine numeric variables in a separate set
continuous <-select_if(customer_churn, is.numeric)
#loading R library
library(corrplot)
#visualizing correlation plot
Num = cor(continuous)
corrplot(Num, method = 'color', order = 'alphabet')



final_data <- select(continuous, -c(forecast_cons_year, margin_net_pow_ele))



final_data$cons_12m <- log10(final_data$cons_12m +1)
final_data$cons_gas_12m <- log10(final_data$cons_gas_12m +1)
final_data$cons_last_month <- log10(final_data$cons_last_month +1)
final_data$forecast_cons_12m <- log10(final_data$forecast_cons_12m +1)
final_data$forecast_discount_energy <- log10(final_data$forecast_discount_energy +1)
final_data$forecast_meter_rent_12m <- log10(final_data$forecast_meter_rent_12m +1)
final_data$forecast_price_energy_p1 <- log10(final_data$forecast_price_energy_p1 +1)
final_data$forecast_price_energy_p2 <- log10(final_data$forecast_price_energy_p2 +1)
final_data$forecast_price_pow_p1 <- log10(final_data$forecast_price_pow_p1 +1)
final_data$has_gas <- log10(final_data$has_gas +1)
final_data$imp_cons <- log10(final_data$imp_cons +1)
final_data$margin_gross_pow_ele <- log10(final_data$margin_gross_pow_ele +1)
final_data$nb_prod_act <- log10(final_data$nb_prod_act +1)
final_data$net_margin <- log10(final_data$net_margin +1)
final_data$num_years_antig <- log10(final_data$num_years_antig +1)
final_data$pow_max <- log10(final_data$pow_max +1)



#before transformation
ggplot(customer_churn, aes(x=cons_12m)) +geom_histogram()
#after transformation
ggplot(final_data, aes(x=cons_12m)) +geom_histogram()


