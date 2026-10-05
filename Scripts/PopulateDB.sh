#! bin/bash
# Author: Edward B. Hawthorn

# Get Mysql Credentials to avoid constant entry during execution

read -p "Enter MySQL Username:" -s USERNAME
echo ""
read -p  "Enter MySQL Password: " -s PASSWORD
echo ""

# -------------------------------------------------------------------------------------------

# The below code will populate the database with the provided data files for the assessment.
#
# File 1:
#        /assessments/hpdm206Z/assessment1/doctors.csv
# File 2:
#        /assessments/hpdm206Z/assessment1/patients.csv
# File 3:
#        /assessments/hpdm206Z/assessment1/hospitals.csv
# File 4:
#        /assessments/hpdm206Z/assessment1/prescriptions.csv
#
# 2>/dev/null Suppresses the Warning for Password being parsed on the command line
# An alternative implementation would be to use a .cnf config file to maintain security and encryption.

# Check Database exists
dbSearch=$(mysql -u$USERNAME -p$PASSWORD -BNe "SHOW DATABASES;" 2>/dev/null | grep HospitalNetworkDB)

if [[ "$dbSearch" == "HospitalNetworkDB" ]]; then
  #Check Tables exist
  tableSearch=$(mysql -u$USERNAME -p$PASSWORD HospitalNetworkDB -BNe "SELECT COUNT(1) FROM information_schema.tables WHERE table_schema = 'HospitalNetworkDB' AND table_name IN ('people','hospitals','prescriptions');" 2>/dev/null)
  if [[ $tableSearch == 3 ]];  then
    # Check Tables empty.
    peopleEmpty=$(mysql -u$USERNAME -p$PASSWORD HospitalNetworkDB -BNe "SELECT COUNT(*) FROM people;" 2>/dev/null)
    hospitalsEmpty=$(mysql -u$USERNAME -p$PASSWORD HospitalNetworkDB -BNe "SELECT COUNT(*) FROM hospitals;" 2>/dev/null)
    prescriptionsEmpty=$(mysql -u$USERNAME -p$PASSWORD HospitalNetworkDB -BNe "SELECT COUNT(*) FROM prescriptions;" 2>/dev/null)

    if [[ $peopleEmpty == 0 && $hospitalsEmpty == 0 && $prescriptionsEmpty == 0 ]]; then
      # Execute Table loads
      # SET FOREIGN_KEY_CHECKS = 0 is used to temporarily disable the foriegn keys while the data is loaded. As some fields in the CSVs use commas such as address we need to use the Encapsulated by
      # function to get the full data string. as we are executing this in BASH we need the backwards slash before the quote to allow it to process
      # -B makes any returns borderless  -N suppresses column headers

      # People Table - Doctors

      mysql --local-infile=1 -u$USERNAME -p$PASSWORD HospitalNetworkDB -e "SET FOREIGN_KEY_CHECKS = 0; LOAD DATA LOCAL INFILE '~/assessments/hpdm206Z/assessment1/doctors.csv' INTO TABLE people FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES (person_id, name, date_of_birth, address, role, hospital_id);" 2>/dev/null
      echo "Doctor rows inserted: "
      mysql -u$USERNAME -p$PASSWORD HospitalNetworkDB -BNe "SELECT COUNT(1) FROM people WHERE role = 'Doctor';" 2>/dev/null

      # People Table - Patients

      mysql --local-infile=1 -u$USERNAME -p$PASSWORD HospitalNetworkDB -BNe "SET FOREIGN_KEY_CHECKS = 0; LOAD DATA LOCAL INFILE '~/assessments/hpdm206Z/assessment1/patients.csv' INTO TABLE people FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES (person_id, name, date_of_birth, address, role, doctor_id);" 2>/dev/null
      echo "Patient rows inserted: "
      mysql -u$USERNAME -p$PASSWORD HospitalNetworkDB -BNe "SELECT COUNT(1) FROM people WHERE role = 'Patient';" 2>/dev/null

      # Hospitals Table - Hospitals

      mysql --local-infile=1 -u$USERNAME -p$PASSWORD HospitalNetworkDB -BNe "SET FOREIGN_KEY_CHECKS = 0; LOAD DATA LOCAL INFILE '~/assessments/hpdm206Z/assessment1/hospitals.csv' INTO TABLE hospitals FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES (hospital_id, hospital_name, address, bed_count, type, accreditation_status);" 2>/dev/null
      echo "Hospital rows inserted: "
      mysql -u$USERNAME -p$PASSWORD HospitalNetworkDB -BNe "SELECT COUNT(1) FROM hospitals;" 2>/dev/null

      # Prescriptions Table - Prescriptions

      mysql --local-infile=1 -u$USERNAME -p$PASSWORD HospitalNetworkDB -BNe "SET FOREIGN_KEY_CHECKS = 0; LOAD DATA LOCAL INFILE '~/assessments/hpdm206Z/assessment1/prescriptions.csv' INTO TABLE prescriptions FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 LINES (prescription_id, patient_id, doctor_id, medication, prescription_date);" 2>/dev/null
      echo "Prescription rows inserted: "
      mysql -u$USERNAME -p$PASSWORD HospitalNetworkDB -BNe "SELECT COUNT(1) FROM prescriptions;" 2>/dev/null


    else

      # Tables not empty.

      echo "Tables are not empty. Possible duplicated run of this script detected."
    fi
  else

    # Tables not found.

    echo "Tables do not exist. Please rerun InitialiseDB.sh first."
  fi
else

  # Database not found.

  echo "Database does not exist. Please run InitialiseDB.sh first."
fi


