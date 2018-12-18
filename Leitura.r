rm(list = ls())

#library(dplyr)
#library(tidyr)
library(astsa)
library(pracma)
library(forecast)
library(zoo)
library(tsoutliers) #tso(serie)

#--------------------------------------------------------------------
# Leitura 
#--------------------------------------------------------------------

bd<-"D:\\Aulas2017\\ST\\Proposta Seminários\\DADOS"
setwd(bd)

files<-list.files(pattern = ".txt")
ls<-lapply(X = files,FUN = read.table,header=T)

#--------------------------------------------------------------------
#Series Mensais
#--------------------------------------------------------------------

ls.month=list()

pdf("D:\\Aulas2017\\ST\\Proposta Seminários\\series.mensais.pdf")
par(mfrow=c(3,1))
for(i in 1:length(ls)){
  ls.month[[i]] <- NaN*seq(length(ls))
  ## aggregate a daily time series to a monthly series
  # create zoo series
  tt <- as.Date("2008-1-1") + 0:length(ts(ls[[i]]$X____up.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008))

  z.day.e <- zoo(ts(ls[[i]]$X__east.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008), tt)
  z.day.n <- zoo(ts(ls[[i]]$X_north.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008), tt)
  z.day.u <- zoo(ts(ls[[i]]$X____up.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008), tt)
  
  # average z over months
  ls.month[[i]] <- data.frame(aggregate(z.day.e, as.yearmon, mean),
                              aggregate(z.day.n, as.yearmon, mean),
                              aggregate(z.day.u, as.yearmon, mean))

  plot(ts(ls.month[[i]][1],freq=12,start=2008),ylab="E",main=files[i])
  plot(ts(ls.month[[i]][2],freq=12,start=2008),ylab="N",main=files[i])
  plot(ts(ls.month[[i]][3],freq=12,start=2008),ylab="U",main=files[i])
}
dev.off()

#--------------------------------------------------------------------
#limpando outliers
#--------------------------------------------------------------------

# tsclean - forecast package - identifying and replacying outliers.
# (It also handles the missing values.)  
# fit <- nnetar(tsclean(x)) - rede reural
# tsclean() fits a robust trend using loess (for non-seasonal series),
# or robust trend and seasonal components using STL (for seasonal series).
# The residuals are computed and the following bounds are computed:
# L=q0.9+2(q0.9−q0.1)=q0.1−2(q0.9−q0.1)
# U =q0.9+2(q0.9−q0.1)L=q0.1−2(q0.9−q0.1)
# where q0.1 and q0.9 are the 10th and 90th percentiles of the residuals respectively.
# 
# Outliers are identified as points with residuals larger than UU or smaller than LL.
# 
# For non-seasonal time series, outliers are replaced by linear interpolation. 
# For seasonal time series, the seasonal component from the STL fit is removed and 
# the seasonally adjusted series is linearly interpolated to replace the outliers,
# before re-seasonalizing the result.

# LOWESS, and least squares fitting in general, are non-parametric
# strategies for fitting a smooth curve to data points.


ls.month.no.outliers=list()

pdf("D:\\Aulas2017\\ST\\Proposta Seminários\\series.mensais.sem.outliers.pdf")
par(mfrow=c(3,1))
for(i in 1:length(ls)){
  ls.month.no.outliers[[i]] <- NaN*seq(length(ls))
  ## aggregate a daily time series to a monthly series
  # create zoo series
  tt <- as.Date("2008-1-1") + 0:length(ts(ls[[i]]$X____up.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008))
  
  z.day.e <- zoo(tsclean(ts(ls[[i]]$X__east.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008)), tt)
  z.day.n <- zoo(tsclean(ts(ls[[i]]$X_north.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008)), tt)
  z.day.u <- zoo(tsclean(ts(ls[[i]]$X____up.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008)), tt)
  
  # average z over months
  ls.month.no.outliers[[i]] <- data.frame(tsclean(aggregate(z.day.e, as.yearmon, mean)),
                                          tsclean(aggregate(z.day.n, as.yearmon, mean)),
                                          tsclean(aggregate(tsclean(z.day.u), as.yearmon, mean)))

  plot(ts(ls[[i]]$X__east.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008),ylab="E",main=files[i])
  lines(tsclean(ts(ls[[i]]$X__east.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008)),col=4)
  lines(ts(ls.month[[i]][1],freq=12,start=2008),col=2)
  lines(ts(ls.month.no.outliers[[i]][1],freq=12,start=2008),col=3)
  
  plot(ts(ls[[i]]$X_north.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008),ylab="N",main=files[i])
  lines(tsclean(ts(ls[[i]]$X_north.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008)),col=4)
  lines(ts(ls.month[[i]][2],freq=12,start=2008),col=2)
  lines(ts(ls.month.no.outliers[[i]][2],freq=12,start=2008),col=3)
  
  plot(ts(ls[[i]]$X____up.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008),ylab="U",main=files[i])
  lines(tsclean(ts(ls[[i]]$X____up.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008)),col=4)
  lines(ts(ls.month[[i]][3],freq=12,start=2008),col=2)
  lines(ts(ls.month.no.outliers[[i]][3],freq=12,start=2008),col=3)
}
dev.off()


pdf("D:\\Aulas2017\\ST\\Proposta Seminários\\acf_U.mensal.pdf")
par(mfrow=c(1,1))
for(i in 1:length(ls)){
  acf2(ts(ls.month[[i]][1],freq=12,start=2008),main=files[i])
  acf2(diff(ts(ls.month[[i]][1],freq=12,start=2008)),main=files[i])
}
dev.off()

pdf("D:\\Aulas2017\\ST\\Proposta Seminários\\acf_E.mensal.pdf")
par(mfrow=c(1,1))
for(i in 1:length(ls)){
  acf2(ts(ls.month[[i]][2],freq=12,start=2008),main=files[i])
  acf2(diff(ts(ls.month[[i]][2],freq=12,start=2008)),main=files[i])
}
dev.off()

pdf("D:\\Aulas2017\\ST\\Proposta Seminários\\acf_N.mensal.pdf")
par(mfrow=c(1,1))
for(i in 1:length(ls)){
  acf2(ts(ls.month[[i]][3],freq=12,start=2008),main=files[i])
  acf2(diff(ts(ls.month[[i]][3],freq=12,start=2008)),main=files[i])
}
dev.off()

#--------------------------------------------------------------------
# Series diárias
#--------------------------------------------------------------------


pdf("D:\\Aulas2017\\ST\\Proposta Seminários\\series1.pdf")
par(mfrow=c(3,1))
for(i in 1:length(ls)){
  plot(ts(ls[[i]]$X__east.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008),ylab="E",main=files[i])
  plot(ts(ls[[i]]$X_north.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008),ylab="N",main=files[i])
  plot(ts(ls[[i]]$X____up.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008),ylab="U",main=files[i])
}
dev.off()


pdf("D:\\Aulas2017\\ST\\Proposta Seminários\\acf_U.pdf")
par(mfrow=c(1,1))
for(i in 1:length(ls)){
  acf2(ts(ls[[i]]$X____up.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008),main=files[i],max.lag = 730)
  acf2(diff(ts(ls[[i]]$X____up.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008)),main=files[i],max.lag = 730)
}
dev.off()

pdf("D:\\Aulas2017\\ST\\Proposta Seminários\\acf_E.pdf")
par(mfrow=c(1,1))
for(i in 1:length(ls)){
  acf2(ts(ls[[i]]$X__east.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008),main=files[i])
  acf2(diff(ts(ls[[i]]$X__east.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008)),main=files[i])
}
dev.off()

pdf("D:\\Aulas2017\\ST\\Proposta Seminários\\acf_N.pdf")
par(mfrow=c(1,1))
for(i in 1:length(ls)){
  acf2(ts(ls[[i]]$X_north.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008),main=files[i])
  acf2(diff(ts(ls[[i]]$X_north.m.[ls[[i]]$yyyy.yyyy>2008],freq=365,start=2008)),main=files[i])
}
dev.off()



