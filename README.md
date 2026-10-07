# EBH-HDS-Module1-Assessment1
Repository for Module 1 (hpdm206z) Assessment 1 Submission

Author: Edward B. Hawthorn

# Introduction

This Repository will store the collective Entity Relationship Diagrams, SQL Database, Queries and associated artifacts for the assessment submission.

The implementation of the queries in Bash Scripts including the Database creation and population is aimed at this be easily recreatable and reusable.

# Contents

- README.md | This file.
- DBML_Entity_Relationship_Diagram.txt | This File contains the DBML Markup for https://dbdiagram.io/ to recreate my ERD
- /Assets 
    - HPDM206Z-ERD1.png | PNG Image file exported from https://dbdiagram.io/ showing the ERD for the assignment as created by the DBML mark up provided
    - /Flow_Diagrams
        - Flow_Diagrams.txt | Descriptor file for folder and contents.
        - Compiled Flow Diagrams.pdf | Flow Diagrams for the 8 scripts PDF File
        - Compiled Flow Diagrams.vsdx | Flow Diagrams for the 8 scripts Visio File
- /Scripts
    - Scripts.txt | Descriptor file for folder and contents.
    - InitialiseDB.sh | Bash Script to Create Database, Tables and Foreign Keys
    - PopulateDB.sh | Bash Script to Populate Tables with the 4 provided CSVs
    - GetHospitalDoctorsList.sh | Bash Script to get all Doctors at a particular Hospital
    - GetPatientsPrescriptionList.sh | Bash Script to get all prescriptions for a particular Patient Ordered by Date
    - GetDoctorsPrescriptionList.sh | Bash Script to get all presctiptions issued by a particular Doctor
    - AddPatientsQuery.sh | Bash Script to add Patient Records including a registered Doctor
    - GetBiggestPrescriber.sh | Bash Script to return the Doctor who has issued the most prescriptions
    - GetDoctorsAtBiggestHospital.sh | Bash Script to return the list of Doctors at the Hospital with the most beds

# Entity Relationship Diagram

The assignment requires that the Doctors and Patients be stored in a single table. As such the doctor_id and hosptial_id fields can be NULL however the other fields in the database will all be set to NOT NULL.

![ERD Diagram](https://github.com/ebh-exeter/EBH-HDS-Module1-Assessment1/blob/main/Assets/HPDM206Z-ERD1.png)

# How to

In order to run the queries, you first need to install the database and data. This process assumes you are utilising mysql in a linux OS.
To achieve this please follow the following steps, entering username and password when prompted:

1. Run the Bash script InitialiseDB.sh
2. Run the Bash script PopulateDB.sh
    - This script has error catch in case of attempting to run this a second time, to prevent insert errors.

Once the Database is created and populated you can interrogate the data using the provided Bash scripts:

1. **GetHospitalDoctorsList.sh** will ensure that valid hospital id is entered and that there are Doctors registered at the selected Hospital.
2. **GetPatientsPrescriptionsList.sh** will ensure a valid patient id is entered and that there are prescriptions assigned to that patient.
3. **GetDoctorsPrescriptionsList.sh** will ensure a valid doctor id is entered and that there are prescriptions issued by that doctor.
4. **AddPatientsQuery.sh** has been designed to loop for entering any number of patients until the user selects to not load any more.
5. **GetBiggestPrescriber.sh** will output the doctor with the most prescriptions and say how many that is.
6. **GetDoctorsAtBiggestHospital.sh** will output the Hospital name and bed count for the hospital with the most beds, followed by a list of doctors at that hospital.

These have all been created to ask for username and password to be passed into the queries to avoid repetitive password entry each time the database is accessed. 
They also contain error catching to ensure when entering Data that valid inputs are taken and the system will loop until valid entry. 
To limit the output for selection the user inputs an ID from a given range as opposed to being given a list to choose from.
