/*https://www.dbascrolls.com*/

DECLARE @time_threshold INT = 60000; -- 1 minute in milliseconds

SELECT 
    r.session_id,
    DB_NAME(r.database_id) AS dbname,
    s.login_name,
    r.blocking_session_id,
    r.status,
    s.program_name,
    s.host_name,
    r.transaction_isolation_level,
    r.percent_complete,
    r.start_time,
    r.total_elapsed_time / 1000.0 AS total_elapsed_seconds,
    r.wait_type,
    r.last_wait_type,
    r.command,
    r.cpu_time,
    r.reads,
    r.writes,
    r.logical_reads,
    t.text AS query_text,
    qp.query_plan
FROM 
    sys.dm_exec_requests r
JOIN 
    sys.dm_exec_sessions s ON r.session_id = s.session_id
CROSS APPLY 
    sys.dm_exec_sql_text(r.sql_handle) t
CROSS APPLY 
    sys.dm_exec_query_plan(r.plan_handle) qp
WHERE 
    r.total_elapsed_time > @time_threshold -- queries running longer than 1 minute
ORDER BY 
    r.total_elapsed_time DESC;
