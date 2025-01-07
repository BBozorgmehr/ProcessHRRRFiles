# ProcessHRRRFiles
In this repository, you will find an well-organized procedure to retrieve publickly available Numerical Weather Prediction (NWP) model called High-Resolution Rapid Refresh (HRRR) system and process the wgrib2 files to create netCDF files for inputing to other weather prediction models. This procedure is developed for downscaling HRRR hourly analysis files to QES-Winds.

# Instructions
In this section, step by step instructions is provided on how to retrieve and process HRRR files.

# 1. Herbie
First step is to retrieve HRRR files using Herbie (installation and instructions are available through: https://github.com/blaylockbk/Herbie). FastHerbie (documentation here: https://herbie.readthedocs.io/en/stable/user_guide/tutorial/fast.html) is the simplest way to retrieve HRRR files over a range of time.

From FastHerbie documentation:
```
from herbie import FastHerbie
import pandas as pd
```
'''
# Create a range of dates
DATES = pd.date_range(
    start="2022-03-01 00:00",
    periods=3,
    freq="1H",
)

# Create a range of forecast lead times
fxx = range(0, 3)
'''
...
# Make FastHerbie Object.
FH = FastHerbie(DATES, model="hrrr", fxx=fxx)
FH
...
...
# Download full file
FH.download()
...



