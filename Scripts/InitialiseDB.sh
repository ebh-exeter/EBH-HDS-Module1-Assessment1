#! bin/bash
# Author: Edward B. Hawthorn

# Get Mysql Credentials to avoid constant entry during execution

read -p "Enter MySQL Username:" -s USERNAME
echo ""
read -p  "Enter MySQL Password: " -s PASSWORD
echo ""


# --------------------------------------------------------------------------------------------
# The below code will create the database instance in MYSQL
# 2>/dev/null Suppresses the Warning for Password being parsed on the command line
# An alternative implementation would be to use a .cnf config file to maintain security and encryption.

mysql -u$USERNAME -p$PASSWORD -e "CREATE DATABASE HospitalNetworkDB;" 2>/dev/null
echo "Database created"

# -------------------------------------------------------------------------------------------
# Create hospitals Table

mysql -u$USERNAME -p$PASSWORD HospitalNetworkDB -e "CREATE TABLE hospitals (hospital_id INT NOT NULL, hospital_name VARCHAR(100) NOT NULL, address VARCHAR(200) NOT NULL, bed_count INT NOT NULL, type VARCHAR(50) NOT NULL, accreditation_status VARCHAR(100) NOT NULL, PRIMARY KEY (hospital_id));" 2>/dev/null
echo "Schema updated - hopsital table added."
mysql -u$USERNAME -p$PASSWORD HospitalNetworkDB -e "DESCRIBE hospitals;" 2>/dev/null

# -------------------------------------------------------------------------------------------
# Create people Table

mysql -u$USERNAME -p$PASSWORD HospitalNetworkDB -e "CREATE TABLE people (person_id INT NOT NULL, name VARCHAR(100) NOT NULL, date_of_birth DATE NOT NULL, address VARCHAR(200) NOT NULL, role VARCHAR(20) NOT NULL, doctor_id INT, hospital_id INT, PRIMARY KEY (person_id));" 2>/dev/null

echo "Schema updated - people table added."
mysql -u$USERNAME -p$PASSWORD HospitalNetworkDB -e "DESCRIBE people;" 2>/dev/null

# -------------------------------------------------------------------------------------------
# Create prescriptions Table

mysql -u$USERNAME -p$PASSWORD HospitalNetworkDB -e "CREATE TABLE prescriptions (prescription_id INT NOT NULL, patient_id INT NOT NULL, doctor_id INT NOT NULL, medication VARCHAR(200) NOT NULL, prescription_date DATE NOT NULL, PRIMARY KEY (prescription_id));" 2>/dev/null

echo "Schema updated - prescriptions table added."
mysql -u$USERNAME -p$PASSWORD HospitalNetworkDB -e "DESCRIBE prescriptions;" 2>/dev/null


# -------------------------------------------------------------------------------------------
# Create Foreign Keys

# people.registered_id reference people.person_id This is for Patients registered Doctor

mysql -u$USERNAME  -p$PASSWORD  HospitalNetworkDB -e "ALTER TABLE people ADD CONSTRAINT fk_doctor FOREIGN KEY (doctor_id) REFERENCES people (person_id);" 2>/dev/null

# people.registered_id reference hospitals.hospital_id THis is for Doctors registered Hospital

mysql -u$USERNAME  -p$PASSWORD  HospitalNetworkDB -e "ALTER TABLE people ADD CONSTRAINT fk_hospital FOREIGN KEY (hospital_id) REFERENCES hospitals (hospital_id);" 2>/dev/null

# prescription.patient_id references people.person_id This is the patient hook

mysql -u$USERNAME  -p$PASSWORD  HospitalNetworkDB -e "ALTER TABLE prescriptions ADD CONSTRAINT fk_patient FOREIGN KEY (patient_id) REFERENCES people (person_id);" 2>/dev/null

# prescription.doctor_id references people.person_id This is the doctor hook

mysql -u$USERNAME  -p$PASSWORD  HospitalNetworkDB -e "ALTER TABLE prescriptions ADD CONSTRAINT fk_prescriber FOREIGN KEY (doctor_id) REFERENCES people (person_id);" 2>/dev/null

# Confirm Foreign Keys set

mysql -u$USERNAME -p$PASSWORD HospitalNetworkDB -e "SELECT * FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = 'HospitalNetworkDB' AND REFERENCED_TABLE_NAME IS NOT NULL;" 2>/dev/null

