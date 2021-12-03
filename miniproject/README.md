Project name / title: Mini project

    Brief description: Comparing quadratic model to logistic model in predicting microbial growth

    Languages: Python, R, Bash, LaTeX.
    
    Dependencies: Pandas, numpy, ggplot2, dplyr, minpack.lm.


    Project structure and Usage: 
    1. data_prep.py: This script reads in a large dataset of microbial population growth over time (LogisticGrowthData.csv), creates unique IDs based off of species, temperature, growing medium and citation. Problematic values (i.e., negative values for population and time) were removed.
    
    2. model.R: This script fits a polynomial quadratic model and a mechanistic logistic model on subsets of data (based on the unique IDs) in order to estimate the model's parameters. AIC and BIC are calculated to find the fit of the model parameters in comparison to the observed data. 
    
    3. analysis.R: This script determines which model is best for each subset of data based on AIC and BIC. The difference in AIC and BIC between both models is calculated. If the absolute difference is greater than 2, then the model with the smaller AIC value will be selected as the best model. This script also creates a plot which visualises the predicted growth curve of both models in comparison to the observed data points. 
    
    4. wrtieup.tex: A .tex file which produces a .pdf of the written report of my analysis
    
    5. MyFirstBiblo: references for writeup.tex
    


    Author name and contact: Kate Griffin, kate.griffin21@imperial.ac.uk
