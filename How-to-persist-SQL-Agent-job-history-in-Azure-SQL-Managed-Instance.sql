----https://www.dbascrolls.com/2023/09/how-to-persist-sql-agent-job-history-in-managed-instance.html
----Visit https://www.dbascrolls.com/ for more info

ALTER TABLE [msdb].[dbo].[sysjobhistory] 
ADD StartTime DATETIME2 NOT NULL DEFAULT ('19000101 00:00:00.0000000');

ALTER TABLE [msdb].[dbo].[sysjobhistory] 
ADD EndTime DATETIME2 NOT NULL DEFAULT ('99991231 23:59:59.9999999');

ALTER TABLE [msdb].[dbo].[sysjobhistory] 
ADD PERIOD FOR SYSTEM_TIME (StartTime, EndTime);

ALTER TABLE [msdb].[dbo].[sysjobhistory] 
ADD CONSTRAINT PK_sysjobhistory 
PRIMARY KEY (instance_id, job_id, step_id);

ALTER TABLE [msdb].[dbo].[sysjobhistory] 
SET (SYSTEM_VERSIONING = ON (
    HISTORY_TABLE = [dbo].[sysjobhistoryall], 
    DATA_CONSISTENCY_CHECK = ON, 
    HISTORY_RETENTION_PERIOD = 1 MONTH)
);
