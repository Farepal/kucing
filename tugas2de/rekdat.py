# Import necessary libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Read the data
customer_data = pd.read_csv("./ml_case_training_data.csv", na_values=['', 'NA'])

# Summary statistics
print(customer_data.describe(include='all'))

# Checking for duplicated data
print("Any duplicated data:", customer_data.duplicated().any())

# Exploring data types
print(customer_data.dtypes)

# Handling missing values in 'activity_new'
print("Unique values in 'activity_new':", customer_data['activity_new'].unique())
activity_counts = customer_data['activity_new'].value_counts(dropna=False)
print(activity_counts)
customer_data['activity_new'] = customer_data['activity_new'].fillna('new_category')

# Handling missing values in 'channel_sales'
print("Unique values in 'channel_sales':", customer_data['channel_sales'].unique())
channel_counts = customer_data['channel_sales'].value_counts(dropna=False)
print(channel_counts)
most_frequent_channel = customer_data['channel_sales'].mode()[0]
customer_data['channel_sales'] = customer_data['channel_sales'].fillna(most_frequent_channel)

# Handling missing values in 'origin_up'
print("Unique values in 'origin_up':", customer_data['origin_up'].unique())
origin_counts = customer_data['origin_up'].value_counts(dropna=False)
print(origin_counts)
most_frequent_origin = customer_data['origin_up'].mode()[0]
customer_data['origin_up'] = customer_data['origin_up'].fillna(most_frequent_origin)

# Convert 'has_gas' to numeric
customer_data['has_gas'] = customer_data['has_gas'].map({'f':0, 't':1})

# Imputing missing values with median for numerical columns
numerical_cols = customer_data.select_dtypes(include=['float64', 'int64']).columns
for col in numerical_cols:
    median_value = customer_data[col].median()
    customer_data[col].fillna(median_value, inplace=True)

# Convert date columns to datetime
date_columns = ['date_activ', 'date_end', 'date_modif_prod', 'date_renewal']
for col in date_columns:
    customer_data[col] = pd.to_datetime(customer_data[col], infer_datetime_format=True, errors='coerce')
    median_date = customer_data[col].median()
    customer_data[col].fillna(median_date, inplace=True)

# Visualizing missing data
import missingno as msno
msno.matrix(customer_data)
plt.show()

# Replace negative values with median
cols_with_negatives = ['cons_12m', 'cons_gas_12m', 'cons_last_month', 'forecast_cons_12m',
                       'forecast_cons_year', 'forecast_meter_rent_12m', 'forecast_price_pow_p1',
                       'imp_cons', 'margin_gross_pow_ele', 'margin_net_pow_ele', 'net_margin']
for col in cols_with_negatives:
    median_value = customer_data.loc[customer_data[col] >= 0, col].median()
    customer_data.loc[customer_data[col] < 0, col] = median_value

# Boxplots to visualize outliers
sns.boxplot(x=customer_data['cons_12m'])
plt.title('Boxplot of cons_12m')
plt.show()

sns.boxplot(x=customer_data['forecast_cons_12m'])
plt.title('Boxplot of forecast_cons_12m')
plt.show()

# Outlier detection and replacement for 'cons_12m'
from scipy import stats
z_scores = np.abs(stats.zscore(customer_data['cons_12m']))
threshold = 3
outliers = np.where(z_scores > threshold)
median_value = customer_data['cons_12m'].median()
customer_data.loc[outliers, 'cons_12m'] = median_value

# Check the boxplot again
sns.boxplot(x=customer_data['cons_12m'])
plt.title('Boxplot of cons_12m after outlier treatment')
plt.show()

# Selecting numeric variables
continuous = customer_data.select_dtypes(include=['number'])

# Visualizing correlation plot
corr = continuous.corr()
plt.figure(figsize=(12,10))
sns.heatmap(corr, cmap='coolwarm', annot=False)
plt.title('Correlation Matrix')
plt.show()

# Dropping columns with high correlation or not needed
final_data = continuous.drop(columns=['forecast_cons_year', 'margin_net_pow_ele'], errors='ignore')

# Apply log transformations
cols_to_transform = ['cons_12m', 'cons_gas_12m', 'cons_last_month', 'forecast_cons_12m',
                     'forecast_discount_energy', 'forecast_meter_rent_12m',
                     'forecast_price_energy_p1', 'forecast_price_energy_p2',
                     'forecast_price_pow_p1', 'has_gas', 'imp_cons', 'margin_gross_pow_ele',
                     'nb_prod_act', 'net_margin', 'num_years_antig', 'pow_max']
for col in cols_to_transform:
    if col in final_data.columns:
        final_data[col] = np.log10(final_data[col] + 1)

# Before and after transformation histograms for 'cons_12m'
plt.figure(figsize=(10,6))
plt.hist(customer_data['cons_12m'].dropna(), bins=30)
plt.title('Before transformation - cons_12m')
plt.xlabel('cons_12m')
plt.ylabel('Frequency')
plt.show()

plt.figure(figsize=(10,6))
plt.hist(final_data['cons_12m'].dropna(), bins=30)
plt.title('After transformation - cons_12m')
plt.xlabel('cons_12m')
plt.ylabel('Frequency')
plt.show()
