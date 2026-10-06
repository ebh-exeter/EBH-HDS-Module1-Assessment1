#! bin/bash
# Author: Edward B. Hawthorn

# Get Mysql Credentials to avoid constant entry during execution

read -p "Enter MySQL Username:" -s USERNAME
echo ""
read -p  "Enter MySQL Password: " -s PASSWORD
echo ""

# -------------------------------------------------------------------------------------------

# This script will pull the list of Doctors at the Hospital with the most beds
#
# 2>/dev/null Suppresses the Warning for Password being parsed on the command line
# An alternative implementation would be to use a .cnf config file to maintain security and encryption.

getHospital="SELECT hospital_name, MAX(bed_count) AS size FROM hospitals GROUP BY hospital_id, hospital_name ORDER BY size DESC LIMIT 1;"

getDoctors="SELECT people.name, people.address FROM people WHERE UPPER(role) = 'DOCTOR' AND people.hospital_Id = (SELECT hospital_id FROM (SELECT hospital_id, hospital_name, MAX(bed_count) AS size FROM hospitals GROUP BY hospital_id, hospital_name ORDER BY size DESC LIMIT 1) Biggest);"

mapfile -t hospitalDetails < <(echo $getHospital | mysql  -u$USERNAME -p$PASSWORD -BN HospitalNetworkDB --vertical 2>/dev/null)

echo "The Doctors at the "${hospitalDetails[1]}" with the most beds at "${hospitalDetails[2]}" are:"
echo $getDoctors | mysql  -u$USERNAME -p$PASSWORD -t HospitalNetworkDB 2>/dev/null

