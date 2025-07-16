# 🦠 COVID-19 Data Analysis Project 📊
---

# Tablaeu link

Project Link: [https://public.tableau.com/app/profile/keletso.ntseno/viz/Covid19Dashboard_17485246956080/Dashboard1](https://public.tableau.com/app/profile/keletso.ntseno/viz/Covid19Dashboard_17485246956080/Dashboard1)) 🔗

## Overview

Dive deep into the impact of the COVID-19 pandemic with this comprehensive data analysis project! 🚀 Utilizing SQL, R, and Python, we explore patient demographics, underlying health conditions (comorbidities), treatment outcomes, and critical mortality rates. Our main goal is to uncover key insights and actionable information from the raw data. 📈

---

## Table of Contents

- [Overview](#overview) 🔍
- [Project Structure](#project-structure) 📂
- [Features](#features) ✨
- [Installation](#installation) ⚙️
- [Usage](#usage) 🚀
- [Results and Insights](#results-and-insights) 💡
- [Technologies Used](#technologies-used) 🛠️
- [Contributing](#contributing) 🤝
- [License](#license) 📝
- [Contact](#contact) 📧

---

## Project Structure

This project is meticulously organized to keep things clear and easy to navigate:

-   `data/`: 🗄️ (Optional) This directory is where any raw or processed data files, including our primary `Covid Data.csv`, can be stored.
-   `sql/`: 🗃️ Contains robust SQL scripts for initial data setup, thorough cleaning, and foundational analysis.
    -   `COVID-19 Data Analysis.sql`: Your go-to SQL file! It sets up the `covid_analysis` database and `covid_patients` table, performs critical data cleaning (handling tricky '9999-99-99' dates and 97/98/99 codes), creates a `survived` flag, and conducts insightful analyses on mortality trends and comorbidity prevalence. 🧹📊
-   `r/`: 📈 Houses powerful R scripts for in-depth statistical analysis, predictive modeling, and stunning visualizations.
    -   `covid_analysis.R`: This R script is a powerhouse! It loads the `Covid Data.csv`, performs initial data inspection and cleaning, engineers new features like age groups and comorbidity flags, conducts exploratory data analysis (distributions, correlations), and builds a logistic regression model for mortality prediction, complete with an ROC curve for performance evaluation. 🎯📉
-   `notebooks/`: 📓 Contains interactive Python Jupyter Notebooks for dynamic data exploration, cleaning, and visualization.
    -   `COVID-19 analysis.ipynb`: This vibrant Jupyter Notebook handles seamless data loading (directly from Kagglehub!), conducts initial data inspection, performs comprehensive data cleaning (handling missing values, duplicates, and type conversions), and dives into specific analyses like ICU admission distributions and mortality rates based on ICU status. 🧑‍💻✨
-   `README.md`: You are here! This very file. 📄

---

## Features

-   **SQL Data Preparation & Analysis**: Set up your dedicated COVID-19 database and table. Experience robust data cleaning and execute powerful SQL queries to analyze mortality trends and uncover the prevalence of various comorbidities. 🚀
-   **R Statistical Modeling**: Leverage R's statistical prowess for advanced analysis, including data manipulation, elegant visualizations, correlation deep dives, and logistic regression modeling to accurately predict mortality. Model performance is evaluated using insightful ROC curves. 📊🔮
-   **Python Data Exploration & Visualization**: Explore interactively with Jupyter Notebooks. Perform extensive data cleaning (tackling missing values, duplicates, and type conversions) and create compelling visualizations focusing on ICU admissions and their critical impact on mortality using `pandas`, `numpy`, `matplotlib`, and `seaborn`. 🐍🎨
-   **Data Source Integration**: Seamlessly fetches the dataset directly from Kagglehub, making setup a breeze! ☁️➡️💾

---

## Installation

Ready to get started? Follow these simple steps to get a local copy up and running! ⬇️

### Prerequisites

* **SQL Database**: You'll need access to a SQL database (e.g., MySQL, PostgreSQL, SQL Server) to run the `.sql` files. Make sure your credentials are in order! 🔑
* **R Environment**:
    * [R](https://www.r-project.org/) 📈
    * [RStudio](https://www.rstudio.com/products/rstudio/download/) (Highly Recommended IDE) 🖥️
    * Essential R packages (install using `install.packages("package_name")` in R):
        * `tidyverse`
        * `lubridate`
        * `ggplot2`
        * `corrplot`
        * `ggpubr`
        * `skimr`
        * `rpart`
        * `rpart.plot`
        * `caret`
        * `ROCR`
* **Python Environment**:
    * [Python 3.x](https://www.python.org/downloads/) 🐍
    * [Jupyter Notebook](https://jupyter.org/install) (install via `pip install jupyter`) 📓
    * Required Python packages (install using `pip install package_name`):
        * `pandas`
        * `numpy`
        * `matplotlib`
        * `seaborn`
        * `kagglehub`

### Steps

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/your_username/your_project_name.git](https://github.com/your_username/your_project_name.git)
    cd your_project_name
    ```
2.  **SQL Setup (if applicable):**
    * Import your `Covid Data.csv` into your SQL database.
    * Execute the SQL script located in the `sql/` directory against your database to set up the table and perform initial data cleaning.
    ```sql
    -- Example command to run a SQL script (varies by database client)
    -- mysql -u your_user -p your_database < sql/COVID-19 Data Analysis.sql
    ```
3.  **R Setup:**
    * Open the `covid_analysis.R` file in RStudio or your preferred R environment.
    * Ensure the `Covid Data.csv` file is readily accessible from the script's working directory.
    * Run the script to reproduce the analysis and generate insights. 📊
4.  **Python Setup:**
    * Navigate to the `notebooks/` directory.
    * Launch Jupyter Notebook:
        ```bash
        jupyter notebook
        ```
    * Open `COVID-19 analysis.ipynb` and execute the cells step-by-step. The notebook will automatically handle downloading the dataset. ✨

---

## Usage

This project showcases a powerful, multi-language approach to complex data analysis. Here's how to navigate it:

-   **SQL:** Simply run the `COVID-19 Data Analysis.sql` file against your SQL database. It will establish the database schema, populate it with meticulously cleaned COVID-19 data, and immediately begin providing insights into various patient characteristics and outcomes. 💡
-   **R:** Execute the `covid_analysis.R` script to unleash a robust framework for statistical analysis and predictive modeling. This will generate insightful statistical summaries, vivid correlation plots, and a thoroughly evaluated logistic regression model for mortality prediction. 📈
-   **Python:** Open the `COVID-19 analysis.ipynb` Jupyter Notebook for an engaging, interactive environment. Run the cells in sequence to effortlessly load the data, apply all preprocessing steps, and generate compelling visualizations that highlight ICU admissions and their critical link to patient mortality. 🧑‍💻📊

---

## Results and Insights

Here's a snapshot of the compelling findings and insights gleaned from this analysis:

-   **Key Metrics**: Discover overall mortality rates, the prevalence of various comorbidities, and other crucial statistics derived directly from our SQL queries. 📉
-   **Predictive Power**: Uncover significant factors influencing mortality as identified by our R-based logistic regression models. Understand the "why" behind the outcomes. 🔮
-   **Visual Narratives**: Explore compelling observations from Python's exploratory data analysis. See vivid visualizations detailing ICU admission distributions and stark differences in mortality rates based on ICU status. (Consider adding screenshots here! 📸)
-   **Actionable Conclusions**: Read our derived conclusions and potential recommendations or next steps based on the comprehensive findings. ➡️

---

## Technologies Used

* **SQL** (e.g., PostgreSQL, MySQL, SQL Server) 💾
* **R** 📊
    * `tidyverse`
    * `lubridate`
    * `ggplot2`
    * `corrplot`
    * `ggpubr`
    * `skimr`
    * `rpart`
    * `rpart.plot`
    * `caret`
    * `ROCR`
* **Python** 🐍
    * `pandas`
    * `numpy`
    * `matplotlib`
    * `seaborn`
    * `Jupyter Notebook` 📓
    * `kagglehub` ☁️

---

## Contributing

Contributions are the heart of the open-source community, making it an amazing place to learn, inspire, and create! Any contributions you make are **greatly appreciated**. 🙏

If you have a suggestion that would make this project even better, please fork the repo and create a pull request. Alternatively, feel free to open an issue with the tag "enhancement".
And hey, don't forget to give the project a star! ⭐ Thanks again!

1.  Fork the Project 🍴
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`) 🌿
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`) 💾
4.  Push to the Branch (`git push origin feature/AmazingFeature`) ⬆️
5.  Open a Pull Request! 📬

---

## License

This project is distributed under the MIT License. See `LICENSE.md` for more information. 📜



