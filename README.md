# ProcessHRRRFiles
In this repository, you will find a well-organized procedure to retrieve publickly available Numerical Weather Prediction (NWP) model called High-Resolution Rapid Refresh (HRRR--https://rapidrefresh.noaa.gov/hrrr) and process the wgrib2 files to create NetCDF files for inputing to other models. This procedure is developed for downscaling HRRR hourly analysis files to QES-Winds (https://github.com/UtahEFD/QES-Public).

# Instructions
In this section, step by step instructions is provided on how to retrieve and process HRRR files.

# 1. Herbie
First step is to retrieve HRRR files using Herbie (installation and instructions are available through: https://github.com/blaylockbk/Herbie). FastHerbie (documentation here: https://herbie.readthedocs.io/en/stable/user_guide/tutorial/fast.html) is the simplest way to retrieve HRRR files over a range of time using the following lines of code.

Example from FastHerbie documentation:
```
from herbie import FastHerbie
import pandas as pd
```
```
# Create a range of dates
DATES = pd.date_range(
    start="2022-03-01 00:00",
    periods=3,
    freq="1H",
)

# Create a range of forecast lead times
fxx = range(0, 3)
```
```
# Make FastHerbie Object.
FH = FastHerbie(DATES, model="hrrr", fxx=fxx)
FH
```
```
# Download full file
FH.download()
```

# 2. Install wgrib2 and CDO
Next step is to install wgrib2 (https://github.com/NOAA-EMC/wgrib2) and Climate Data Operators (CDO--https://code.mpimet.mpg.de/projects/cdo) modules on the local system to process HRRR files, create and merge NetCDF files. For users of Center for High-Performance Computing (CHPC) at the University of Utah, the script will load these modules. 

# 3. Modify Script
- Download the sript in this repository called "HRRR_process.sh" and put it in the folder where all the HRRR folders for each day are retrieved using FastHerbie. 
- Determine the start date and time in the script using "start_day", "start_month", "start_year", and "start_hour" to mark the starting time of processing in UTC.
- Determine the end date and time in the script using "end_day", "end_month", "end_year", and "end_hour" to mark the end time of processing in UTC.
- If not running the script on CHPC of University of Utah, comment off these two lines:
  ```
  module load wgrib2
  module load cdo
  ```
- Determine which variables you want to include in your NetCDF files. HRRR surface files have about 200 variables and including all of them in NetCDF files make them very big and heavy. To include variables, add the parameter short name and vertical level (from https://mesowest.utah.edu/html/hrrr/zarr_documentation/html/zarr_variables.html) to the first and second paramthesis of the following line in the script, respectively. Parameter short names and vertical levels are separated by "|" in each paranthesis.
```
wgrib2 $gpath -match ":(UGRD|VGRD|MASSDEN|SFCR|DSWRF|TCDC|HPBL|UGRD|VGRD|UGRD|VGRD|UGRD|VGRD|TMP|TMP|TMP|POT|TMP|UGRD|VGRD|FRICV|SHTFL|LHTFL):(10 m above ground|10 m above ground|8 m above ground|surface|surface|entire atmosphere|surface|700 mb|700 mb|850 mb|850 mb|925 mb|925 mb|925 mb|surface|2 m above ground|2 m above ground|1000 mb|1000 mb|1000 mb|surface|surface|surface):" -netcdf ${y}${m_new}${d_new}/hrrr.t${h}z.wrfsfcf00.nc
``` 

# 4. Run script
Open a terminal and navigate to the HRRR folder. Create an executable of the script:
```
chmod +x HRRR_process.sh 
```
Run the executable:
```
./HRRR_process.sh
```
After the script run finishes, it will create a NetCDF file for each day in the format of "yyyymmdd.nc". Use the following line of code to merge all the created NetCDF files for each day to a single NetCDF file ready to be read into other plattforms:
```
cdo mergetime *.nc output.nc
```
