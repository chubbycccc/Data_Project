{\rtf1\ansi\ansicpg1252\cocoartf2761
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 SELECT *\
FROM financial_loan_new;\
\
\
-- KPI'S-- \
\
-- --1. Total Loan Applications\
\
SELECT \
     COUNT(id) AS total_applicants\
FROM Loan.financial_loan_new;\
\
SELECT\
     SUM(loan_amount) AS total_funded_amount\
FROM Loan.financial_loan_new;\
\
-- 2.MTM(Month to Month) Loan Applications\
SELECT\
(SELECT\
     COUNT(id) as total_applications\
FROM Loan.financial_loan_new\
WHERE MONTH(issue_date)=12)-(SELECT\
     COUNT(id) as total_applications\
FROM Loan.financial_loan_new\
WHERE MONTH(issue_date)=11) AS mtm_change_applicants;\
\
-- 3.Total Funded Amount\
\
SELECT\
      SUM(loan_amount) AS total_loan_amount\
FROM Loan.financial_loan_new;\
\
\
-- 4.Total Funded Amount (Month to Month Change)\
SELECT\
(SELECT\
     SUM(loan_amount) \
FROM Loan.financial_loan_new\
WHERE MONTH(issue_date)=12)-(SELECT\
     SUM(loan_amount) \
FROM Loan.financial_loan_new\
WHERE MONTH(issue_date)=11) AS mtm_change_total_loan_amount;\
\
-- 5. Total Amount Received\
\
SELECT\
      SUM(total_payment) AS total_payment\
FROM Loan.financial_loan_new;\
\
-- 6.MTM Total Amount Received Change\
SELECT\
(SELECT\
     SUM(total_payment) \
FROM Loan.financial_loan_new\
WHERE MONTH(issue_date)=12)-(SELECT\
     SUM(total_payment) \
FROM Loan.financial_loan_new\
WHERE MONTH(issue_date)=11) AS mtm_change_total_payment;\
\
-- -7. -Average Interest Rate \
\
SELECT\
      ROUND(AVG(int_rate)*100,2)\
FROM Loan.financial_loan_new;\
\
-- 8.MTM Average Interest Rate Change\
\
SELECT\
(SELECT\
     AVG(int_rate)*100 \
FROM Loan.financial_loan_new\
WHERE MONTH(issue_date)=12)-(SELECT\
      AVG(int_rate)*100 \
FROM Loan.financial_loan_new\
WHERE MONTH(issue_date)=11) AS mtm_change_avg_intrate;\
\
-- -9. -Average Debit to Income Ratio(DTI)\
\
SELECT\
      ROUND(AVG(dti),2) AS avg_dti\
FROM Loan.financial_loan_new;\
\
-- 10.MTM Average DTI Change\
SELECT\
(SELECT\
     AVG(dti) \
FROM Loan.financial_loan_new\
WHERE MONTH(issue_date)=12)-(SELECT\
      AVG(dti) \
FROM Loan.financial_loan_new\
WHERE MONTH(issue_date)=11) AS mtm_change_dti;\
\
\
-- Good Loan Issued\
\
-- --1.Percentage of Good Loans \
-- --Solution1 \
\
SELECT\
(SELECT\
     COUNT(*) AS num_goodloans\
FROM Loan.financial_loan_new\
WHERE loan_status='Fully Paid' or loan_status='Current') / (SELECT COUNT(*) FROM Loan.financial_loan_new ) AS percent_good_loans;\
\
-- --Soluton 2 \
\
SELECT\
     (SUM(CASE WHEN loan_status='Current' or loan_status='Fully Paid' THEN 1 ELSE 0 END)/ COUNT(*))*100 AS percent_good_loans\
FROM Loan.financial_loan_new;\
\
-- 2. Total Number of Good Loans Application \
\
SELECT\
      COUNT(*) AS num_good_loans\
FROM Loan.financial_loan_new\
WHERE loan_status='Fully Paid' or loan_status='Current';\
\
-- 3. Total Number of Good Loans Application \
SELECT\
      SUM(loan_amount) AS amount_good_loans\
FROM Loan.financial_loan_new\
WHERE loan_status='Fully Paid' or loan_status='Current';\
\
-- 4. Good Loan Total Received Amount\
\
SELECT\
      SUM(total_payment) AS amount_received_good_loans\
FROM Loan.financial_loan_new\
WHERE loan_status='Fully Paid' or loan_status='Current';\
\
-- Bad Loan Issued\
\
-- 1. Bad Loan Percentage\
SELECT\
     (COUNT(CASE WHEN loan_status='Charged Off' THEN id END) / COUNT(*))*100 AS Bad_Loan_Percentage\
FROM Loan.financial_loan_new;\
\
-- 2. Total Number of Bad Loans Application \
SELECT\
     COUNT(*) AS num_bad_loans\
FROM Loan.financial_loan_new\
WHERE loan_status='Charged Off';\
\
-- 3. Total Number of Bad Loans Application \
SELECT\
      SUM(loan_amount) AS amount_bad_loans\
FROM Loan.financial_loan_new\
WHERE loan_status='Charged Off';\
\
\
-- --4. Good Loan Total Received Amount\
\
SELECT\
      SUM(total_payment) AS amount_received_bad_loans\
FROM Loan.financial_loan_new\
WHERE loan_status='Charged Off';\
\
\
-- Loan Status\
\
SELECT\
     loan_status,\
     COUNT(id) AS LoanCount,\
     SUM(total_payment) AS Total_Amount_received,\
     SUM(loan_amount)AS Total_Funded_Amount,\
     AVG(int_rate)*100 AS Average_Int_Rate,\
     AVG(dti)*100 AS Average_DTI\
FROM Loan.financial_loan_new\
GROUP BY loan_status\
ORDER BY LoanCount DESC;\
\
SELECT \
	loan_status, \
	SUM(total_payment) AS MTD_Total_Amount_Received, \
	SUM(loan_amount) AS MTD_Total_Funded_Amount \
FROM Loan.financial_loan_new\
WHERE MONTH(issue_date) = 12 \
GROUP BY loan_status;\
\
\
-- Each Month Debt Situation\
\
SELECT\
     MONTH(issue_date) AS Month_Number,\
     MONTHNAME(issue_date) AS Month_Name,\
     COUNT(id) AS Total_Applicants,\
     SUM(loan_amount) AS Total_Funded_Amount,\
     SUM(total_payment) AS Total_Amount_Received\
FROM Loan.financial_loan_new\
GROUP BY Month_Number, Month_Name\
ORDER BY Month_Number;\
\
-- Each State Debt Situation\
\
SELECT \
	address_state AS State, \
	COUNT(id) AS Total_Loan_Applications,\
	SUM(loan_amount) AS Total_Funded_Amount,\
	SUM(total_payment) AS Total_Amount_Received\
FROM Loan.financial_loan_new\
GROUP BY address_state\
ORDER BY address_state;\
\
-- Each Term Debt Situation\
\
SELECT \
	term AS Term, \
	COUNT(id) AS Total_Loan_Applications,\
	SUM(loan_amount) AS Total_Funded_Amount,\
	SUM(total_payment) AS Total_Amount_Received\
FROM Loan.financial_loan_new\
GROUP BY term\
ORDER BY term;\
\
-- Each Employee Length Debt Situation\
SELECT \
	emp_length AS Employee_Length, \
	COUNT(id) AS Total_Loan_Applications,\
	SUM(loan_amount) AS Total_Funded_Amount,\
	SUM(total_payment) AS Total_Amount_Received\
FROM Loan.financial_loan_new\
GROUP BY emp_length\
ORDER BY emp_length;\
\
-- Each Purpose Debt Situation\
\
SELECT \
	purpose AS PURPOSE, \
	COUNT(id) AS Total_Loan_Applications,\
	SUM(loan_amount) AS Total_Funded_Amount,\
	SUM(total_payment) AS Total_Amount_Received\
FROM Loan.financial_loan_new\
GROUP BY purpose\
ORDER BY purpose;\
\
-- Each Home Ownership Debt Situation\
\
SELECT \
	home_ownership AS Home_Ownership, \
	COUNT(id) AS Total_Loan_Applications,\
	SUM(loan_amount) AS Total_Funded_Amount,\
	SUM(total_payment) AS Total_Amount_Received\
FROM Loan.financial_loan_new\
GROUP BY home_ownership\
ORDER BY home_ownership\
}