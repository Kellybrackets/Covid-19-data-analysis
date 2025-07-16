library(tidyverse)   # Data manipulation & visualization
library(lubridate)   # Date handling
library(ggplot2)     # Advanced plotting
library(corrplot)    # Correlation matrix
library(ggpubr)      # Publication-ready plots
library(skimr)       # Quick data summary
library(rpart)       # Decision trees
library(rpart.plot)  # Decision tree visualization
library(caret)       # Machine learning
library(ROCR)        # Model performance

# Load data
covid_data <- read.csv("Covid Data.csv", stringsAsFactors = FALSE)

# Initial look
head(covid_data)
skim(covid_data)  # Summary statistics

# Check Missing Values
colSums(is.na(covid_data))  # Count missing values per column

# Data Cleaning & Preprocessing
##Handle Missing/Invalid Values

# Replace "9999-99-99" (survivors) with NA
covid_data$DATE_DIED[covid_data$DATE_DIED == "9999-99-99"] <- NA

# Convert DATE_DIED to proper date format
covid_data$DATE_DIED <- as.Date(covid_data$DATE_DIED, format = "%d/%m/%Y")

# Replace 97, 98, 99 (unknown/missing) with NA
cols_to_clean <- c("INTUBED", "PNEUMONIA", "PREGNANT", "ICU")
covid_data[cols_to_clean] <- lapply(covid_data[cols_to_clean], function(x) ifelse(x %in% c(97, 98, 99), NA, x))

# Create a 'DIED' binary column (1 = died, 0 = survived)
covid_data$DIED <- ifelse(is.na(covid_data$DATE_DIED), 0, 1)

## Recode Category values
# Sex (1 = Male, 2 = Female)
covid_data$SEX <- factor(covid_data$SEX, levels = c(1, 2), labels = c("Male", "Female"))

# Patient Type (1 = Hospitalized, 2 = Outpatient)
covid_data$PATIENT_TYPE <- factor(covid_data$PATIENT_TYPE, levels = c(1, 2), labels = c("Hospitalized", "Outpatient"))

# Yes/No variables (1 = Yes, 2 = No)
binary_vars <- c("DIABETES", "COPD", "ASTHMA", "INMSUPR", "HIPERTENSION", "OTHER_DISEASE", "CARDIOVASCULAR", "OBESITY", "RENAL_CHRONIC", "TOBACCO")
covid_data[binary_vars] <- lapply(covid_data[binary_vars], function(x) ifelse(x == 1, "Yes", "No"))

# Exploratory Data Analysis
## Mortality Rate
mortality_rate <- mean(covid_data$DIED) * 100
cat("Overall Mortality Rate:", round(mortality_rate, 2), "%")

## Age Distribution by Survival Status
ggplot(covid_data, aes(x = AGE, fill = factor(DIED))) +
  geom_histogram(binwidth = 5, alpha = 0.7) +
  labs(title = "Age Distribution by Survival Status", x = "Age", y = "Count", fill = "Died") +
  scale_fill_manual(values = c("blue", "red"), labels = c("Survived", "Died")) +
  theme_minimal()

## Comorbidities & Mortality
comorbidities <- c("DIABETES", "HIPERTENSION", "OBESITY", "CARDIOVASCULAR", "RENAL_CHRONIC")

comorbidity_analysis <- covid_data %>%
  select(all_of(comorbidities), DIED) %>%
  pivot_longer(cols = -DIED, names_to = "Comorbidity", values_to = "Presence") %>%
  group_by(Comorbidity, Presence) %>%
  summarise(Mortality_Rate = mean(DIED) * 100, .groups = "drop")

ggplot(comorbidity_analysis, aes(x = Comorbidity, y = Mortality_Rate, fill = Presence))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Mortality Rate by Comorbidity", y = "Mortality Rate (%)", fill = "Has Comorbidity") +
  theme_minimal()

## ICU & Intubation Impact
treatment_impact <- covid_data %>%
  filter(!is.na(ICU) & !is.na(INTUBED))) %>%
  group_by(ICU, INTUBED) %>%
  summarise(Mortality_Rate = mean(DIED) * 100, .groups = "drop")

ggplot(treatment_impact, aes(x = factor(ICU), y = Mortality_Rate, fill = factor(INTUBED)))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Mortality Rate by ICU & Intubation Status", x = "ICU Admission", y = "Mortality Rate (%)", fill = "Intubated") +
  scale_x_discrete(labels = c("No ICU", "ICU")) +
  theme_minimal()

## Time Trend of Deaths
covid_data %>%
  filter(!is.na(DATE_DIED))) %>%
  mutate(Month = floor_date(DATE_DIED, "month")) %>%
  count(Month) %>%
  ggplot(aes(x = Month, y = n)) +
  geom_line(color = "red") +
  geom_point(color = "darkred") +
  labs(title = "Monthly COVID-19 Deaths", x = "Month", y = "Death Count") +
  theme_minimal()

## Correlation Matrix (Numeric Variables)
numeric_vars <- covid_data %>%
  select(AGE, DIED, INTUBED, PNEUMONIA, ICU) %>%
  drop_na()

cor_matrix <- cor(numeric_vars)
corrplot(cor_matrix, method = "color", type = "upper", tl.col = "black", addCoef.col = "black")

#Predictive Modeling (Logistic Regression)
##Predicting Mortality
# Prepare data
model_data <- covid_data %>%
  select(AGE, SEX, DIABETES, HIPERTENSION, OBESITY, PNEUMONIA, ICU, DIED) %>%
  drop_na()

# Split into training & test sets
set.seed(123)
train_index <- createDataPartition(model_data$DIED, p = 0.8, list = FALSE)
train_data <- model_data[train_index, ]
test_data <- model_data[-train_index, ]

# Train logistic regression
model <- glm(DIED ~ AGE + SEX + DIABETES + HIPERTENSION + OBESITY + PNEUMONIA + ICU, 
             data = train_data, family = binomial)

summary(model)  # Check coefficients

# Predict on test data
test_data$Predicted_Prob <- predict(model, test_data, type = "response")
test_data$Predicted_Class <- ifelse(test_data$Predicted_Prob > 0.5, 1, 0)

# Confusion Matrix
confusionMatrix(factor(test_data$Predicted_Class), factor(test_data$DIED))

## ROC Curve (Model Performance)
pred <- prediction(test_data$Predicted_Prob, test_data$DIED)
perf <- performance(pred, "tpr", "fpr")
plot(perf, colorize = TRUE, main = "ROC Curve for Mortality Prediction")
abline(a = 0, b = 1, lty = 2)

#Decision Tree for ICU Admission Prediction

# Prepare data
icu_data <- covid_data %>%
  select(AGE, SEX, DIABETES, HIPERTENSION, OBESITY, PNEUMONIA, INTUBED, ICU) %>%
  drop_na()

# Train decision tree
tree_model <- rpart(ICU ~ ., data = icu_data, method = "class")
rpart.plot(tree_model, main = "Decision Tree for ICU Admission")
