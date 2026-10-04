# EBH-HDS-Module1-Assessment1
Repository for Module 1 (hpdm206z) Assessment 1 Submission

Author: Edward B. Hawthorn

# Introduction

This Repository will store the collective Entity Relationship Diagrams, SQL Database, Queries and associated artifacts for the assessment submission.

# Contents

- README.md | This file.
- DBML_Entity_Relationship_Diagram.txt | This File contains the DBML Markup for https://dbdiagram.io/ to recreate my ERD
- /Assets 
    - HPDM206Z-ERD1.png | PNG Image file exported from https://dbdiagram.io/ showing the ERD for the assignment as created by the DBML mark up provided
    - /Flow_Diagrams
        -Flow_Diagrams.txt | Descriptor file for folder and contents.
- /Scripts
    - Scripts.txt | Descriptor file for folder and contents.

# Entity Relationship Diagram

The assignment requires that the Doctors and Patients be stored in a single table. To achieve this I have named the final datapoint registered_id. This will represent the hospital the doctor is registered with and the doctor the patient is registered with. Views will be utilised to separate this data for clean SQL Queries.
![ERD Diagram](https://github.com/ebh-exeter/EBH-HDS-Module1-Assessment1/blob/main/Assets/HPDM206Z-ERD1.png)
