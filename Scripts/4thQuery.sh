#! bin/bash
# Author: Edward B. Hawthorn

# Get Mysql Credentials to avoid constant entry during execution

read -p "Enter MySQL Username:" -s USERNAME
echo ""
read -p  "Enter MySQL Password: " -s PASSWORD
echo ""

# -------------------------------------------------------------------------------------------

# This script will ask for details to add patients.
#
# 2>/dev/null Suppresses the Warning for Password being parsed on the command line
# An alternative implementation would be to use a .cnf config file to maintain security and encryption.

# Get List of Doctors - Reuse this in 3

mapfile -t start_count < <(echo "SELECT COUNT(1) AS count FROM people;" | mysql -u$USERNAME -p$PASSWORD -BN HospitalNetworkDB 2>/dev/null)


# Add another patient loop

while :; do

# valid doctor selected loop

while :; do

  mapfile -t min_max < <(echo "SELECT MIN(person_id) AS lower_range, MAX(person_id) AS upper_range FROM people WHERE UPPER(role) = 'DOCTOR';" | mysql -u$USERNAME -p$PASSWORD -BN --vertical HospitalNetworkDB 2>/dev/null)

  echo "Please enter the id of the Registered Doctor:"
  echo "Range between "${min_max[1]}" and "${min_max[2]}
  #get input

  read entered_id

  getdoctor="SELECT name FROM people WHERE person_id = "${entered_id}" AND UPPER(role) = 'DOCTOR';"
  mapfile -t doctorName < <(echo $getdoctor | mysql  -u$USERNAME -p$PASSWORD -BN HospitalNetworkDB  2>/dev/null)

  if [[ $doctorName == "" ]];then
    # Invalid Entry retake entry

    echo "Invalid entry"
  else
    # Valid Entry
    echo "You selected:"
    echo $doctorName

    read -p "Please Enter Patient Name:" patientName

    while :; do
    #Get Patient Date in loop for error check

    read -p "Please Enter Patient Date of Birth: YYYY-MM-DD Format" patientDOBinput
    patientDOB=$(date -d "$patientDOBinput" '+%Y-%m-%d' 2>/dev/null)

     if [[ $patientDOB == $patientDOBinput ]]; then
        # valid date

	read -p "Please Enter Patient Address: " patientAddress
	mapfile  -t newid < <(echo "SELECT MAX(person_id)+1 as newid FROM people;" | mysql -u$USERNAME -p$PASSWORD -BN HospitalNetworkDB 2>/dev/null)
	insertQuery="INSERT INTO people (person_id, name, date_of_birth, address, role, doctor_id) VALUES ("$newid",'"$patientName"','"$patientDOB"','"$patientAddress"','Patient',"$entered_id");"
	echo $insertQuery | mysql -u$USERNAME -p$PASSWORD HospitalNetworkDB 2>/dev/null

	# Exit 1 layer
	break 1
      else
      # Not valid date

      echo "Date Invalid"
    fi
    done
    # exit 1 layer of  the loop
    break 1
  fi
done 
while :; do
read -p "Add another Patient? Y/N " another
if [[ ${another^^} == "N" ]];then
  # Exit outer loop
  break 2
elif [[ ${another^^} == "Y"  ]];then
  break 1
fi
done
done

# Get new total rows to count number inserted as cannot increment a variable inside a loop. Variable would be 0 once loop closed again

mapfile -t end_count < <(echo "SELECT COUNT(1) AS count FROM people;" | mysql -u$USERNAME -p$PASSWORD -BN HospitalNetworkDB 2>/dev/null)

let insert=$(( end_count - start_count ))

echo $insert" rows successfully added"
