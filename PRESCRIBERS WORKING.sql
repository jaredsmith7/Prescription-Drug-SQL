SELECT *
FROM prescriber;

SELECT COUNT(DISTINCT npi)
FROM prescription;

SELECT *
from prescription;

SELECT *
FROM drug

SELECT *
FROM cbsa

SELECT *
FROM fips_county

SELECT *
FROM overdose_deaths

SELECT *
FROM population

SELECT *
FROM zip_fips


SELECT npi,SUM(total_claim_count) AS total_claims
FROM prescriber
INNER JOIN prescription
USING(npi)
GROUP BY prescriber.npi
ORDER BY total_claims DESC

----Question 1---
---a. 1881634483 with 99707 total claims---

SELECT npi, SUM(total_claim_count) AS total_claims
FROM prescription
GROUP BY prescription.npi
ORDER BY total_claims DESC

---b.----

SELECT npi,SUM(total_claim_count) AS total_claims,prescriber.nppes_provider_first_name,prescriber.nppes_provider_last_org_name,prescriber.specialty_description
FROM prescriber
INNER JOIN prescription
USING(npi)
GROUP BY prescriber.npi,prescriber.nppes_provider_first_name,prescriber.nppes_provider_last_org_name,prescriber.specialty_description
ORDER BY total_claims DESC


---Question 2---
---a.Family Practice---

SELECT specialty_description, SUM(total_claim_count) AS total_claims
FROM prescriber
INNER JOIN prescription
USING(npi)
GROUP BY prescriber.specialty_description
ORDER BY total_claims DESC

---b.---
---Nurse Practitioner---

SELECT *
FROM drug;


SELECT prescriber.specialty_description,SUM(total_claim_count) AS total_claims
FROM prescriber
INNER JOIN prescription
USING(npi)
INNER JOIN drug
USING(drug_name)
WHERE drug.opioid_drug_flag = 'Y'
GROUP BY prescriber.specialty_description
ORDER BY total_claims DESC;


---c.----

SELECT specialty_description, SUM(total_claim_count) AS total_claims
FROM prescriber
LEFT JOIN prescription
USING(npi)
GROUP BY prescriber.specialty_description
HAVING SUM(total_claim_count) IS NULL;


---D.---



SELECT prescriber.specialty_description,ROUND(opioid_count/SUM(total_claim_count),2) AS opioid_percentage_claims
FROM prescription AS total_count_of_claims
INNER JOIN drug
USING(drug_name)
INNER JOIN prescriber
USING(npi)
INNER JOIN (SELECT specialty_description,SUM (total_claim_count) AS opioid_count
			FROM prescription AS opiods
			INNER JOIN drug 
			USING (drug_name)
			INNER JOIN prescriber
			USING (npi)
			WHERE opioid_drug_flag= 'Y'
			GROUP BY specialty_description
			ORDER BY opioid_count DESC) AS opioids
USING (specialty_description)
GROUP BY specialty_description,opioid_count
ORDER BY opioid_percentage_claims DESC;









SELECT prescriber.specialty_description,SUM(total_claim_count) AS total_claims
FROM prescriber
INNER JOIN prescription
USING(npi)
INNER JOIN drug
USING(drug_name)
WHERE drug.opioid_drug_flag = 'Y'
GROUP BY prescriber.specialty_description
ORDER BY total_claims DESC

SELECT prescriber.specialty_description,SUM(total_claim_count) AS total_claims
FROM prescriber
INNER JOIN prescription
USING(npi)
INNER JOIN drug
USING(drug_name)
GROUP BY prescriber.specialty_description
ORDER BY total_claims DESC

---QUESTION 3---
---a. INSULIN---
SELECT *
FROM drug

SELECT *
FROM prescription

SELECT drug.generic_name, SUM(total_drug_cost) AS cost
FROM prescription
INNER JOIN drug
USING (drug_name)
GROUP BY drug.generic_name
ORDER BY cost DESC;

---b.---
---C1 Esterase Inhibitor---

SELECT drug.generic_name, ROUND((SUM(total_drug_cost)/SUM(total_day_supply)), 2) AS cost_per_day
FROM prescription
INNER JOIN drug
USING (drug_name)
GROUP BY drug.generic_name
ORDER BY cost_per_day DESC;


---Question 4---
---a.---

SELECT drug_name,
	CASE WHEN opioid_drug_flag ='Y' THEN 'opiod'
		 WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
		 ELSE 'neither' END AS drug_type
FROM drug;

---b.---

SELECT SUM(p.total_drug_cost::MONEY),
	CASE WHEN opioid_drug_flag ='Y' THEN 'opiod'
		 WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
		 ELSE 'neither' END AS drug_type
FROM drug
INNER JOIN prescription AS p
USING (drug_name)
GROUP by drug_type
ORDER by sum;


---Question 5---
---a.---

SELECT COUNT(DISTINCT cbsa)
FROM cbsa
INNER JOIN fips_county
USING (fipscounty)
WHERE state='TN';

---b.---
---Nashville,Morristown---

SELECT cbsaname,SUM(population) AS total_pop
FROM cbsa
INNER JOIN population
USING(fipscounty)
GROUP BY cbsaname
ORDER BY total_pop DESC

---c.---

SELECT *
FROM cbsa

SELECT *
FROM population

SELECT county,population
FROM fips_county
INNER JOIN population
USING(fipscounty)
LEFT JOIN cbsa 
USING (fipscounty)
WHERE cbsa IS NULL 
ORDER BY population DESC;

---Question 6---
---a.---

SELECT drug_name,total_claim_count
FROM prescription
WHERE total_claim_count >= 3000;

---b.---

SELECT drug_name,total_claim_count,opioid_drug_flag
FROM prescription
LEFT JOIN drug
USING (drug_name)
WHERE total_claim_count >= 3000

---c.---

SELECT *
FROM prescriber

SELECT drug_name,total_claim_count,opioid_drug_flag,nppes_provider_first_name || ' ' || nppes_provider_last_org_name AS full_name
FROM prescription
LEFT JOIN drug
USING (drug_name)
LEFT JOIN prescriber
USING (npi)
WHERE total_claim_count >= 3000
ORDER BY total_claim_count DESC;

---QUESTION 7---

SELECT *
FROM prescriber

SELECT *
FROM prescription

SELECT *
FROM drug


---A.---

SELECT *
FROM drug
CROSS JOIN prescriber
WHERE prescriber.nppes_provider_city = 'NASHVILLE'
AND drug.opioid_drug_flag = 'Y'
AND prescriber.specialty_description = 'Pain Management'

---B/C---

SELECT npi,drug.drug_name,COALESCE(SUM(prescription.total_claim_count),'0') AS sum_claims
FROM drug
CROSS JOIN prescriber
LEFT JOIN prescription
USING (npi,drug_name)
WHERE prescriber.nppes_provider_city = 'NASHVILLE'
AND drug.opioid_drug_flag = 'Y'
AND prescriber.specialty_description = 'Pain Management'
GROUP BY npi,drug.drug_name
ORDER BY sum_claims DESC;



SELECT npi,drug.drug_name,prescription.total_claim_count
FROM drug
CROSS JOIN prescriber
INNER JOIN prescription
USING (npi)
WHERE prescriber.nppes_provider_city = 'NASHVILLE'
AND drug.opioid_drug_flag = 'Y'
AND prescriber.specialty_description = 'Pain Management'




---BONUS READ ME---

---Question 1---

(SELECT DISTINCT npi
FROM prescriber)
EXCEPT
(SELECT DISTINCT npi
FROM prescription)


SELECT COUNT (*)
FROM ((SELECT DISTINCT npi
FROM prescriber)
EXCEPT
(SELECT DISTINCT npi
FROM prescription)) AS except_count


---Question 2---
---a.---

Select *
FROM drug

Select *
FROM prescriber

SELECT *
FROM prescription

SELECT generic_name,SUM(total_claim_count) as total_claims
FROM prescription
INNER JOIN prescriber
USING(npi)
INNER JOIN drug
USING (drug_name)
WHERE specialty_description = 'Family Practice'
GROUP BY generic_name
ORDER BY total_claims DESC NULLS LAST 
LIMIT 5;

---b.---

SELECT generic_name,specialty_description,SUM(total_claim_count) as total_claims
FROM prescription
INNER JOIN prescriber
USING(npi)
INNER JOIN drug
USING (drug_name)
WHERE specialty_description = 'Cardiology'
GROUP BY generic_name,specialty_description
ORDER BY total_claims DESC NULLS LAST 
LIMIT 5;

---c.---
--using intersect to find generic names in top 5 of claims for family practice and cardiology



(SELECT generic_name
FROM prescription
INNER JOIN prescriber
USING(npi)
INNER JOIN drug
USING (drug_name)
WHERE specialty_description = 'Family Practice'
GROUP BY generic_name
ORDER BY SUM(total_claim_count) DESC NULLS LAST 
LIMIT 5)
INTERSECT
(SELECT generic_name
FROM prescription
INNER JOIN prescriber
USING(npi)
INNER JOIN drug
USING (drug_name)
WHERE specialty_description = 'Cardiology'
GROUP BY generic_name
ORDER BY SUM(total_claim_count) DESC NULLS LAST 
LIMIT 5)


---Question 3---
---A.---


SELECT npi,nppes_provider_city,SUM(total_claim_count) AS total_claims
FROM prescription
INNER JOIN prescriber
USING (npi)
WHERE nppes_provider_city = 'NASHVILLE'
GROUP BY npi, nppes_provider_city
ORDER BY total_claims DESC NULLS LAST
LIMIT 5

---B.---

SELECT npi,nppes_provider_city,SUM(total_claim_count) AS total_claims
FROM prescription
INNER JOIN prescriber
USING (npi)
WHERE nppes_provider_city = 'MEMPHIS'
GROUP BY npi, nppes_provider_city
ORDER BY total_claims DESC NULLS LAST
LIMIT 5

---C.---

(SELECT npi,nppes_provider_city,SUM(total_claim_count) AS total_claims
FROM prescription
INNER JOIN prescriber
USING (npi)
WHERE nppes_provider_city = 'NASHVILLE'
GROUP BY npi, nppes_provider_city
ORDER BY total_claims DESC NULLS LAST
LIMIT 5)
UNION
(SELECT npi,nppes_provider_city,SUM(total_claim_count) AS total_claims
FROM prescription
INNER JOIN prescriber
USING (npi)
WHERE nppes_provider_city = 'MEMPHIS'
GROUP BY npi, nppes_provider_city
ORDER BY total_claims DESC NULLS LAST
LIMIT 5)
UNION
(SELECT npi,nppes_provider_city,SUM(total_claim_count) AS total_claims
FROM prescription
INNER JOIN prescriber
USING (npi)
WHERE nppes_provider_city = 'KNOXVILLE'
GROUP BY npi, nppes_provider_city
ORDER BY total_claims DESC NULLS LAST
LIMIT 5)
UNION
(SELECT npi,nppes_provider_city,SUM(total_claim_count) AS total_claims
FROM prescription
INNER JOIN prescriber
USING (npi)
WHERE nppes_provider_city = 'CHATTANOOGA'
GROUP BY npi, nppes_provider_city
ORDER BY total_claims DESC NULLS LAST
LIMIT 5)
ORDER BY total_claims DESC NULLS LAST;


---Question 4---

SELECT *
from prescription;

SELECT *
FROM drug

SELECT *
FROM cbsa

SELECT *
FROM fips_county

SELECT *
FROM overdose_deaths

SELECT *
FROM population

SELECT *
FROM zip_fips

SELECT state,county,year,overdose_deaths
FROM overdose_deaths
INNER JOIN fips_county
ON overdose_deaths.fipscounty=fips_county.fipscounty::INTEGER
WHERE overdose_deaths > (SELECT AVG(overdose_deaths) FROM overdose_deaths)
ORDER BY overdose_deaths DESC NULLS LAST;


---Question 5---
---a.---

SELECT SUM(population)
FROM fips_county
INNER JOIN population
USING (fipscounty)
WHERE state = 'TN'

---b.---
WITH tn_pop AS (SELECT SUM(population) AS total_pop
				FROM population AS pop
				INNER JOIN fips_county
				USING (fipscounty)
				WHERE state = 'TN')
SELECT fipscounty,county,state,ROUND((population/total_pop)*100,2)  AS pop_percent_of_TN
FROM fips_county
INNER JOIN population
USING (fipscounty)
CROSS JOIN tn_pop
ORDER BY pop_percent_of_tn DESC NULLS LAST





