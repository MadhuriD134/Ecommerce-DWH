CREATE OR REPLACE PROCEDURE `vf-grp-gbissdbx-dev-1.customer_service.SP_Load_Dim_Calendar`(startDate DATE, endDate DATE)
BEGIN

DECLARE x, y DATE  ;  

SET x = startDate;
SET y = endDate;

CREATE OR REPLACE TABLE `vf-grp-gbissdbx-dev-1.customer_service.Dim_Calendar`   as
select rdate as calendarDate,cast(FORMAT_DATE("%Y", rdate) as int64) as year,
CAST(CAST(DIV(EXTRACT(DAY FROM rdate), 7) + 1 AS STRING) as int64) as weekNum,
FORMAT_DATE("%A", rdate) as dayName,
EXTRACT(MONTH FROM rdate) as monthNum,
FORMAT_DATE("%B", rdate) as monthName,
CASE
    WHEN FORMAT_DATE("%a", rdate)="Sun" or FORMAT_DATE("%a", rdate)="Sat" THEN 1
    ELSE 0
END as isWeekEnd,
Case WHEN rdate = LAST_DAY(rdate, MONTH)  THEN 1 ELSE 0 END  as isMonthEnd,
Case WHEN rdate = DATE_TRUNC(rdate,MONTH) THEN 1 ELSE 0 END as isMonthStart
FROM UNNEST(GENERATE_DATE_ARRAY(x, y)) AS rdate
;

END;


--call `vf-grp-gbissdbx-dev-1.customer_service.SP_Load_Dim_Calendar`(date('2020-01-01'), date('2050-12-31'));