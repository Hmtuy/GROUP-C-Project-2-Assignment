/**************************************PROJECT 2:*******************************************************   DUE DATE AUG 28TH 2021******/

USE [SkyBarrelBank_UAT];

/*---------------------------------------Report 1 A:--------------------------------------------------------
The Director of Credit Analytics wants a report of ALL borrower who HAVE taken a loan with the bank. (We are only interested in
borrowers who have a loan in the LoanSetup table). For each borrower, return the below fields: 
a) BorrowerID
b) Borrower Full Name
c) SSN (database field: TaxPayerID_SSN). Please mask the first five digits of the SSN
d) Year the loan was purchased
e) The amount purchased in thousands in this format ($44,068K)    ----------------------------------------*/

-----Use Inner Join function to join the two tables[dbo].[Borrower]and[dbo].[LoanSetupInformation]-----
--**ONLY MATCHING ITEMS WILL BE GENERATED**---

SELECT Br.BorrowerID
      ,[Borrower Name]=CONCAT_WS(' ',  BorrowerFirstName, BorrowerMIddleInitial, BorrowerLastname)
      ,[LoanNumber]
      ,[SSN] =CONCAT('*****',right([TaxPayerID_SSN], 4)) 
      ,[Year Of Purchase]= YEAR (PurchaseDate)
      ,[Purchase Amount (IN THOUSANDS)]= FORMAT (SetUP.PurchaseAmount/1000000, 'C2', 'en-us')+'M'
	  FROM[dbo].[Borrower] AS Br
	  INNER JOIN [dbo].[LoanSetupInformation] AS SetUP
	  ON Br.BorrowerID=SetUp.BorrowerID;

/***---------------------------------Report 1(B)--------------------------------------------------------------------
--Generate a similar list to the one above, this time, show all customers, EVEN THOSE WITHOUT LOANS. Return it with similar columns as
above***/
-----Use Left Join function to join the two tables[dbo].[Borrower]and[dbo].[LoanSetupInformation]-----
--**ALL RECORDS  FROM [dbo].[Borrower] PLUS THE MATCHING RECORDS BETWEEN THE TWO TABLES WILL BE GENERATED**---


SELECT Br.BorrowerID,
    [Borrower Name]=CONCAT(' ',BorrowerFirstName,' ', BorrowerMIddleInitial,' ', borrowerlastname) 
    ,[LoanNumber]
    ,[SSN] =CONCAT('*****',right([TaxPayerID_SSN], 4)) 
    ,[Year Of Purchase]=YEAR (PurchaseDate)
    ,[Purchase Amount(IN THOUSANDS)]=FORMAT ([PurchaseAmount]/1000000, 'C2', 'en-us')+ 'M'
	 FROM[dbo].[Borrower]AS Br
	 LEFT JOIN [dbo].[LoanSetupInformation] AS SetUP
	 ON br.borrowerID=SetUp.BorrowerID;

/*-----------------------------------------Report 2(A): ---------------------------------------------------------------------- 
Aggregate the borrowers by country and show, per country, 
a)The total purchase amount,
b) Average purchase amount,
c) Count of borrowers,
d) Average ltv,
e) Minimum ltv,
f) Maximum ltv
g) Average age of the borrowers
- Order the report by the Total Purchase Amount in descending order--------------------------------------------------------*/

--*USE THE INNER JOIN FUNCTION BETWEEN THE TWO TABLES, GROUP BY CITIZENSHIP, ORDER BY TOTAL AMOUNT PURCHASED**---
	 
	 SELECT [Citizenship],
	        [Total Purchase Amount]= FORMAT(SUM(SetUp.PurchaseAmount), 'C0','en-us'),
			[AVG Purchase Amount]=FORMAT(AVG(SetUp.PurchaseAmount),'C0','en-us'),
			[No. of Borrowers]= COUNT(Br.BorrowerID), 
			[AVG Age of Borrower]=AVG(DATEDIFF(YEAR, [DoB], GETDATE())),
			[AVG LTV]=FORMAT(AVG([LTV]), 'p'),
			[AVG LTV]=FORMAT(MIN(LTV), 'P'),
			[AVG LTV]=FORMAT(MAX([LTV]), 'P') 
			FROM [dbo].[Borrower] AS Br
			INNER JOIN [dbo].[LoanSetupInformation] as SetUP
			ON br.[BorrowerID]=SetUP.[BorrowerID]
		GROUP BY [Citizenship]
		ORDER BY  [Total Purchase Amount] DESC;




/*-----------------------------------------REPORT 2(B):--------------------------------------------------------------
Aggregate the borrowers by gender ( If the gender is missing or is blank, please replace it with X) and show, per country, 
h)The total purchase amount,
i) Average purchase amount,
j) Count of borrowers,
k) Average ltv,
l) Minimum ltv,
m) Maximum ltv
n) Average age of the borrowers
- Order the report by the Total Purchase Amount in descending order
- HINT > SELECT FORMAT(10000.004, 'c0')------------------------------------------------------------------------*/

--**USE INNER JOIN FUNCTION,IF GENDER IS MISSING OR BLANCK REPLACE WITH X,GROUP BY CITIZENSHIP,ORDER BY TOTAL PURCHASE AMOUNT**--

      SELECT [Citizenship],
             count(case when gender='F'  then 1 end ) as Female,
		     count(case when gender='M'  then 1 end ) as Male,
		     count(case when gender=''   then 1 end ) as 'Gender X',
	        [No. of Borrowers]= COUNT(Br.BorrowerID),
			[Total Purchase Amount]= FORMAT(SUM(SetUp.PurchaseAmount), 'C0','en-us'),
			[AVG Purchase Amount]=FORMAT(AVG(SetUp.PurchaseAmount),'C0','en-us'),
		    [AVG Age of Borrower]=AVG(DATEDIFF(YEAR, [DoB], GETDATE())),
			[AVG LTV]=FORMAT(AVG([LTV]), 'P'),
			[AVG LTV]=FORMAT(MIN(LTV), 'p'),
			[AVG LTV]=FORMAT(MAX([LTV]), 'p') 
			FROM [dbo].[Borrower] AS Br
			Inner join [dbo].[LoanSetupInformation] as SetUP
			ON br.[BorrowerID]=SetUP.[BorrowerID]
GROUP BY [Citizenship]
ORDER BY [Total Purchase Amount] DESC;



/*----------------------------------------REPORT 2(C):---------------------------------------------------------------------
Aggregate the borrowers by gender (Only for F and M gender) and show, per country,
o)The total purchase amount,
p) Average purchase amount,
q) Count of borrowers,
r) Average ltv,
s) Minimum ltv,
t) Maximum ltv
u) Average age of the borrowers
- Order the report by the Year in Descending order and Gender----------------------------------------------------*/

--**USE INNER JOIN FUNCTION--GROUP BY CITIZENSHIP,ORDER BY YEAR AND GENDERT**--

--Note*--ONLY FOR (F AND M GENDER)--
 SELECT [Citizenship],
        [Gender],
            [Year Of Purchase]= YEAR([PurchaseDate]),
		    [Total Purchase Amount]= FORMAT(SUM(SetUp.PurchaseAmount), 'C0','en-us'),
			[AVG Purchase Amount]=FORMAT(AVG(SetUp.PurchaseAmount),'C0','en-us'),
			[No. of Borrowers]= COUNT(Br.BorrowerID),
			[AVG Age of Borrower]=AVG(DATEDIFF(YEAR, [DoB], GETDATE())),
			[AVG LTV]=FORMAT(AVG([LTV]), 'P'),
			[AVG LTV]=FORMAT(MIN(LTV), 'P'),
			[AVG LTV]=FORMAT(MAX([LTV]), 'P') 
			FROM [dbo].[LoanSetupInformation] AS SetUP
			Inner join [dbo].[Borrower] AS Br
			ON br.[BorrowerID]=SetUP.[BorrowerID]
				WHERE [Gender]= 'F' OR [Gender]= 'M'
GROUP BY [Citizenship], [Gender],[PurchaseDate]
ORDER BY [Gender], [Year Of Purchase] DESC;


/**------------------------------REPORT 3:-----------------------------------------------------------------
Calculate the years to maturity for each loan( Only loans that have a maturity date in the future) and then categorize them in bins of
years (0-5, 6-10, 11-15, 16-20, 21-25, 26-30, >30).
Show the number of loans in each bins and the total purchase amount for each bin in billions HINT:
SELECT FORMAT(10000457.004, '$0,,,.000B')-------*/


SELECT [Years Left to Maturity (bins)]= CASE
										WHEN Year(MaturityDate) - Year(PurchaseDate) <= 5 THEN '0-5'
										WHEN Year(MaturityDate) - Year(PurchaseDate) <= 10 THEN  '6-10'
										WHEN Year(MaturityDate) - Year(PurchaseDate) <= 15 THEN  '11-15'
										WHEN Year(MaturityDate) - Year(PurchaseDate) <= 20 THEN  '16-20'
										WHEN Year(MaturityDate) - Year(PurchaseDate) <= 25 THEN  '21-25'
										WHEN Year(MaturityDate) - Year(PurchaseDate) <= 30 THEN  '26-30'
										WHEN Year(MaturityDate) - Year(PurchaseDate) > 30 THEN '>30'
									end,
      [No. of Loans]= Count(LoanNumber),
	  [Total Purchase Amount] = FORMAT(SUM(PurchaseAmount/1000000000), 'c3', 'en-us')+ 'B'
FROM [LoanSetupInformation]
GROUP BY  Year(MaturityDate) - Year(PurchaseDate);



/**------------------------------------------REPORT 4:--------------------------------------------------------
Aggregate the Number Loans by Year of Purchase and the Payment frequency description column found in the
LU_Payment_Frequency table-------------------------------------------------------------------*/

--**USE LEFT JOIN FUNCTION OF TABLE [dbo].[LoanSetupInformation]AND[dbo].[LU_PaymentFrequency]
--You are interested with all loans and their purchase year and joining them to their payment frequency--**/
--NOTE: BOTH LEFT AND INNER JOINS PROVIDED THE SAME RESULTS ONLY THE ORDER CHANGED--

SELECT YEAR (PurchaseDate) as [Year Of Purchase],
      [PF].[PaymentFrequency_Description],
	  COUNT([SetUP]. [LoanNumber]) as [No. of Loans]
	  FROM [LoanSetupInformation] AS SetUP
  LEFT JOIN [dbo].[LU_PaymentFrequency] AS PF
	  ON SetUP.PaymentFrequency= PF.PaymentFrequency
	  GROUP BY YEAR([PurchaseDate]),[PaymentFrequency_Description]
	  ORDER BY YEAR([PurchaseDate]);

	  
SELECT YEAR (PurchaseDate) as [Year Of Purchase],
      [PF].[PaymentFrequency_Description],
	  COUNT([SetUP].[BorrowerID]) as [No. of Loans]
	  FROM [dbo].[LoanSetupInformation]AS SetUP
INNER JOIN [dbo].[LU_PaymentFrequency]AS pf
	  ON SetUP.PaymentFrequency= PF.PaymentFrequency
	  GROUP BY YEAR([PurchaseDate]),[PaymentFrequency_Description]
	  ORDER BY [Year Of Purchase];---YOu can order by an aliased name since it comes after the select statement not the same for Group by--



