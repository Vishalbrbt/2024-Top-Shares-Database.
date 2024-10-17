create database project
use project

CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY IDENTITY(1,1),
    CompanyName VARCHAR(100) NOT NULL,
    Sector VARCHAR(50),
    MarketCap DECIMAL(15, 2),
    Description TEXT
);

CREATE TABLE SharePrices (
    PriceID INT PRIMARY KEY IDENTITY(1,1),
    CompanyID INT FOREIGN KEY REFERENCES Companies(CompanyID),
    Date DATE NOT NULL,
    OpenPrice DECIMAL(10, 2),
    ClosePrice DECIMAL(10, 2),
    HighPrice DECIMAL(10, 2),
    LowPrice DECIMAL(10, 2),
    Volume INT
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username VARCHAR(50) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL
);

CREATE TABLE Portfolios (
    PortfolioID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    PortfolioName VARCHAR(100)
);

CREATE TABLE PortfolioItems (
    PortfolioItemID INT PRIMARY KEY IDENTITY(1,1),
    PortfolioID INT FOREIGN KEY REFERENCES Portfolios(PortfolioID),
    CompanyID INT FOREIGN KEY REFERENCES Companies(CompanyID),
    Shares INT
);

-- Insert Companies
INSERT INTO Companies (CompanyName, Sector, MarketCap, Description)
VALUES 
('Tech Innovations Corp.', 'Technology', 1500000000.00, 'Leading provider of tech solutions.'),
('Green Energy Ltd.', 'Energy', 1200000000.00, 'Renewable energy solutions for a sustainable future.'),
('Healthcare Plus Inc.', 'Healthcare', 2000000000.00, 'Innovative healthcare products and services.');

-- Insert Share Prices
INSERT INTO SharePrices (CompanyID, Date, OpenPrice, ClosePrice, HighPrice, LowPrice, Volume)
VALUES 
(1, '2024-01-02', 100.00, 105.00, 107.00, 99.00, 100000),
(2, '2024-01-02', 50.00, 55.00, 56.00, 49.00, 50000),
(3, '2024-01-02', 200.00, 195.00, 205.00, 190.00, 75000);

-- Insert Users
INSERT INTO Users (Username, Email, PasswordHash)
VALUES 
('johndoe', 'john.doe@example.com', 'hashedpassword123'),
('janesmith', 'jane.smith@example.com', 'hashedpassword456');

-- Insert Portfolios
INSERT INTO Portfolios (UserID, PortfolioName)
VALUES 
(1, 'My Tech Stocks'),
(2, 'Green Investments');

-- Insert Portfolio Items
INSERT INTO PortfolioItems (PortfolioID, CompanyID, Shares)
VALUES 
(1, 1, 10),
(2, 2, 20);

Q1---.Retrieve All Companies and Their Market Cap:
SELECT CompanyName, Sector, MarketCap
FROM Companies;

Q2.----Get Daily Share Prices for a Specific Company:
SELECT Date, OpenPrice, ClosePrice, Volume
FROM SharePrices
WHERE CompanyID = 1
ORDER BY Date DESC;

Q3.---Find All Portfolios for a User:
SELECT P.PortfolioName, C.CompanyName, PI.Shares
FROM Portfolios P
JOIN PortfolioItems PI ON P.PortfolioID = PI.PortfolioID
JOIN Companies C ON PI.CompanyID = C.CompanyID
WHERE P.UserID = 1;

Q4--- Find the company whose share price fluctuated the most (highest difference between high and low prices).
SELECT CompanyName, MAX(HighPrice - LowPrice) AS MaxFluctuation
FROM SharePrices S
JOIN Companies C ON S.CompanyID = C.CompanyID
GROUP BY CompanyName
ORDER BY MaxFluctuation DESC;

Q5--- List all companies whose stocks closed above the average closing price for the day.
WITH DailyAverage AS (
    SELECT Date, AVG(ClosePrice) AS AvgPrice
    FROM SharePrices
    GROUP BY Date
)
SELECT S.Date, C.CompanyName, S.ClosePrice
FROM SharePrices S
JOIN Companies C ON S.CompanyID = C.CompanyID
JOIN DailyAverage D ON S.Date = D.Date
WHERE S.ClosePrice > D.AvgPrice;

Q6---Identify which users have invested in companies from multiple sectors.
SELECT U.Username, COUNT(DISTINCT C.Sector) AS SectorCount
FROM Users U
JOIN Portfolios P ON U.UserID = P.UserID
JOIN PortfolioItems PI ON P.PortfolioID = PI.PortfolioID
JOIN Companies C ON PI.CompanyID = C.CompanyID
GROUP BY U.Username
HAVING COUNT(DISTINCT C.Sector) > 1;
