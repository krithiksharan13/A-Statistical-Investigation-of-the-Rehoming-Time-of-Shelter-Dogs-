#code to get my sample data as per instuctions given
load("rehoming.Rdata")
createsample(202000567)
save(mysample, file = "mysample.RData")
#--------------------------------------------------#

#Coursework 1

load("mysample.RData")

#checking the dataframe
head(mysample)
str(mysample)
summary(mysample)

#finding total amount of NA values by the column
colSums(is.na(mysample))
#We can see that only Breed and Returned Columns have NA Values

#Cleaning the data

#counting number of NA in Rehomed, Breed and Returned Columns
na_rehome <- sum(mysample$Rehomed == 99999, na.rm = TRUE)
na_breed <- sum(is.na(mysample$Breed))
na_returned <- sum(is.na(mysample$Returned))

#total number of rows
total_rows <- nrow(mysample)

#converting missing values into percentages
percent_na_rehome <- (na_rehome / total_rows) * 100
percent_na_breed  <- (na_breed / total_rows) * 100
percent_na_returned <- (na_returned / total_rows) *100

#removing all the rows that have an NA Value
clean_data <- subset(mysample, Rehomed != 99999 & !is.na(Breed) & !is.na(Returned))


#Re-checking the presence of NA values
sum(clean_data$Rehomed == 99999)
sum(is.na(clean_data$Breed))
sum(is.na(clean_data$Returned))

#Displaying the row count before Vs After Cleaning
cat("Original dataset size:", total_rows, "\n")
cat("Cleaned dataset size:", nrow(clean_data), "\n")

##Data Exploration

#Split the data by Breed
breedSplit <- split(clean_data, clean_data$Breed)
#add colours to the breeds
breeds <- names(breedSplit)
cols <- c("red", "blue", "darkgreen")
names(cols) <- breeds

#check the different breed names after the splitting
names(breedSplit)

#Generating numerical summaries table
num_summary <- do.call(rbind, lapply(breedSplit, function(d){
  c(
    n                = nrow(d),
    Rehome_mean      = mean(d$Rehomed, na.rm=TRUE),
    Rehome_median    = median(d$Rehomed, na.rm=TRUE),
    Rehome_sd        = sd(d$Rehomed, na.rm=TRUE),
    Rehome_min       = min(d$Rehomed, na.rm=TRUE),
    Rehome_max       = max(d$Rehomed, na.rm=TRUE),
    Visited_mean     = mean(d$Visited, na.rm=TRUE),
    Health_mean      = mean(d$Health,  na.rm=TRUE),
    Puppy_share      = mean(d$Age == "Puppy", na.rm=TRUE) # proportion puppies
  )
}))
num_summary <- round(as.data.frame(num_summary), 2)
num_summary$Breed <- rownames(num_summary)
num_summary <- num_summary[, c("Breed", setdiff(names(num_summary), "Breed"))]
num_summary

# Age composition per breed
table_age <- with(clean_data, table(Breed, Age))
table_age


# Returned share per breed
ret_share <- sapply(breedSplit, function(d) mean(d$Returned == "Yes", na.rm=TRUE))
round(ret_share, 3)
ret_share

# Rehoming time - Visualization

# Boxplot
boxplot(Rehomed ~ Breed, data = clean_data,
        main = "Rehoming Time by Breed",
        xlab = "Breed", ylab = "Weeks to Rehome")

# Overlaid density (base)
plot(NULL,
     xlim = range(clean_data$Rehomed, na.rm=TRUE),
     ylim = c(0, 0.06),
     xlab = "Weeks to Rehome",
     ylab = "Density",
     main = "Density of Rehoming Time by Breed")

for (b in breeds) {
  x <- breedSplit[[b]]$Rehomed
  x <- x[is.finite(x) & !is.na(x)]
  
  # Skip if density cannot be computed (e.g., n < 2)
  if (length(x) < 2 || length(unique(x)) < 2) next
  
  lines(density(x), lwd=2, col = cols[b])
}

legend("topright", legend = breeds, col = cols, lwd=2, bty="n")

# Modelling & parameter estimation for rehoming time

fit_candidates <- function(x){
  x <- x[is.finite(x) & !is.na(x) & x > 0]  # ensure only valid, positive times
  
  m  <- mean(x)
  v  <- var(x)
  
  # Exponential: lambda = 1 / mean
  exp_rate <- 1/m
  
  # Gamma: shape = mean² / variance, rate = mean / variance
  gam_shape <- m^2 / v
  gam_rate  <- m / v
  
  # Lognormal: fit on log-scale
  lx <- log(x)
  ln_mu    <- mean(lx)
  ln_sigma <- sd(lx)
  
  return(list(
    mean = m, var = v,
    exponential = list(rate   = exp_rate),
    gamma       = list(shape  = gam_shape, rate = gam_rate),
    lognormal   = list(mu     = ln_mu,     sigma = ln_sigma)
  ))
}

#apply the parameters to each breed
fits <- lapply(breedSplit, function(d) fit_candidates(d$Rehomed))
fits

#Display as a table
fit_table <- do.call(rbind, lapply(names(fits), function(b){
  f <- fits[[b]]
  data.frame(
    Breed = b,
    Mean = round(f$mean, 3),
    Variance = round(f$var, 3),
    Exp_rate = round(f$exponential$rate, 4),
    Gamma_shape = round(f$gamma$shape, 4),
    Gamma_rate = round(f$gamma$rate, 4),
    Lognormal_mu = round(f$lognormal$mu, 4),
    Lognormal_sigma = round(f$lognormal$sigma, 4)
  )
}))

fit_table

#Graphical checking of Models
par(mfrow=c(1,3))
for(b in names(breedSplit)) {
  x <- breedSplit[[b]]$Rehomed
  x <- x[is.finite(x) & !is.na(x) & x > 0]
  
  plot(ecdf(x), main=paste("ECDF:", b),
       xlab="Weeks", ylab="F(x)")
  
  f <- fits[[b]]$gamma
  curve(pgamma(x, shape=f$shape, rate=f$rate), add=TRUE, col="red")
}
par(mfrow=c(1,1))

#Histogram for Rehome weeks
par(mfrow=c(1,3))
for (b in names(breedSplit)) {
  x <- breedSplit[[b]]$Rehomed
  hist(x, main=paste("Histogram of", b),
       xlab="Weeks to Rehome", col="lightblue", breaks=10)
}
par(mfrow=c(1,1))

#Density plot
par(mfrow=c(1,3))
for (b in names(breedSplit)) {
  x <- breedSplit[[b]]$Rehomed
  d <- density(x)
  plot(d, main=paste("Density of", b),
       xlab="Weeks to Rehome", lwd=2)
}
par(mfrow=c(1,1))

# Q-Q plot
par(mfrow=c(1,3))
for (b in names(breedSplit)) {
  x <- breedSplit[[b]]$Rehomed
  qqnorm(x, main=paste("QQ-plot:", b))
  qqline(x)
}
par(mfrow=c(1,1))


