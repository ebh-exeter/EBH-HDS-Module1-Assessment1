#! bin/bash
# Author: Edward B. Hawthorn

# Get Mysql Credentials to avoid constant entry during execution

read -p "Enter MySQL Username:" -s USERNAME
echo ""
read -p  "Enter MySQL Password: " -s PASSWORD
echo ""

# -------------------------------------------------------------------------------------------

# This script will ask for doctor ID and then return the prescriptions from that Doctor
#
# 2>/dev/null Suppresses the Warning for Password being parsed on the command line
# An alternative implementation would be to use a .cnf config file to maintain security and encryption.

# valid doctor selected loop

while :; do

  mapfile -t min_max < <(echo "SELECT MIN(person_id) AS lower_range, MAX(person_id) AS upper_range FROM people WHERE UPPER(role) = 'DOCTOR';" | mysql -u$USERNAME -p$PASSWORD -BN --vertical HospitalNetworkDB 2>/dev/null)

  echo "Please enter the id of the Registered Doctor:"
  echo "Range between "${min_max[1]}" and "${min_max[2]}
  #get input

  read entered_id

  getdoctor="SELECT name FROM people WHERE person_id = "${entered_id}" AND UPPER(role) = 'DOCTOR';"
  mapfile -t doctorName < <(echo $getdoctor | mysql  -u$USERNAME -p$PASSWORD -BN HospitalNetworkDB  2>/dev/null)
  checkprescriptions="SELECT COUNT(*) FROM prescriptions WHERE doctor_id = "${entered_id}
  mapfile -t scriptCount < <(echo $checkprescriptions | mysql -u$USERNAME -p$PASSWORD -BN HospitalNetworkDB 2>/dev/null)

# Checks ID was valid and pulled back a doctor and that that doctor has prescriptions to show.
  if [[ $doctorName == "" || $scriptCount == "0" ]];then
    # Invalid Entry retake entry

    echo "Invalid entry"
  else
    # Valid Entry
     echo "Prescriptions for "$doctorName
     echo "SELECT patients.name Patient_Name, patients.address Patient_Address, prescriptions.medication Prescribed_Drug, prescriptions.prescription_date Prescription_Date FROM prescriptions LEFT JOIN people AS patients ON (prescriptions.patient_id = patients.person_id) WHERE prescriptions.doctor_id = "${entered_id}" AND UPPER(patients.role) =  'PATIENT' ORDER BY prescriptions.prescription_date" | mysql -u$USERNAME -p$PASSWORD -t HospitalNetworkDB 2>/dev/null

  break
  fi
done
