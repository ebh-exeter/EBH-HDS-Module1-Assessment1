#! bin/bash
# Author: Edward B. Hawthorn

# Get Mysql Credentials to avoid constant entry during execution

read -p "Enter MySQL Username:" -s USERNAME
echo ""
read -p  "Enter MySQL Password: " -s PASSWORD
echo ""

# -------------------------------------------------------------------------------------------

# This script will ask for Hospital ID and then return the Doctors for that Hospital
#
# 2>/dev/null Suppresses the Warning for Password being parsed on the command line
# An alternative implementation would be to use a .cnf config file to maintain security and encryption.

# valid hospital selected loop

while :; do

  mapfile -t min_max < <(echo "SELECT MIN(hospital_id) AS lower_range, MAX(hospital_id) AS upper_range FROM hospitals;" | mysql -u$USERNAME -p$PASSWORD -BN --vertical HospitalNetworkDB 2>/dev/null)

  echo "Please enter the id of the Patient:"
  echo "Range between "${min_max[1]}" and "${min_max[2]}
  #get input

  read entered_id

  gethospital="SELECT hospital_name FROM hospitals WHERE hospital_id = "${entered_id}";"
  mapfile -t hospitalName < <(echo $gethospital | mysql  -u$USERNAME -p$PASSWORD -BN HospitalNetworkDB  2>/dev/null)
  checkdoctors="SELECT COUNT(*) FROM people WHERE hospital_id = "${entered_id}
  mapfile -t doctorCount < <(echo $checkdoctors | mysql -u$USERNAME -p$PASSWORD -BN HospitalNetworkDB 2>/dev/null)

# Checks ID was valid and pulled back a hosptual.
  if [[ $hospitalName == "" ]];then
    # Invalid Entry retake entry

    echo "Invalid entry"
  else
   if [[ $doctorCount == "0" ]];then
    echo "No Doctors at this Hospital"
   else
    # Valid Entry
     echo "Doctors at "$hospitalName
     echo "SELECT name AS Doctors_Name, address AS Doctors_Address,date_of_birth AS Doctors_DOB_date FROM people WHERE hospital_id = "${entered_id}"  AND UPPER(role) = 'DOCTOR' ORDER BY name"  | mysql -u$USERNAME -p$PASSWORD -t HospitalNetworkDB 2>/dev/null
   fi
  break
  fi
done
