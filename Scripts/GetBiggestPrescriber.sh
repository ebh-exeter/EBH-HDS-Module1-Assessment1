#! bin/bash
# Author: Edward B. Hawthorn

# Get Mysql Credentials to avoid constant entry during execution

read -p "Enter MySQL Username:" -s USERNAME
echo ""
read -p  "Enter MySQL Password: " -s PASSWORD
echo ""

# -------------------------------------------------------------------------------------------

# This script will pull the doctor ID who has the most prescriptions
#
# 2>/dev/null Suppresses the Warning for Password being parsed on the command line
# An alternative implementation would be to use a .cnf config file to maintain security and encryption.

getdoctor="SELECT people.name, sub.numprescriptions FROM ( SELECT COUNT(*) numprescriptions, doctor_id FROM prescriptions GROUP BY doctor_id ORDER by numprescriptions DESC) sub LEFT JOIN people ON (people.person_id = sub.doctor_id) WHERE people.role = 'Doctor' GROUP BY people.name,  sub.numprescriptions  LIMIT 1;"
mapfile -t doctorDetails < <(echo $getdoctor | mysql  -u$USERNAME -p$PASSWORD -BN HospitalNetworkDB --vertical 2>/dev/null)

echo "The biggest prescriber is "${doctorDetails[1]}" with "${doctorDetails[2]}" prescriptions."

