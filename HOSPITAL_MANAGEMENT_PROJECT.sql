USE Hospital_management;




##...How many patients are registerd in last 30 days .. 

SELECT * FROM PATIENTS;

SELECT * FROM PATIENTS
WHERE REGISTRATION_DATE >= (SELECT MAX(Registration_date) - INTERVAL 30 day FROM Patients) ;

##---INSIGHT - Only one patients registration on last 30 day. 
            #- Very low recwnt aquisition rate
##- RESION - Poor marketing ,bed review....If this partten is continue no new patients in future. 





###..What are distinct specializatin on hospital.. 

SELECT
      DISTINCT(Specialization)	
FROM DOCTORS;





###..Short the doctors based on their specializatin and provide their first & last_name of doctor.. 

SELECT* FROM Doctors;

SELECT 
      DOCTOR_ID,
      CONCAT(First_name,' ',last_name) AS Doctors_name,
      Specialization,
      years_experience
FROM Doctors
ORDER BY Years_experience DESC;





###..Find the doctors name ending with "is".... 

SELECT * FROM DOCTORS;

SELECT 
      doctor_id,
      CONCAT(first_name,' ',last_name) AS Doctors_name,
      specialization
FROM Doctors 
WHERE CONCAT(first_name,' ',last_name) LIKE "%is" ;





##...What is Appointments Status distributation .... 

SELECT 
	 Status,
      COUNT(*) AS NO_of_appointment
FROM Appointments
GROUP BY Status
ORDER BY Count(*) DESC;
      
      
      
      
 ###Provide me the status type whose coumt is more then 50 ...     
 
 SELECT
       Status,
       COUNT(*) AS  NO_of_appointment
FROM Appointments
GROUP BY status
HAVING COUNT(*) >= 50;
 
 
 
 
 
 ###..find all appointments in last 7 days.. 
 
 SELECT * FROM appointments
 WHERE appointment_date >= (SELECT MAX(appointment_date) - INTERVAL 7 DAY FROM appointments)
 ORDER BY appointment_date DESC;
 
 
 
 
 
 ##...FIND date wise total appointments AND SHOW STATUS.. 
 
 SELECT 
       Appointment_date ,
        status,
       COUNT(*) AS no_of_appointment
 FROM appointments
 GROUP BY  appointment_date,status
 ORDER BY COUNT(*) DESC;
 
 
 
 
 ##what is most common treatment.. 
 
 SELECT * FROM Treatments;
 
 SELECT  
       treatment_type,
       COUNT(*)
FROM treatments
GROUP BY treatment_type
ORDER BY COUNT(*) DESC;
 
 
 
 ##FIND MIN MAX AVG COST OF TREATMENT... 
 
 SELECT 
       treatment_type,
       ROUND(AVG(cost)) AS AVG_cost,
       ROUND(MAX(cost)) AS max_cost,
       ROUND(MIN(cost)) AS min_cost
FROM treatments
GROUP BY Treatment_type
ORDER BY AVG_cost,max_cost, min_cost DESC;
 
 
 
 
 ##..payment status distributation... 
 
 SELECT * FROM BILLING; 
 
 SELECT 
       payment_status,
       COUNT(*) AS Bill_count
FROM billing
GROUP BY payment_status
ORDER BY COUNT(*);

 
 
 ## patients and doctor Segmentation... 
 
 SELECT * FROM PATIENTS ;
 SELECT * FROM appointments;
 SELECT * FROM DOCTORS;
 
 SELECT
      p.patient_id,
      CONCAT(p.first_name,' ',p.last_name) AS patient_name,
	  d.doctor_id,
      a.reason_for_visit,
      CONCAT(d.first_name,' ',d.last_name) AS Doctors_name,
      d.specialization
FROM appointmentS a
JOIN patients p
ON p.patient_id = a.patient_id 
JOIN Doctors d 
ON d.doctor_id = a.doctor_id ;



##..how many patients are register from each address


SELECT
      address,
      COUNT(*) AS no_of_registration
FROM patients                               #-this top 2 Resion are residential area,strong network
GROUP BY ADDRESS                            #targete- more advtizement
ORDER BY COUNT(*) DESC;
  
  
  
  

##what is age distributation of patients...

SELECT
      Patient_id,
      CONCAT(first_name,' ',last_name) As Patient_name,
      TIMESTAMPDIFF(YEAR,Date_of_birth,Curdate()) AS Age_of_patients
FROM patients
ORDER BY Age_of_patients DESC;




##..Age group  segmentation -  18-35,36-55,56+ ...

SELECT 
  CASE
      WHEN TIMESTAMPDIFF(YEAR,Date_of_birth,Curdate()) < 18 THEN "UNDER 18"
	  WHEN TIMESTAMPDIFF(YEAR,Date_of_birth,Curdate()) BETWEEN 18 AND 35 THEN "ADULT"
      WHEN TIMESTAMPDIFF(YEAR,Date_of_birth,Curdate()) BETWEEN 36 AND 60 THEN "MATURE"
      ELSE "SENIORS" END AS Age_category,
      COUNT(*) NO_OF_PATIENTS
FROM PATIENTS
GROUP BY AGE_CATEGORY
ORDER BY COUNT(*) DESC;




##..Which email domain are mostly commanly used.. 

SELECT 
      SUBSTRING_INDEX(email, "@",-1) email_domain,
      COUNT(*) AS no_of_user
FROM patients
GROUP BY email_domain;
	




# which month had higher  patients registerd..  

SELECT * FROM Patients;

SELECT 
     YEAR(registration_date) AS REGISTRATION_YEAR,
     MONTH(registration_date) AS registration_month,
     COUNT(*) AS no_of_registration
FROM patients
GROUP BY YEAR(registration_date),MONTH(registration_date) 
;




##Which medical speialization are most in demand based on appointment.. 

SELECT * FROM appointments;
SELECT * FROM Doctors;

SELECT 
      d.Specialization,
      COUNT(a.Appointment_id) AS no_of_appointment
FROM appointments a
JOIN Doctors d 
ON d.doctor_id = a.doctor_id 
GROUP BY d.specialization
ORDER BY COUNT(a.Appointment_id) DESC;






##..Are critical specializatin suppored by senior experience doctor or junior doctor.. 

SELECT * FROM doctors; 

SELECT 
      CASE
          WHEN years_experience <= 15 THEN "Junior Doctor" 
          WHEN years_experience >= 16 THEN "Senior Doctors" 
          ELSE "NO" END AS doctors_category ,
          Specialization,
          COUNT(*) 
FROM doctors
GROUP BY doctors_category,Specialization 
ORDER BY COUNT(*) DESC;

SELECT 
	specialization,
    COUNT(DOCTOR_ID) AS no_of_doctor, 
	SUM(CASE WHEN years_experience <= 15 THEN 1 ELSE 0 END) AS "junior_doctor",
    SUM(CASE WHEN years_experience >= 16 THEN 1 ELSE 0 END) AS "SENIOR_DOCTORS"
FROM Doctors 
GROUP BY specialization 
ORDER BY COUNT(DOCTOR_ID) DESC ;



##...make a table/ master data appintment with patients details and doctors specialization

SELECT * FROM APPOINTMENTS;
SELECT * FROM DOCTORS;
SELECT * FROM PATIENTS;


SELECT
      p.Patient_id,
      CONCAT(p.first_name,' ',p.last_name) AS patients_name,
      p.address,p.insurance_provider,p.insurance_number, 
      d.doctor_id,
      CONCAT(d.first_name," ",d.last_name) AS  doctors_name,
      d.Specialization ,d.years_experience,d.hospital_branch ,
      a.appointment_id,a.appointment_date,a.reason_for_visit,A.STATUS
FROM  appointments a
JOIN doctors d
ON d.doctor_id = a.doctor_id 
JOIN patients p 
ON p.patient_id = a.patient_id ;

      
      
      
      ##which doctors are overloaded and which are available capacity based on appointment ....
      
      
SELECT * FROM doctors;
SELECT * FROM APPOINTMENTS; 

	  
SELECT 
      d.doctor_id,
      CONCAT(d.first_name,' ',d.last_name) AS doctors_name,
      COUNT( A.Appointment_id) AS no_of_appointment
FROM Appointments a 
LEFT JOIN Doctors d
ON d.doctor_id = a.doctor_id 
GROUP BY  d.doctor_id, doctors_name 
ORDER BY  COUNT( A.Appointment_id) DESC;  

      

##..build a big master mata where we can see patient entier journey ... 
SELECT * FROM PATIENTS;
SELECT * FROM APPOINTMENTS;
SELECT * FROM TREATMENTS;
SELECT * FROM BILLING;      
      
SELECT 
      p.patient_id,
      CONCAT(p.first_name,' ',p.last_name) AS Patients_name ,
      p.address,
      a.appointment_id,
      A.APPOINTMENT_DATE,
      a.reason_for_visit,
      a.status,
      T.TREATMENT_ID,
      t.treatment_type,
      t.cost AS Treatment_cost ,
      b.bill_id,
      b.amount AS Billing_Amount ,
      b.payment_status,
      b.payment_method 
FROM appointments a
JOIN Patients p 
ON p.patient_id = a.patient_id 
JOIN Doctors d 
ON d.doctor_id = a.doctor_id 
JOIN Treatments T 
ON t.appointment_id = a.appointment_id 
JOIN Billing B 
ON B.treatment_id = t.treatment_id
;
      
      
##What is total revenue generated by company.. 

SELECT
      ROUND(SUM(amount)) AS total_revenue
FROM BILLING
WHERE Payment_status = "paid"   ;   




#WHICH PATIENTS CONTRIBUTE MOST REVENUE... 
SELECT
	p.patient_id,
      CONCAT(p.first_name,' ',p.last_name) AS patients_name,
      ROUND(SUM(b.amount)) AS Patients_contribuion 
FROM patients p 
JOIN Billing b 
ON b.patient_id =p.patient_id 
WHERE payment_status = "paid"
GROUP BY  p.patient_id,Patients_name 
ORDER BY SUM(b.amount) DESC;



###...RFM Segmentation.... 
#..RECENCY , FREQUENCY, MONETORING 


##...Creat the RFM matrix per patience ..(last visit,total visit, total_spend)

SELECT* FROM Patients;
SELECT * FROM appointments;
SELECT * FROM BILLING;


WITH RFM AS 
(
SELECT 
      P.Patient_id,
      CONCAT(P.first_name,' ',P.last_name) AS Patients_name,
	  MAX(a.appointment_date) AS Last_visit ,
      DATEDIFF(CURDATE(),MAX(a.appointment_date)) AS Recency_days,
      COUNT(DISTINCT A.appointment_id) AS FRIQUENCY, 
      ROUND(SUM(B.amount)) AS monitoring 
FROM Appointments A 
JOIN Patients P 
ON P.patient_id =a.patient_id 
JOIN Billing b 
ON b.Patient_id =P.patient_id 
WHERE payment_status = "paid" 
GROUP BY P.Patient_id,Patients_name 
),SCORE AS
(
SELECT 
      patient_id,
      patients_name,
      last_visit,
      Recency_days,FRIQUENCY,monitoring,
      NTILE(4) OVER(ORDER BY Recency_days ) R_score, 
      NTILE(4) OVER(ORDER BY FRIQUENCY DESC) F_score,
      NTILE(4) OVER(ORDER BY monitoring DESC) M_score
FROM RFM
)
SELECT 
       * ,
       CONCAT(R_SCORE,F_SCORE,M_SCORE) AS rfm_code,
       CASE
           WHEN r_score >=3  AND m_score >=3  AND F_score >=3  THEN "CHAMPION"
           WHEN r_score >=3 AND m_score >=3  THEN "LOYAL HIGH VALUE"
		   WHEN r_score <=2 AND F_score >=3 THEN "At Risk/ Inactive"
           WHEN F_SCORE >=3 THEN "FRIQUENT  VISITER"
           WHEN M_SCORE >=3 THEN "HIGH PAIR"
           ELSE "REGULAR" END AS Segment 
	FROM SCORE
    ;





###..OUTLAIER DITECTION....... 

##..are their treatments with unusally high that requier revew ....


SELECT 
	 treatment_id,
     treatment_type       #--No outlier treatments.
FROM TREATMENTS
WHERE COST > (SELECT AVG(cost)+2*STDDEV(COST) FROM TREATMENTS);





##rank doctors by total appointments.. 

SELECT
	  RANK() OVER(ORDER BY  COUNT(A.APPOINTMENT_ID) DESC) RANKS,
	  CONCAT(d.first_name," ",d.last_name) AS doctors_name,
      d.Specialization,
      COUNT(A.APPOINTMENT_ID) AS appointments
FROM appointments a 
JOIN Doctors d 
ON a.doctor_id =d.doctor_id 
GROUP BY d.doctor_id,doctors_name,d.specialization;
      


##rank patients based on total spending.... 

SELECT * FROM PATIENTS;
SELECT * FROM BILLING;

SELECT 
      RANK() OVER( ORDER BY SUM(CASE WHEN PAYMENT_STATUS = "PAID" THEN B.AMOUNT END)DESC) AS RANKS,
      CONCAT(P.first_name,' ',P.last_name) AS Patients_name,
      round(SUM(CASE WHEN PAYMENT_STATUS = "PAID" THEN B.AMOUNT END)) AS Toatl_spending
FROM PATIENTS p
JOIN BILLING B 
ON b.patient_id = p.patient_id 
GROUP BY p.patient_id,Patients_name;




##are their appointment status that indicate patients disigagement risk? 

SELECT 
      Status,
      COUNT(*) AS Patients_appointments
FROM Appointments                         # -High patients disengagment risk [[ noshow + cancelled >>> sheduled+completed ]]
GROUP BY Status;






##which patients are repetedly miss appointments & they need intervetion ... 
#40 PERCENT > NO-SHOW AND TOTAL_APPOINTMENTS >>3

SELECT * FROM APPOINTMENTS;
SELECT * FROM PATIENTS;


SELECT 
	  P.PATIENT_ID,
      CONCAT(p.first_name,' ',p.last_name) AS patients_name,
      COUNT(a.appointment_id) AS total_appointment,
      SUM(CASE WHEN A.STATUS = "No-show"   THEN 1 ELSE 0 END) AS NO_SHOW_COUNT,
      ROUND((SUM(CASE WHEN A.STATUS = "No-show"   THEN 1 ELSE 0 END)*100/COUNT(a.appointment_id)),1) AS NO_SHOW_PERCENT 
FROM APPOINTMENTS A
JOIN PATIENTS P 
ON P.PATIENT_ID = A.PATIENT_ID 
GROUP BY PATIENT_ID,patients_name
HAVING total_appointment >=3 
	   AND 
       (SUM(CASE WHEN A.STATUS = "No-show"   THEN 1 ELSE 0 END)*100/COUNT(a.appointment_id)) >= 40 ;

      
      
      
#Are their treatments when unussaly high cost that require revied .. 

SELECT * FROM TREATMENTS;

SELECT
      TREATMENT_ID,
      TREATMENT_TYPE,
      COST 
FROM TREATMENTS
WHERE COST > (SELECT AVG(COST)+2*STDDEV(COST) FROM TREATMENTS);






##rank doctors by total appointments .. 


SELECT 
      RANK() OVER(ORDER BY COUNT(A.APPOINTMENT_ID) DESC) RANKS,
      D.DOCTOR_ID,
      CONCAT(D.FIRST_NAME,' ',D.LAST_NAME) AS DOCTORS_NAME ,
      COUNT(A.APPOINTMENT_ID) AS NO_ODF_APPOINTMENT 
FROM APPOINTMENTS A
JOIN DOCTORS D
ON D.DOCTOR_ID = A.DOCTOR_ID 
GROUP BY D.DOCTOR_ID,DOCTORS_NAME
ORDER BY COUNT(A.APPOINTMENT_ID) DESC;




##MONTHELY REVENUE TREAD .. 

SELECT * FROM BILLING;

SELECT
      YEAR(BILL_DATE) AS YEARS,
      MONTH(BILL_DATE) AS MONTHS,
      SUM(AMOUNT) AS TOTAL_REVENUE
FROM BILLING 
WHERE PAYMENT_STATUS = "PAID"
GROUP BY YEARS ,MONTHS
ORDER BY SUM(AMOUNT) DESC;




##APPOINTMENT SEQUENCE PER PATIENTS .... 

SELECT * FROM APPOINTMENTS;


SELECT
      patient_id,
      APPOINTMENT_ID,
      APPOINTMENT_DATE,
      RANK() OVER( PARTITION BY PATIENT_ID ORDER BY APPOINTMENT_DATE) AS VISIT 
FROM APPOINTMENTS
 ;
 
 
 
 ##what is gap between patients visit .. 
 SELECT
      patient_id,
      APPOINTMENT_ID,
      APPOINTMENT_DATE,
      DATEDIFF(APPOINTMENT_DATE, LAG(APPOINTMENT_DATE) OVER (PARTITION BY PATIENT_ID ORDER BY APPOINTMENT_DATE)) AS VISIT_GAP,
      RANK() OVER( PARTITION BY PATIENT_ID ORDER BY APPOINTMENT_DATE ) AS VISIT 
FROM APPOINTMENTS
 