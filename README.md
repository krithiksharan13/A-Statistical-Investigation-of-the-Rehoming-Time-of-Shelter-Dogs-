# 🐕 Dog Rehoming Time Analysis

**Statistical Modelling, Inference, and Comparison Across Breeds**

![R](https://img.shields.io/badge/R-276DC3?style=flat&logo=r&logoColor=white)
![Statistics](https://img.shields.io/badge/Statistics-Inference%20%26%20Modelling-blue)
![Postgraduate](https://img.shields.io/badge/Level-Postgraduate-success)
![Coursework](https://img.shields.io/badge/Type-Coursework-orange)

## 📌 Project Overview

This project analyses **rehoming times for dogs in an animal shelter**,
with the goal of understanding whether **breed influences how long a dog
waits before adoption**. Using classical statistical methods at a
**postgraduate level**, the project explores data cleaning, exploratory
analysis, probability modelling, confidence intervals, and breed
comparisons.

The analysis focuses on three dog breeds: - Labrador Retriever\
- Shih Tzu\
- Staffordshire Bull Terrier

The work is designed to be interpretable to readers with a background in
statistics, without requiring access to the raw data or R output.

## 🎯 Objectives

1.  Examine the distribution of rehoming time for each breed\
2.  Identify suitable probability distributions for modelling rehoming
    time\
3.  Test whether the mean rehoming time equals **27 weeks**\
4.  Compare mean rehoming times across breeds

## 🧾 Dataset Description

Each row represents a **single dog** entering an animal shelter.

Key variables: - Rehomed (weeks to adoption) - Visited (weeks to first
visit) - Health (0--100 scale) - Breed - Age (puppy or fully grown) -
Reason for entry - Returned (previously rehomed or not)

Missing rehoming times were coded as `99999`.

## 🧹 Data Cleaning

The original dataset contained **308 observations**. Rows with missing
breed, missing return status, or invalid rehoming times were removed.\
After cleaning, **279 complete cases** remained, representing a data
loss of approximately **9.4%**.

## 🔍 Exploratory Analysis

Exploration showed: - Rehoming time is **right-skewed** - Median
rehoming times are similar across breeds - Staffordshire Bull Terriers
showed greater variability

## 📊 Modelling and Estimation

Three distributions were evaluated: - Exponential - Gamma - Lognormal

The Exponential model showed poor fit and was rejected.\
Gamma and Lognormal models provided reasonable approximations, supported
by Q--Q plots.

## 📐 Statistical Inference

95% confidence intervals were used to test whether mean rehoming time
equals 27 weeks.

-   t intervals for Labrador Retrievers and Shih Tzus\
-   z interval for Staffordshire Bull Terriers due to large sample size

All intervals lay below 27 weeks.

## 🔄 Breed Comparison

Pairwise confidence intervals for differences in means showed no
statistically significant differences between breeds.

## 🧠 Key Conclusions

-   Rehoming time is non-normal and right-skewed\
-   Gamma and Lognormal models are appropriate\
-   Dogs are rehomed faster than 27 weeks on average\
-   Breed does not meaningfully affect rehoming time

## ⚠️ Limitations

-   Breed-only analysis
-   Skewed distributions
-   Smaller sample for Shih Tzus

## 🚀 Future Work

-   Behavioural variables
-   Survival analysis approaches
-   Adopter preference modelling

## 🛠️ Tools Used

-   R
-   Base R graphics
-   Classical statistical inference

## 📜 Disclaimer

This project was completed as **postgraduate coursework**.\
The dataset is course-provided and should not be redistributed.
