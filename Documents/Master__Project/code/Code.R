rm(list=ls()) # clean the global environment
graphics.off()
df <- read.table("../data/GO_flux_2.tab", sep="\t", header=TRUE) # import data from the file
print(sprintf("Loaded %d columns.", ncol(df)))
library(ggplot2) # load necessary packages
library(dplyr)
print(colnames(df))
dim(df) # have a look at the data structure
str(df)
head(df)
df <- df[!is.na(df$POC.flux..mg.m..2.day.),]

## try to investigate a small subset ##
df %>%
  count(ID..Unique.location.identifier., sort = TRUE)
df115 <- subset(df, ID..Unique.location.identifier. == 115)
df115 %>%
  count(ID..Reference.identifier., sort = TRUE)
df115_15 <- subset(df115, ID..Reference.identifier. == 15)
df115_15 %>%
  count(Date.Time..Deployed., sort = TRUE)
df115_15_041111 <- subset(df115_15, Date.Time..Deployed. == "2004-11-11T00:00:00")
df115_15_041111 %>%
  count(Date.time.end..Retrieved.)

## obtain the RLS of this small subset ##
z <- df115_15_041111$Depth.water..m...Sediment.trap.deployment.depth.
Fz <- df115_15_041111$POC.flux..mg.m..2.day.
plot(z ~ log(Fz))
lm_model <- lm(z ~ log(Fz))
summary(lm_model)
slope <- as.numeric(coefficients(lm_model)[2])
z_star <- -slope
abline(h = z_star, lty = 2, lwd = 2, col = "red")
z0 <- min(z)
Fz0 <- Fz[which.min(z0)]
log_Fz0 <- log(Fz0)
abline(lm_model)
require(ggplot2)
ggplot(lm_model$model, aes_string(x = names(lm_model$model)[2], y = names(lm_model$model)[1])) + 
  geom_point() +
  stat_smooth(method = "lm", col = "red") +
  labs(title = paste("Adj R2 = ",signif(summary(lm_model)$adj.r.squared, 5),
                     "Intercept =",signif(lm_model$coef[[1]],5 ),
                     " Slope =",signif(lm_model$coef[[2]], 5),
                     " P =",signif(summary(lm_model)$coef[2,4], 5))) +
  theme_bw()

# Function for POC attenuation
my_fun <- function(z) {
  result <- Fz0*exp(-(z-z0)/z_star)
  return(result)
}

## plot the POC attenuation profile ##
plt <- ggplot(data=df115_15_041111, aes(x=Depth.water..m...Sediment.trap.deployment.depth., y = POC.flux..mg.m..2.day.))+
  stat_function(fun=my_fun, color = "red")+
  geom_point(color = "blue", size = 3)+
  theme_bw()+
  coord_flip()+
  scale_x_reverse()+
  xlab("Depth (m)")+
  ylab("POC flux (mg C m-2 d-1)")+
  ggtitle("Decline in POC with depth")

plt

## obtain the observed RLS ##
RLS <- c()
min_depth <- c()
min_POC <- c()
df00 <- df %>% count(ID..Unique.location.identifier., ID..Reference.identifier., Date.Time..Deployed., Date.time.end..Retrieved., Latitude, Longitude, Elevation..m.a.s.l....Total.water.depth., Bathy.depth..m...ETOPO1.bathymetry., Duration..days., Reference, Type..Data.type., Type..Sediment.trap.type., Area..m..2...Surface.area.of.trap.)
nrow(df00)  
for (i in 1:nrow(df00)){
  df_temp <- subset(df, ID..Unique.location.identifier. == df00[i,1] &
                      ID..Reference.identifier. == df00[i,2] &
                      Date.Time..Deployed. == df00[i,3] &
                      Date.time.end..Retrieved. == df00[i,4] &
                      Latitude == df00[i,5] &
                      Longitude == df00[i,6]
  )
  if (df00[i, "n"] > 2){
    z <- df_temp$Depth.water..m...Sediment.trap.deployment.depth.
    Fz <- df_temp$POC.flux..mg.m..2.day.
    lm_model <- lm(z ~ log(Fz))
    summary(lm_model)
    slope <- as.numeric(coefficients(lm_model)[2])
    z_star <- -slope
    minD <- min(z)
    FminD <- Fz[which.min(z)] 
    RLS <- append(RLS, z_star)
    min_depth <- append(min_depth, minD)
    min_POC <- append(min_POC, FminD)
  } else {
    RLS <- append(RLS, NA)
    min_depth <- append(min_depth, NA)
    min_POC <- append(min_POC, NA)
  }
}
df00$RLS <- RLS 
df00$Min_Depth <- min_depth
df00$Min_POC <- min_POC
df01 <- filter(df00, !is.na(RLS) & !is.na(Min_Depth) & !is.na(Min_POC))
df02 <- filter(df01, RLS > 0)

## extract the Month ##
Date_formatted <- as.Date(df02$Date.time.end..Retrieved., format = "%Y-%m-%d")
library(lubridate)
Date_month <- month(as.POSIXlt(Date_formatted, format="%Y-%m-%d"))
df02$Month <- Date_month

#Get the world map country border points
library(maps)
library(ggplot2)
world_map <- map_data("world")

#Creat a base plot with gpplot2
p <- ggplot() + coord_fixed() +
  xlab("") + ylab("")

#Add map to base plot
base_world_messy <- p + geom_polygon(data=world_map, aes(x=long, y=lat, group=group), 
                                     colour="light green", fill="light green")

base_world_messy

#Strip the map down so it looks super clean (and beautiful!)
cleanup <- 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_rect(fill = 'white', colour = 'white'), 
        axis.line = element_line(colour = "white"), legend.position="none",
        axis.ticks=element_blank(), axis.text.x=element_blank(),
        axis.text.y=element_blank())

base_world <- base_world_messy + cleanup

base_world

#Add simple data points to map
map_data <- 
  base_world +
  geom_point(data=df02, 
             aes(x=Longitude, y=Latitude), colour="Dark Blue", 
             fill="Sky Blue",pch=21, size=5, alpha=I(0.7))

map_data

#Add data points to map with value affecting size
map_data_sized <- 
  base_world +
  geom_point(data=df02, 
             aes(x=Longitude, y=Latitude, size=n), colour="Dark Blue", 
             fill="Light Blue", pch=21, alpha=I(0.7))


map_data_sized

## collect the sea surface temperature data ##
TList <- list()
for (i in 1:13){
  Temperature <- read.csv(paste("../data/Temperature", i, ".csv", sep = ""), header = FALSE)
  colnames(Temperature)[1:3] <- c("Lat", "Lon", "0")
  colnames(Temperature)[4:ncol(Temperature)] <- Temperature[2, c(4:ncol(Temperature))]
  Temperature <- Temperature[-c(1,2),]
  Temperature$Lat <- as.numeric(as.character(Temperature$Lat))
  Temperature$Lon <- as.numeric(as.character(Temperature$Lon))
  Temperature$`0` <- as.numeric(as.character(Temperature$`0`))
  TList[[i]] <- Temperature
}

for(i in 1:nrow(df02)){
  if(!is.na(df02$Month[i])){
    MM <- as.numeric(df02$Month[i])
    TemperatureTemp <- TList[[MM]]
  } else{
    TemperatureTemp <- TList[[13]]
  }
  
  Lat <- df02$Latitude[i]
  Lon <- df02$Longitude[i]
  Dep <- df02$Min_Depth[i]
  Depthvector <- as.numeric(colnames(TemperatureTemp)[3:59])
  temp <- TemperatureTemp[TemperatureTemp$Lat >= Lat-0.5  & TemperatureTemp$Lat <= Lat+0.5, ]
  temp <- temp[which.min(abs(temp$Lon - Lon)),]
  df02$Temperature[i]<- mean(as.numeric(temp[(which.min(abs(Depthvector - Dep))+2)]))
}
nrow(subset(df02, is.na(Temperature)))

## collect the NPP data ##
NPPList <- list()
for (i in 1:12){
  NPP <- read.table(paste("../data/NPP", i, ".xyz", sep = ""))
  colnames(NPP) <- c("lon", "lat", "value")
  NPP <- NPP[-1,]
  NPP <- subset(NPP, value!= -9999)
  NPP$lon <- as.numeric(as.character(NPP$lon))
  NPP$lat <- as.numeric(as.character(NPP$lat))
  NPP$value <- as.numeric(as.character(NPP$value))
  NPPList[[i]] <- NPP
}

for(j in 1:nrow(df02)){
  MM <- as.numeric(df02$Month[j])
  NPPTemp <- NPPList[[MM]]
  Lat <- df02$Latitude[j]
  Lon <- df02$Longitude[j]
  temp <- NPPTemp[NPPTemp$lat >= Lat-0.5  & NPPTemp$lat <= Lat+0.5, ]
  temp <- temp[which.min(abs(temp$lon - Lon)),]
  df02$NPP[j]<- mean(temp$value)
}
nrow(subset(df02, is.na(NPP)))

## fit linear regression to POC sinking rate data ##
W <- read.csv("../data/W.csv")
plot(W$Temperature, W$SV, pch=19)
model1 <- lm(SV ~ Temperature, data = W)
summary(model1)
AIC(model1)
model2 <- lm(log(SV) ~ Temperature, data = W)
summary(model2)
AIC(model2)
model3 <- lm(SV ~ Temperature + NPP, data = W)
summary(model3)
AIC(model3)
model4 <- lm(log(SV) ~ Temperature + NPP, data = W)
summary(model4)
AIC(model4)
library(equatiomatic)
equatiomatic::extract_eq(model4, use_coefs = TRUE)

## fit linear regression to POC remineralization rate data ##
K <- read.csv("../data/K.csv")
plot(K$Temperature, K$k, pch=19)
model5 <- lm(k ~ Temperature, data = K)
summary(model5)
AIC(model5)
model6 <- lm(log(k) ~ Temperature, data = K)
summary(model6)
AIC(model6)
model7 <- lm(k ~ Temperature + NPP, data = K)
summary(model7)
AIC(model7)
model8 <- lm(log(k) ~ Temperature + NPP, data = K)
summary(model8)
AIC(model8)
equatiomatic::extract_eq(model5, use_coefs = TRUE)
ggplot(model5$model, aes_string(x = names(model5$model)[2], y = names(model5$model)[1])) + 
  geom_point() +
  stat_smooth(method = "lm", col = "red") +
  xlab("Sea Surface Temperature, °C") +
  ylab(expression("POC remineralization rate,"~d^{-1})) +
  ggtitle("POC remineralization rate VS Sea Surface Temperature") +
  theme_bw()+
  theme(text = element_text(size = 25))+
  theme(plot.title = element_text(hjust = 0.5))

# remove the NA rows #
df03 <- df02[!is.na(df02$Temperature) & !is.na(df02$NPP),]

## functions for POC sinking rate and remineralization rate ##
WR <- function(Temperature, NPP){
  Result <- exp(1.3525367 + 0.1388032 * Temperature + 0.0004485 * NPP)
  return(Result)
}
KR <- function(Temperature){
  Result <- 0.0075625 + 0.0065311 * Temperature
  if(Result<0.01){
    Result <- sample(seq(0.01, 0.012, 0.0001), 1)
  }
  return(Result)
}

## compare the estimated values with the original ones ##
for(i in 1:nrow(W)){
  W$W1[i] <- WR(W$Temperature[i], W$NPP[i])
}
plot(W$W1~W$SV, pch = 19)
abline(0,1, lwd = 3, col = "red")
ggplot(W, aes(x = SV, y = W1)) + 
  geom_point(pch = 19, size = 3) +
  geom_abline(lwd = 2, col = "red", lty = 2)+
  xlab(expression("Observed POC sinking rate,"~m~d^{-1})) +
  ylab(expression("Modelled POC sinking rate,"~m~d^{-1})) +
  xlim(0, 200)+
  ylim(0, 200)+
  ggtitle("Modelled POC sinking rate VS Observed POC sinking rate") +
  theme_bw()+
  theme(text = element_text(size = 20)) +
  theme(plot.title = element_text(hjust = 0.5))
for(i in 1:nrow(K)){
  K$K1[i] <- KR(K$Temperature[i])
}
plot(K$K1~K$k, pch = 19)
abline(0,1, lwd = 3, col = "red")
ggplot(K, aes(x = k, y = K1)) + 
  geom_point(pch = 19, size = 3) +
  geom_abline(lwd = 2, col = "red", lty = 2)+
  xlab(expression("Observed POC remineralization rate,"~d^{-1})) +
  ylab(expression("Modelled POC remineralization rate,"~d^{-1})) +
  xlim(0, 0.15)+
  ylim(0, 0.15)+
  ggtitle("Modelled POC remineralization rate VS Observed POC remineralization rate") +
  theme_bw()+
  theme(text = element_text(size = 20)) +
  theme(plot.title = element_text(hjust = 0.5))

## obtain the modelled RLS ##
for(i in 1:nrow(df03)){
  df03$W[i] <- WR(df03$Temperature[i], df03$NPP[i])
  df03$K[i] <- KR(df03$Temperature[i])
}
df04 <- df03[df03$W>0 & df03$K>0,]
df04$z_star <- df04$W/df04$K
summary(df04$z_star)
summary(df04$RLS)
summary(df04$W)
summary(df04$K)
hist(df04$z_star)
hist(df04$RLS)
df04 <- df04[df04$z_star<=2000 & df04$RLS<=2000 & df04$z_star>0 & df04$RLS>100,]
summary(df04$z_star)
summary(df04$RLS)
hist(df04$z_star, xlab = "Modelled RLS, m", 
     main = "Histogram of Modelled RLS",
     xlim = c(0, 2010),
     ylim = c(0, 400),
     cex.main = 2,
     cex.lab = 2,
     cex.axis = 2)
hist(df04$RLS, xlab = "Observed RLS, m", 
     main = "Histogram of Observed RLS",
     xlim = c(0, 2010),
     ylim = c(0, 400),
     cex.main = 2,
     cex.lab = 2,
     cex.axis = 2)


## compare the modelled RLS with observed ones ##
plot(df04$z_star~df04$RLS, xlim = c(0, 2010), ylim = c(0, 2010), pch = 19, xlab = "z* observed from Mouw data", ylab = "z* modelled from W and K")
abline(0,1, lwd = 3, col = "red")
df04$resid <- df04$RLS - df04$z_star

## investigate Temperature VS Residuals ##
df04$NPP_Group <- NA
for(z in 1:nrow(df04)){
  NPP <- df04$NPP[z]
  if (NPP >= 0 & NPP < 1000){
    df04$NPP_Group[z] <- "A: 0-1000"
  } else if (NPP >= 1000 & NPP < 2000){
    df04$NPP_Group[z] <- "B: 1000-2000"
  } else if (NPP >= 2000 & NPP < 3000){
    df04$NPP_Group[z] <- "C: 2000-3000"
  } else if (NPP >= 3000 & NPP < 4000){
    df04$NPP_Group[z] <- "D: 3000-4000"
  } else if (NPP >= 4000 & NPP < 5000){
    df04$NPP_Group[z] <- "E: 4000-5000"
  } 
}

p1 <- ggplot(data = df04, aes(x = Temperature, y = resid, color = NPP_Group))+
  geom_point()+
  theme_bw()+
  geom_hline(yintercept=0, linetype="dashed", 
             color = "red", size=1.5)+
  guides(col=guide_legend("Groups by NPP"))+
  xlab("Sea Surface Temperature, °C")+
  ylab("Residuals, m")+
  ggtitle("Residuals between observed RLS and modelled RLS")+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(text = element_text(size = 25))

p1

nrow(subset(df04, resid<=500 & resid>=-500))/nrow(df04)*100
nrow(subset(df04, Temperature<=15))/nrow(df04)*100
T1015 <- subset(df04, Temperature>=10&Temperature<=15)
nrow(subset(T1015, resid<0))/nrow(T1015)*100
nrow(subset(T1015, resid>0))/nrow(T1015)*100
T15 <- subset(df04, Temperature>=15 & Temperature<=20)
nrow(subset(T15, NPP<1000))/nrow(T15)*100
nrow(subset(T15, resid<0))/nrow(T15)*100
nrow(subset(T15, resid>0))/nrow(T15)*100
T15N <- subset(T15, resid<0)
TN <- subset(df04, resid<0)
TP <- subset(df04, resid>0)
summary(df04$resid)
hist(df04$resid)
summary(df04$Temperature)

map_dataT15N <- 
  base_world + 
  geom_point(data=T15N, 
             aes(x=Longitude, y=Latitude), colour="Dark blue", 
             fill="blue",pch=21, size=3, alpha=I(0.7))

map_dataT15N

## investigate NPP VS Residuals ##
df04$Temperature_Group <- NA
for(j in 1:nrow(df04)){
  Temperature <- df04$Temperature[j]
  if (Temperature >= 5 & Temperature < 10){
    df04$Temperature_Group[j] <- "C: 5-10"
  } else if (Temperature >= 10 & Temperature < 15){
    df04$Temperature_Group[j] <- "D: 10-15"
  } else if (Temperature >= 15 & Temperature < 20){
    df04$Temperature_Group[j] <- "E: 15-20"
  } else if (Temperature >= 20 & Temperature < 25){
    df04$Temperature_Group[j] <- "F: 20-25"
  } else if (Temperature >= 25 & Temperature < 30){
    df04$Temperature_Group[j] <- "G: 25-30"
  } else if (Temperature >= 0 & Temperature < 5){
    df04$Temperature_Group[j] <- "B: 0-5"
  } else if (Temperature < 0){
    df04$Temperature_Group[j] <- "A: <0"
  }
}

p2 <- ggplot(data = df04, aes(x = NPP, y = resid, color = Temperature_Group))+
  geom_point()+
  theme_bw()+
  geom_hline(yintercept=0, linetype="dashed", color = "red", size=1.5)+
  guides(col=guide_legend("Groups by Temperature"))+
  ylab("Residuals, m")+
  xlab(expression("Net Primary Production,"~~mgC~m^{-2}~d^{-1}))+
  ggtitle("Residuals between observed RLS and modelled RLS")+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(text = element_text(size = 25))
p2
summary(df04$NPP)
hist(df04$NPP)
PP1000 <- subset(df04, NPP<1000)
nrow(PP1000)/nrow(df04)*100
nrow(subset(PP1000, resid<0))/nrow(PP1000)*100
nrow(subset(PP1000, resid>0))/nrow(PP1000)*100
PP1000N <- subset(PP1000, resid<0)
PP1000P <- subset(PP1000, resid>0)
PP12 <- subset(df04, NPP>1000&NPP<2000)
nrow(subset(PP12, resid<0))/nrow(PP12)*100
nrow(subset(PP12, resid>0))/nrow(PP12)*100
PP2000 <- subset(df04, NPP>2000)
nrow(subset(PP2000, resid<0))/nrow(PP2000)*100
nrow(subset(PP2000, resid>0))/nrow(PP2000)*100
PPL2 <- subset(df04, NPP<2000)
nrow(subset(PPL2, resid<0))/nrow(PPL2)*100
nrow(subset(PPL2, resid>0))/nrow(PPL2)*100


## make a boxplot ##
boxplot(df04$RLS, df04$z_star, col = c("sky blue", "yellow") ,
        names=c("RLS observed from Mouw data", "RLS modelled from w and k"),
        main = "Observed and modelled Remineralization Length Scales", 
        ylab = "Depth, m", 
        cex.lab = 2,
        cex.axis = 2,
        cex.main = 2,
        cex.sub = 2)
legend("topright", c("Observed RLS", "modelled RLS"), 
       border="black", 
       fill = c("sky blue", "yellow"), 
       cex=2)
## statistical test ##
hist(df04$RLS)
hist(df04$z_star)
shapiro.test(df04$RLS)
shapiro.test(df04$z_star)
wilcox.test(df04$RLS, df04$z_star, paired = TRUE)
wilcox.test(df04$RLS, df04$z_star, paired = TRUE, alternative = "greater")

## collect global NPP data ##
NPP1 <- NPPList[[1]]
NPP2 <- NPPList[[2]]
NPP3 <- NPPList[[3]]
NPP4 <- NPPList[[4]]
NPP5 <- NPPList[[5]]
NPP6 <- NPPList[[6]]
NPP7 <- NPPList[[7]]
NPP8 <- NPPList[[8]]
NPP9 <- NPPList[[9]]
NPP10 <- NPPList[[10]]
NPP11 <- NPPList[[11]]
NPP12 <- NPPList[[12]]
dfNPP <- rbind(NPP1, NPP2, NPP3, NPP4, NPP5, NPP6, NPP7, NPP8, NPP9, NPP10, NPP11, NPP12)
dfNPP <- subset(dfNPP, !is.na(value))
dfNPP <- dfNPP %>%
  group_by(lon, lat) %>%
  summarise(mean.value = mean(value))
summary(dfNPP$mean.value)

## collect global sea surface temperature data ##
Temperature <- read.csv("../data/Temperature.csv")
Temperature <- subset(Temperature, select = c("Latitude", "Longitude", "X100"))

for(i in 1:nrow(Temperature)){
  Lat <- Temperature$Latitude[i]
  Lon <- Temperature$Longitude[i]
  temp <- subset(dfNPP, lat>=Lat-0.1&lat<=Lat+0.1)
  temp <- temp[which.min(abs(temp$lon - Lon)),]
  Temperature$NPP[i]<- mean(as.numeric(temp$mean.value))
}
nrow(subset(Temperature, is.na(NPP)))
Temperature <- subset(Temperature, !is.na(X100))
summary(Temperature$X100)

## predict global RLS ##
df7 <- subset(Temperature, !is.na(X100))
for(i in 1:nrow(df7)){
  df7$W[i] <- WR(df7$X100[i], df7$NPP[i])
  df7$K[i] <- KR(df7$X100[i])
}
df71 <- df7
df71$z_star <- df71$W/df71$K
df71 <- subset(df71, !is.na(z_star))
summary(df71$W)
summary(df71$K)
summary(df71$z_star)
hist(df71$z_star)

## load packages ##
library(squash)
library(maps)
library(mapdata)
library(mapproj)
library(ggmap)
library(viridis)
library(rnaturalearth)
library(RgoogleMaps)
library(sp)
library(lattice)
library(latticeExtra)
library(ggplot2)
library(rasterVis)
library(raster)
library(maptools)
library(magrittr)
library(stringr)
library(rworldmap)
library(gridExtra)

## GIS plot ##
raster_plot <- function(x, title, key){
  xy <- x[,c(2,3)] # select lon and lat and make new df
  spdf.2 <- SpatialPointsDataFrame(coords = xy, data = x,
                                   proj4string = CRS("+proj=longlat +datum=WGS84
                                                     +ellps=WGS84 +towgs84=0,0,0"))
  pixels.2 <- SpatialPixelsDataFrame(spdf.2, tolerance = 0.914959, spdf.2@data)
  gridded(pixels.2) = TRUE
  ipcc.t.100 <- raster(pixels.2) # turn into raster
  levelplot(ipcc.t.100, xlim=c(-180,180), ylim=c(-80,80), margin=FALSE,
            xlab=list("", cex=1), ylab=list("", cex=1),
            col.regions=viridis(300), 
            main=title,
            at=seq(min(x[,1]), max(x[,1]), length=70),
            colorkey=list(at=seq(min(x[,1]), max(x[,1]), length = 70),
                          labels=list(at=key),
                          labels=key),
            panel = function(x, y, ...){
              panel.levelplot(x, y, ...)
              mp <- map("world", plot = FALSE, fill = TRUE, interior = FALSE, bg="yellow")
              lpolygon(mp$x, mp$y, fill = "black", col = "black")}
  )
}

## E-ratio function ##
E.ratio <- function(SST){
  0.23*exp(-0.08*SST)
}

## predict global particle transfer efficiency ##
df71 <- read.csv("../data/df71.csv")
df71$Fz0 <- NA
df71$PEeff <- NA
df71$POC1000 <- NA
df71$POC2000 <- NA
df71$Teff <- NA
z0 <- 100
z1 <- 1000
z2 <- 2000

for(i in 1:nrow(df71)){
  df71$PEeff[i] <- E.ratio(df71$X100[i])
  df71$Fz0[i] <-  df71$PEeff[i]*df71$NPP[i]
  df71$POC1000[i] <- df71$Fz0[i]*exp(-(z1-z0)/df71$z_star[i])
  df71$POC2000[i] <- df71$Fz0[i]*exp(-(z2-z0)/df71$z_star[i])
  df71$Teff[i] <- df71$POC1000[i]/df71$Fz0[i] 
}
summary(df71$Fz0)
summary(df71$PEeff)
summary(df71$POC1000)
summary(df71$POC2000)
summary(df71$Teff)

## plot global NPP ##
NPPGlobal <- read.csv("../data/NPPG.csv")
NPPGlobal <- subset(NPPGlobal, select = c(2,3,4))
title1 <- expression("Net primary production,"~~mgC~m^{-2}~d^{-1}) 
summary(NPPGlobal[,1])
key1 <- seq(0, 1500, by = 200)
raster_plot(NPPGlobal, title1, key1)

## plot global SST ##
SST <- read.csv("../data/TemperatureG.csv")
SST <- subset(SST, select = c(2,3,4))
title2 <- "Sea Surface Temperature at 100 m depth, °C"
summary(SST[,1])
key2 <- seq(-2, 30, by = 5)
raster_plot(SST, title2, key2)

## plot global RLS ##
RLS <- read.csv("../data/RLS.csv")
RLS <- subset(RLS, select = c(2,3,4))
summary(RLS[,1])
key3 <- seq(200, 1400, by = 200)
title3 <- "Remineralization length scale, m"
raster_plot(RLS, title3, key3)


## plot global export efficiency ##
PEE <- read.csv("../data/PE.csv")
PEE <- subset(PEE, select = c(2,3,4))
summary(PEE[,1])
key4 <- seq(0, 0.3, by = 0.05)
title4 <- "Particle export efficiency"
raster_plot(PEE, title4, key4)

## plot global transfer efficiency ##
PTE <- read.csv("../data/TE.csv")
PTE <- subset(PTE, select = c(2,3,4))
summary(PTE[,1])
key5 <- seq(0, 0.4, by = 0.05)
title5 <- "Particle Transfer efficiency"
raster_plot(PTE, title5, key5)

## plot POC flux at 100 m
POC100 <- read.csv("../data/POC100.csv")
POC100 <- subset(POC100, select = c(2,3,4))
summary(POC100[,1])
key6 <- seq(0, 120, by = 20)
title6 <- expression("POC flux at 100 m,"~~mgC~m^{-2}~d^{-1})
raster_plot(POC100, title6, key6)

## plot POC flux at 1000 m
POC1000 <- read.csv("../data/POC1000.csv")
POC1000 <- subset(POC1000, select = c(2,3,4))
summary(POC1000[,1])
key7 <- seq(0, 12, by = 2)
title7 <- expression("POC flux at 1000 m,"~~mgC~m^{-2}~d^{-1})
raster_plot(POC1000, title7, key7)

## plot POC flux at 2000 m
POC2000 <- read.csv("../data/POC2000.csv")
POC2000 <- subset(POC2000, select = c(2,3,4))
summary(POC2000[,1])
key8 <- seq(0, 1.2, by = 0.2)
title8 <- expression("POC flux at 2000 m,"~~mgC~m^{-2}~d^{-1})
raster_plot(POC2000, title8, key8)