# DataLens — Interactive Data Analytics Dashboard

DataLens is an interactive **R Shiny data analysis dashboard** designed to make dataset exploration, visualization, correlation analysis, and statistical testing easier through a simple web-based interface.

The application supports both **built-in R datasets and user-uploaded Excel files**, allowing users to explore their data without writing additional R code.

---

## 🚀 Features

- 📂 Load built-in R datasets
- 📊 Upload and analyze Excel files
- 📑 Select different sheets from uploaded Excel workbooks
- 🔍 View dataset summaries using `summary()`
- 📋 Interactive data table with sorting and searching
- 📈 Interactive Histogram
- 📦 Interactive Boxplot
- 🔵 Interactive Scatter Plot
- 🎨 Color visualizations by categorical variables
- 🔥 Correlation heatmap for numerical variables
- 📐 Statistical analysis using:
  - Wilcoxon Rank-Sum Test
  - Kruskal-Wallis Test
- 📊 Dataset overview cards showing:
  - Number of rows
  - Number of columns
  - Missing values
  - Number of numerical variables
- 🖱️ Interactive Plotly visualizations
- 💻 User-friendly Shiny interface

---

## 🖥️ Dashboard Overview

The DataLens dashboard provides several sections for exploring and analyzing datasets.

### 1. Dataset Selection

Users can either select a built-in R dataset or upload an Excel file.

Supported built-in datasets:

- `mtcars`
- `iris`
- `faithful`

For Excel files, users can select the required worksheet after uploading the file.

---

### 2. Dataset Overview

The dashboard provides a quick overview of the selected dataset, including:

- Total number of rows
- Total number of columns
- Total missing values
- Number of numerical variables

This allows users to understand the basic structure of the dataset before performing further analysis.

---

### 3. Summary Statistics

DataLens displays the output of R's `summary()` function to provide a quick statistical overview of the selected dataset.

For numerical variables, this includes measures such as:

- Minimum
- First Quartile
- Median
- Mean
- Third Quartile
- Maximum

---

### 4. Interactive Data Table

The dataset can be explored through an interactive table.

Users can:

- Search values
- Sort columns
- Navigate between pages
- View the dataset in a structured format

The table is implemented using the **DT** package.

---

## 📊 Data Visualization

DataLens provides three main visualization options.

### Histogram

A histogram can be generated for a numerical variable to understand its distribution.

Users can optionally select a categorical variable to color the histogram.

### Boxplot

Boxplots can be used to compare the distribution of a numerical variable across different groups.

Users can select:

- X variable
- Y variable
- Optional categorical variable for coloring

### Scatter Plot

Scatter plots allow users to examine relationships between two numerical variables.

Users can also select a categorical variable to distinguish observations using different colors.

All visualizations are generated using **ggplot2** and converted into interactive charts using **Plotly**.

---

## 🔥 Correlation Analysis

DataLens includes a correlation heatmap for numerical variables.

The heatmap helps users identify relationships between numerical variables.

The application calculates correlations using:

```r
cor(..., use = "complete.obs")
