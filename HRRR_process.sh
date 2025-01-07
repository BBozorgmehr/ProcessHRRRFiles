declare -i start_day=1 	        # Start day of data
declare -i start_month=9 	# Start month of data
declare -i start_year=2020	# Start year of data
declare -i end_day=29		# End day of data
declare -i end_month=9		# End month of data
declare -i end_year=2020	# End year of data
declare -i start_hour=16	        # Start hour of data
declare -i end_hour=18		# End hour of data

declare -i num_Jan=31            # Number of days in January
declare -i num_Feb=28            # Number of days in February (regular year)
declare -i num_March=31          # Number of days in March
declare -i num_Apr=30            # Number of days in April
declare -i num_May=31            # Number of days in May
declare -i num_Jun=30            # Number of days in June
declare -i num_Jul=31            # Number of days in July
declare -i num_Aug=31            # Number of days in August
declare -i num_Sep=30            # Number of days in September
declare -i num_Oct=31            # Number of days in October
declare -i num_Nov=30            # Number of days in November
declare -i num_Dec=31            # Number of days in December

declare -i y=$start_year
declare -i m=$start_month
declare -i d=$start_day

declare -i start_hour_day=$start_hour
declare -i end_hour_day=$end_hour

module load wgrib2
module load cdo

rm *.nc

while [ $d -le $end_day ] || [ $m -le $end_month ] || [ $y -le $end_year ]
do
    if [ $m -lt  10 ]
    then
	m_new=0$m
    else
	m_new=$m
    fi
    if [ $d -eq $start_day ] && [ $m -eq  $start_month ] && [ $y -eq  $start_year ]
    then
        start_hour_day=$start_hour
    else
	start_hour_day=0
    fi
    if [ $d -eq $end_day ] && [ $m -eq $end_month ] && [ $y -eq $end_year ]
    then
        end_hour_day=$end_hour
    else
	end_hour_day=23
    fi

    if [ $d -lt  10 ]
    then
	d_new=0$d
    else
	d_new=$d
    fi

    rm ${y}${m_new}${d_new}/*.nc
    for (( j=$start_hour_day; j<=$end_hour_day; j+=1 )) # Hour of day loop
    do
	if [ $j -lt  10 ]
	then
	    h=0$j
	else
	    h=$j
       	fi
	gpath=${y}${m_new}${d_new}/hrrr.t${h}z.wrfsfcf00.grib2
	echo "Processing file: $gpath "
       	wgrib2 $gpath -match ":(UGRD|VGRD|MASSDEN|SFCR|DSWRF|TCDC|HPBL|UGRD|VGRD|UGRD|VGRD|UGRD|VGRD|TMP|TMP|TMP|POT|TMP|UGRD|VGRD|FRICV|SHTFL|LHTFL):(10 m above ground|10 m above ground|8 m above ground|surface|surface|entire atmosphere|surface|700 mb|700 mb|850 mb|850 mb|925 mb|925 mb|925 mb|surface|2 m above ground|2 m above ground|1000 mb|1000 mb|1000 mb|surface|surface|surface):" -netcdf ${y}${m_new}${d_new}/hrrr.t${h}z.wrfsfcf00.nc
    done

    cdo mergetime ${y}${m_new}${d_new}/*.nc ${y}${m_new}${d_new}.nc

    rm ${y}${m_new}${d_new}/*.nc

    if [ $d -eq $end_day ] && [ $m -eq $end_month ] && [ $y -eq $end_year ]
    then
	break
    fi

    d=$((d+1))          # Move to the next day

    if [ $m -eq 1 ] && [ $d -gt $num_Jan ]        # Checking if we are at the end of January
    then
       	m=$((m+1))             # Move to February
       	d=$((d-$num_Jan))      # Reset days of month
    fi

    if [ $m -eq 2 ] && [ $d -gt $num_Feb ]        # Checking if we are at the end of February
    then
	m=$((m+1))             # Move to March
       	d=$((d-$num_Feb))      # Reset days of month
    fi

    if [ $m -eq 3 ] && [ $d -gt $num_Mar ]        # Checking if we are at the end of March
    then
	m=$((m+1))             # Move to April
	d=$((d-$num_Mar))      # Reset days of month
    fi

    if [ $m -eq 4 ] && [ $d -gt $num_Apr ]        # Checking if we are at the end of April
    then
	m=$((m+1))             # Move to May
       	d=$((d-$num_Apr))      # Reset days of month
    fi

    if [ $m -eq 5 ] && [ $d -gt $num_May ]        # Checking if we are at the end of May
    then
	m=$((m+1))             # Move to June
	d=$((d-$num_May))      # Reset days of month
    fi

    if [ $m -eq 6 ] && [ $d -gt $num_Jun ]        # Checking if we are at the end of June
    then
       	m=$((m+1))             # Move to July
       	d=$((d-$num_Jun))      # Reset days of month
    fi

    if [ $m -eq 7 ] && [ $d -gt $num_Jul ]        # Checking if we are at the end of July
    then
	m=$((m+1))             # Move to August
       	d=$((d-$num_Jul))      # Reset days of month
    fi

    if [ $m -eq 8 ] && [ $d -gt $num_Aug ]        # Checking if we are at the end of August
    then
	m=$((m+1))             # Move to September
	d=$((d-$num_Aug))      # Reset days of month
    fi

    if [ $m -eq 9 ] && [ $d -gt $num_Sep ]        # Checking if we are at the end of September
    then
	m=$((m+1))             # Move to October
	d=$((d-$num_Sep))      # Reset days of month
    fi

    if [ $m -eq 10 ] && [ $d -gt $num_Oct ]        # Checking if we are at the end of October
    then
	m=$((m+1))             # Move to November
	d=$((d-$num_Oct))      # Reset days of month
    fi

    if [ $m -eq 11 ] && [ $d -gt $num_Nov ]        # Checking if we are at the end of November
    then
	m=$((m+1))             # Move to December
	d=$((d-$num_Nov))      # Reset days of month
    fi

    if [ $m -eq 12 ] && [ $d -gt $num_Dec ]        # Checking if we are at the end of December
    then
	y=$((y+1))             # Move to next year
       	m=1                # Move to January
	d=$((d-$num_Dec))      # Reset days of month
    fi

    
    
    
done

	    
