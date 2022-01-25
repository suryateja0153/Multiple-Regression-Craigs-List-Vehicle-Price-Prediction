#Author: Suryateja Chalapati

#Importing required libraries
rm(list=ls())
library(rio)
library(moments)
library(dplyr)

#Setting the working directory and importing the dataset
setwd("C:/Users/surya/Downloads")

df = import("Price Data.xlsx", sheet = "Sheet 1")
colnames(df)=tolower(make.names(colnames(df)))
df <- df %>% filter(make == "cadillac", year %in% 2006:2011, cylinders %in% 6:8) 
attach(df)

#Setting seed and data sampling
set.seed(36991670)
data_sample = data.frame(df[sample(1:nrow(df), 250, replace = FALSE),])
attach(data_sample)

#Checking for factor variable
data_sample$cylinders = as.factor(data_sample$cylinders)
is.factor(data_sample$cylinders)


data_sample$year <- as.numeric(data_sample$year)

#Analysis_[1,2]
#Multiple Regression
lin_reg=lm(price~odometer+year+cylinders, data=data_sample)
summary(data_sample$price)
summary(lin_reg)
confint(lin_reg)

#Analysis_3
par(mfrow=c(2,2))
plot(data_sample$price,data_sample$odometer,
     pch=19,main="Multiple Regression",xlab="Odometer",ylab="Price")
plot(data_sample$price,data_sample$year,
     pch=19,main="Multiple Regression",xlab="Year",ylab="Price")
plot(data_sample$price,data_sample$cylinders,
     pch=19,main="Multiple Regression",xlab="Cylinder",ylab="Price")
par(mfrow=c(1,1))

layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page
plot(lin_reg)
par(mfrow=c(1,1))

#Analysis_4
#Linearity
plot(data_sample$odometer,data_sample$price,
     pch=19)

plot(data_sample$year,data_sample$price,
     pch=19)

plot(data_sample$cylinders,data_sample$price,
     pch=19)

plot(data_sample$price,lin_reg$fitted.values,pch=19,main="Price Actual v. Fitted Values")
abline(0,1,col="red",lwd=3)

#Independence
plot(lin_reg$fitted.values,rstandard(lin_reg),pch=19,main="The residuals and deviation")

#Normality
qqnorm(lin_reg$residuals,pch=19,main="Price Normality Plot")
qqline(lin_reg$residuals,col="red",lwd=3)

#Equality of Variances
plot(lin_reg$fitted.values,lin_reg$residuals,pch=19,main="Price Linear Residuals")
abline(0,0,col="red",lwd=3)

#Identifying high leverage points.
lev=hat(model.matrix(lin_reg))
plot(lev,pch=19)
abline(3*mean(lev),0,col="red",lwd=3)
plot(lin_reg)

#Analysis_5
df_predict <- data.frame('odometer'=175757,'year'=2011 ,'cylinders'=8)
df_predict$cylinders <- as.factor(df_predict$cylinders)
predict(lin_reg, df_predict)
