# 
# Let's practice!
# ===============
# 
# In this section we will cover:
# 
#  1. Working directories
#  2. Reading in data
#  3. Advanced data manipulation
#  4. Statistical Analysis
#  
#  
# Step 1: Working Directories
# ---------------------------
# 
# A working directory is the folder on your computer where you are currently
# working. You can find out your current working directory by typing `getwd()`

getwd()

# If you've downloaded and un-zipped this directory to your desktop, you might 
# see something like `/Users/<yourname>/Desktop/IntroR_Workshop`. This is the  
# default place where R will begin reading and writing files. For example, you  
# can use the function `list.files()` to view the files in your current working 
# directory. These are the same files that we downloaded earlier. If you're 
# using Rstudio, you can compare the file list with the "Files" tab in the
# bottom right panel. 
# 
# In order to use `list.files()`, we should provide it with a file path. We can
# provide it a ".", which means "here" to most computer programs.
# 
list.files(".")
# 
# You can see that the first entry in here is "data". This is where we've placed
# the fungicide example data. 
# 
list.files("data")
# 
# Step 2: Reading in Data
# ------------------------
# 
# 
# We can use the `read.csv()` function to read (or import) these data into R. 
# It's important to remember that while in R, these data are simply a copy kept 
# *in memory*, not on the disk, so we don't have to worry too much about
# accidentally deleting the data :).
# 
# So, how do we actually USE the `read.csv()` function? 
# 
?read.csv
# 
# You will notice that the help page describes all the sibling functions, too:
# `read.table()`, `read.csv2()`, `read.delim()`, `read.delim2()`. Let's read the 
# Description and Usage first. All arguments except 'file' have a default value
# (e.g. header = TRUE). You do not need to specify these arguments unless you want 
# to change the default. Let's use `read.csv()` with the default values.
# 
read.csv("data/fungicide_dat.csv")
# 
# Let's use `read.table()` with the default values.
read.table("data/fungicide_dat.csv")
# 
# This has two issues:
# 
# 1. The column names are treated as the first row. This is because the default 
#    for header is FALSE in `read.table()`. We should change to header = TRUE. 
# 2. The data is presented as one column, 'V1'. This is because the separator for 
#    each cell in the data is a "," and not ""(space). We should change to sep = ",". 
# 
read.table("data/fungicide_dat.csv", header = TRUE, sep = ",")
# 
# Now that we have these elements, we can read the data into an object, which we
# can call "fungicide". Once we do this, we can check the dimensions to make sure
# that we have all of the data.
# 
fungicide <- read.csv("data/fungicide_dat.csv")
nrow(fungicide)
ncol(fungicide)
# 
# We can print the data to screen by simply typing its name.
# 
fungicide
# 
# We can use the `str()` function (short for "structure") to have a broad
# overview of what our data looks like. This is useful for data frames with many
# columns.
# 
str(fungicide)
# 
# We can also use the `View()` function to look at our data in spreadsheet-style.
# 
stop("

     Type View(fungicide) and inspect the data
     
     ")
# 
# The dummy data presented here consists of yield (measured in bu/acre) and disease
# severity (measured on a scale of 1 to 10) of a corn culitvar treated with two
# fungicides. This trial was conducted to measure the efficacy of the two fungicides 
# to manage disease. The experiment was laid out as a Completely Randomized Design. 
# 
# With these data, we want to answer the following questions:
# 
# 1. What is the mean yield of each treatment group in kg/ha?
# 2. What is the percent severity of Control and Fungicide A?
# 3. Which fungicide shows better results? (ANOVA)
# 
# Step 3: Advanced data manipulation
# ----------------------------------
# 
# The package 'dplyr' provides functions for easy and advanced data manipulation.
# If we want to use it, we can download the package to our computer with the 
# function `install.packages()`. This will install a package from CRAN and place
# it into your R *Library*.
# 
install.packages("dplyr")
# 
# To load this package, we can use the function `library()`.
# 
library("dplyr")
# 
# 1. What is the mean yield of each treatment group in kg/ha?
# 
# Let's go step by step to answer this:
# 
# a) Convert yield data from bu/acre to kg/ha
# To do this conversion for corn, we need to multiply the yield in bu/acre with
# 62.77. So, how can we add a column with yield data in kg/ha? We can do this 
# similar to what we learnt in Part 1.
# 
# `fungicide$Yield_kg_per_ha <- fungicide$Yield_bu_per_acre*62.77`
# 
# We can also use the function `mutate()` from 'dplyr'. This adds a new variable 
# using existing variables. The usage of this function is as: 
# 
# mutate(data, new_variable_name = calculation_based_upon_existing_variables)
# 
fungicide_1 <- mutate(fungicide, Yield_kg_per_ha = Yield_bu_per_acre*62.77)
# 
# > Note: We did not have to use fungicide$Yield_bu_per_acre. 
# 
# Let's print the data to see what we have
fungicide_1
# 
# We have a new column `Yield_kg_per_ha`. We have two columns with yield and one 
# with severity. We don't want severity data and want yield data only in kg/ha.
# 
# b) Create a new data frame with only `Treatment` and `Yield_kg_per_ha` columns
# We can use the function `select()` that picks variables based on their names.
# 
fungicide_2 <- select(fungicide_1, Treatment, Yield_kg_per_ha)
fungicide_2
# 
# c) Find the mean yield
# If we want to summarise multiple values to a single value, for example, mean, 
# we can use the function `summarize()`.
# 
summarize(fungicide_2, Mean_yield = mean(Yield_kg_per_ha))
# 
# Wait, we just got one mean even though we had three different groups (Control,
# Fungicide_A, Fungicide_B). We need to find the mean for every group. How can 
# we tell R that it needs to group the data according to the treatment?
# 
# d) Group data according to treatment
# We can use the function `group_by()` for this purpose. 
# 
fungicide_3 <- group_by(fungicide_2, Treatment)
fungicide_3 
# 
# You will notice that `fungicide_2` and `fungicide_3` are a little different.
# `fungicide_3` is also a "tibble", which is a form of data frame that gives 
# more information about our data (e.g. what kind of data the columns are). You
# will notice that Treatment is a factor, while Yield_kg_per_ha is a double 
# (decimal). It also tells us that our data is grouped by Treatment (therefore, 
# it has three groups). To add the grouping information to this data frame, 
# 'dplyr' uses a sister package to convert it into a tibble. Also, note that 
# `Yield_kg_per_ha` is not printing the whole answer (after decimals) and 
# has underlined first two digits. The tibble format is different when we print
# it, but the same when we use `View()`. The digits are underlined so that it
# is easier to read larger numbers. It's role is similar to a comma. So,
# '10,000' will have '10' underlined and '100,000' will have '100' underlined.
# 
# e) Find the mean yield of every group
fungicide_4 <- summarize(fungicide_3, Mean_yield = mean(Yield_kg_per_ha))
fungicide_4
# 
# Instead of creating different objects everytime, we can perform multiple functions
# at once and create one final object. We use the pipe operator, %>% , for this purpose.
# The left hand side of %>% acts as the input on which an operation on the right side
# is performed. A shortcut to write %>% is `ctrl+shift+m`.
# 
yield_summary <- fungicide %>% 
  mutate(Yield_kg_per_ha = Yield_bu_per_acre*62.77) %>%  
  select(Treatment, Yield_kg_per_ha) %>% 
  group_by(Treatment) %>% 
  summarise(Mean_yield = mean(Yield_kg_per_ha))
# 
yield_summary
# 
View(yield_summary)
# 
# We answered our first question!
# 
# You will notice that on the console below, the code for creating `yield_summary` has 
# `+` signs before every line. The plus signs just indicate that R is waiting for the 
# code to be finished. This sign also appears when we forget to put a closing
# paranthesis ')'. Try this:
# 
str(yield_summary

)
# 
# Let's go to our second question.
# 
# 2. What is the percent severity of Control and Fungicide A? 
# 
# First, we need to create a new data frame where we only have severity data for Control
# and Fungicide A. If we want to filter a data frame based upon specific values of a 
# variable, we can use the function `filter()`.
# 
filter(fungicide, Treatment == "Control" | Treatment == "Fungicide_A")
# 
# The treatment column should either be equal (`==`) to Control OR (`|`) Fungicide_A.
# We can also write the same expression as:
# 
filter(fungicide, Treatment != "Fungicide_B")
# 
# The treatment column should not be equal to (`!=`) to Fungicide_B. So, it will have 
# everything except Fungicide B ("Control" and "Fungicide_A").
# 
# After filtering, we need to add a column `Percent_Severity`, where severity is measured
# in percent and not on a scale of 1 to 10. Any guess on which function should we use?
# Let's perform all operations in one go.
# 
severity_dat <- fungicide %>% 
  filter(Treatment == "Control" | Treatment == "Fungicide_A") %>% 
  mutate(Percent_Severity = Severity/10*100) %>% 
  select(Treatment, Percent_Severity)
# 
severity_dat
# 
# If we wanted to use these data as a table in a paper, we should export it to a
# csv file. We can do this using the function `write.table()`. Before that, let's
# create a new directory (or folder) named results. We can do this using the
# function `dir.create()`.
# 
dir.create("results")
write.table(severity_dat, file = "results/severity_dat.csv", sep = ",", 
            col.names = TRUE, 
            row.names = FALSE)
# 
# 3. Which fungicide shows better results? (ANOVA)
# 
# Step 4: Statistical Analysis
# ----------------------------
# 
# Let's do ANOVA for yield and severity data. We can use alpha level = 0.05. If we 
# do an internet search for ANOVA in R, you will find that function `aov` is 
# appropriate for this. How do we use `aov`?
# 
?aov
# 
# This function takes in a formula to be tested. To find if the independent variable
# (`Treatment`) had an effect on the dependent variable (`Yield_bu_per_acre`), the
# formula should be written as 'dependent_variable ~ independent_variable'. If we 
# used blocks in our experimental design, the formula can be modified to
# 'dependent_variable ~ independent_variable + block'. The function also takes in a 
# data frame in which these variables are present. 
# 
# Let's use this function.
aov(formula=Yield_bu_per_acre ~ Treatment, data=fungicide) 
# 
# As mentioned in the 'Description', `aov` fits an ANOVA model to an experimental design.
# Let's check the 'Value' section of the help page so we know what does it return. It
# returns an object, which can further be explored with `print()` and `summary()`. Let's
# assign it to an object so that we can use `print()` and `summary()` on it.
# 
fit_yield <- aov(formula=Yield_bu_per_acre ~ Treatment, data=fungicide) 
# 
print(fit_yield) 
# 
summary(fit_yield) # This is what we want!
# 
# The output is similar to an ANOVA table. 'Pr(>F)' is the associated p-value. As the 
# p-value is less than 0.05, the null hypothesis is rejected. So, at least one of the
# treatments is different. Now that we know that differences exist between our 
# treatments, how can we find which treatments are different? We can do this by using 
# Tukey's post-hoc test. If you scroll down the help page of `aov` and go the section
# 'See Also', you will see a function `TukeyHSD`. This is what we need.
# 
TukeyHSD(fit_yield) 
# 
# There is no difference between 'Fungicide_A' and 'Control' as the p-value is 0.978 (>0.05).
# 
# Let's do similar analysis using the Severity data
# 
fit_severity <- aov(formula=Severity ~ Treatment, data=fungicide)
summary(fit_severity) # p-value is less than 0.05, so let's do Tukey's post-hoc test
# 
TukeyHSD(fit_severity) 
# 
# All the treatment pairs are significantly different from each other as the p-value is < 0.05.
