#!/usr/bin/env python

# Use pandas for data handling
import pandas as pd

# Some calculation
data=1+1

# Convert int to data frame
df=pd.DataFrame({data})

# Save data frame to csv
data.to_csv('myPyresults.csv')
