create database aml_data

use aml_data


CREATE TABLE CustomerRisk (
    CustomerID VARCHAR(50),
    TotalTransactions INT,
    TotalVolume FLOAT,
    AvgTransactionAmount FLOAT,
    FraudCount INT,
    FraudRate FLOAT,
    RiskScore INT,
    RiskLevel VARCHAR(20)
);

select * from CustomerRisk


SELECT
    RiskLevel,
    COUNT(*) AS CustomerCount,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS Percentage
FROM CustomerRisk
GROUP BY RiskLevel
ORDER BY CustomerCount DESC;

SELECT TOP 20
    CustomerID,
    TotalVolume,
    FraudCount,
    RiskScore,
    RiskLevel
FROM CustomerRisk
ORDER BY RiskScore DESC, TotalVolume DESC;


SELECT
    RiskLevel,
    SUM(TotalVolume) AS Exposure
FROM CustomerRisk
GROUP BY RiskLevel
ORDER BY Exposure DESC;


SELECT RiskLevel, COUNT(*)
FROM CustomerRisk
GROUP BY RiskLevel;

SELECT RiskLevel, COUNT(*)
FROM AlertQueue
GROUP BY RiskLevel;

select count(*) as Alerts from AlertQueue


CREATE TABLE TransactionSummary (
    TransactionType VARCHAR(30),
    TotalTransactions INT,
    TotalAmount FLOAT,
    AverageAmount FLOAT,
    FraudTransactions INT,
    FraudRate FLOAT,
    FraudExposure FLOAT,
    RiskCategory VARCHAR(20)
);

USE aml_data;


SELECT *
FROM TransactionSummary;

CREATE TABLE dbo.HighRiskTransactions (
    step INT,
    type VARCHAR(30),
    amount FLOAT,
    nameOrig VARCHAR(50),
    nameDest VARCHAR(50),
    isFraud INT,
    TransactionRiskScore INT,
    TransactionRiskLevel VARCHAR(20)
);

SELECT TOP 20 *
FROM dbo.HighRiskTransactions;

-- Fraud KPI 


SELECT
    SUM(amount) AS TotalFraudExposure
FROM dbo.HighRiskTransactions
WHERE isFraud = 1;


-- High Risk Transaction Volume 

SELECT
    TransactionRiskLevel,
    COUNT(*) AS TransactionCount,
    SUM(amount) AS TotalExposure
FROM dbo.HighRiskTransactions
GROUP BY TransactionRiskLevel
ORDER BY TotalExposure DESC;

-- Suspicious Accounts 

SELECT TOP 20
    nameOrig,
    COUNT(*) AS SuspiciousTransactions,
    SUM(amount) AS SuspiciousVolume
FROM dbo.HighRiskTransactions
GROUP BY nameOrig
ORDER BY SuspiciousVolume DESC;

-- High Risk Transactions 
SELECT
    type,
    COUNT(*) AS Count,
    AVG(TransactionRiskScore) AS AvgRiskScore,
    SUM(amount) AS Exposure
FROM dbo.HighRiskTransactions
GROUP BY type
ORDER BY Exposure DESC;

-- Alert Funnel KPI 

SELECT
    (SELECT COUNT(*) FROM dbo.CustomerRisk) AS TotalCustomers,
    (SELECT COUNT(*) FROM dbo.AlertQueue) AS AlertCustomers,
    (SELECT COUNT(*) FROM dbo.HighRiskTransactions) AS HighRiskTransactions;



CREATE TABLE dbo.DailyTransactionMetrics (
    step INT,
    TotalTransactions INT,
    TotalAmount FLOAT,
    FraudTransactions INT,
    FraudRate FLOAT,
    FraudExposure FLOAT,
    AlertFlag INT,
    TrendRiskLevel VARCHAR(20)
);

SELECT TOP 20 *
FROM dbo.DailyTransactionMetrics;