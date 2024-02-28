create database if not exists tata_steel_data;
use tata_steel_data;

create table tata_steel (
date date,
open double ,
high double,
low double,
close double,
adj_close double,
volume bigint );


select * from tata_steel;

-- import the data by using load data infile statement
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/tata steel stock data.csv'
into table tata_steel fields terminated by ',' 
enclosed by '"' lines terminated by '\r\n' ignore 1 rows;

             
-- Calculate the average monthly change in closing prices over a specific time period. A positive average suggests growth, while a negative average suggests decline. 
select round(avg(close - open),2) as average_monthly_change from tata_steel;
    --  remember one thing +postive average suggests growth or grow up 
    -- negative average suggets decline or stock down
    -- result of these stock is postive average which means this stock has growth in future.
    
-- Analyze volume trends. Higher volumes might indicate stronger movements. 
select 
       case 
            when volume > (select avg(volume) from tata_steel ) then 'higher than average volume'
            else 'lower volume'
            end as volume_analysis
            from tata_steel 
            order by date desc limit 1;
    
-- maximum monthly gains and loss.
select date, round((close - open),2) as monthly_gain from tata_steel 
order by date desc;  

-- Check if there is a correlation between higher volumes and positive price movements. 
select 
       case  
            when avg(close - open) > 0 and avg(volume) > (select avg(volume) from tata_steel) then ' potential for future growth'
            else 'no  correlatin observed' 
            end as future_growth_potential 
            from tata_steel;

-- Analyze the volatility by calculating the standard deviation of closing prices. 
select round(stddev_pop(close),2) as price_volatility from tata_steel; 

-- Identify the overall trend by comparing the closing prices over a specific time period. 
select  
      case 
           when min(close) < max(close) then 'potential upward trend' 
           when min(close) > max(close) then 'potential downward trend'
           else 'no clear trend observed'
           end as trend_analysis from tata_steel;
		
 -- Is the latest closing price higher than the opening price? 
 select  
       case 
			when close > open then '  stock likely grow up'
           	when close < open then '  stock likely grow down'
            else 'no significant change expected'
            end as recent_performance from tata_steel 
            order by date desc limit 1;
  
 -- Analyze the historical trends using moving averages or linear regression to identify potential patterns. 
  -- Example: 30-day moving average
SELECT 
    date,
    close,
    round(AVG(close) OVER (ORDER BY date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW),2) AS moving_average
FROM tata_steel;

-- Investigate if there are any seasonal patterns in the stock's historical performance. 
  -- Example: Average closing price by month
SELECT 
    EXTRACT(MONTH FROM date) AS month,
    AVG(close) AS avg_closing_price
FROM tata_steel
GROUP BY month
ORDER BY month;

-- calculate the percentage change in closing prices
select date, 
open,
high,
low,
close,
volume,
 100 * (close - lag(close) over ( order by date )) / lag(close) over ( order by date ) as pricechangepercentage from tata_steel;
  

