Advanced Data Management (D326)
---

A. Business Report 

| |
| --- |
| I will be running a report on the most popular film categories by rental amount per month. This will benefit the business in knowing which films of certain categories we need to supply more of. In result, we can generate more revenue for stores by increasing and retaining more customers in our rental business |

---

A1. Specific Fields 

| |
| --- |
| The detailed report will list the rental_id, rental_month, film_title, and film_category. 
The summary report will list the film_category, rental_month, and rental_count. |  

---

A2. Types of Data 

| Detailed Report | 
| --- | 

| | | |
| --- | --- | --- |
| rental_id | INT | the unique identification number of a rental |
| rental_month | INT | the month |
| film_title | VARCHAR(255) | the title of a film | 
| film_category | VARCHAR(25) | the film category name |

| Summary Report |
| --- |

| | | |
| --- | --- | --- |
| film_category | VARCHAR(25) | the film category name |
| rental_month | INT | the month |
| rental_count | INT | the number of rentals |

---

A3. Specific Tables

| | | 
| --- | --- |
| rental table | This contains the necessary data like the rental IDs. |
| film table | This contains the necessary data like the film title. |
| category table | This contains the necessary data like the film category name. |

---

A4. Field Transformation

The field that requires a custom transformation using a user-defined function is rental_date to rental_month. This will improve readability for users. 

---

A5. Business Uses

The detailed table section will allow a stakeholder to analyze rental trends by the exact movie and its category.  The summary table will provide the stakeholder with an overview of rental behavior by movie category. Both reports can help with managing film inventory.

---

A6. Report Freshness

Since the report analyzes the rental amount for each month, it should be updated monthly to remain relevant.

---

B. Functions

Check project.sql

---

C. Creating Tables

Check project.sql

---

D. SQL Query

Check project.sql

---

E. Triggers

Check project.sql

---

F. Stored Procedures

Check project.sql

---

F1. Job Scheduling Tool

Since this job-scheduling tool supports PostgreSQL, pgAgent would be the best option for automating the stored procedure. This tool can also be managed by PgAdmin4.
