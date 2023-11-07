SELECT 
  qs.query_id,
  migs.avg_total_user_cost,
  migs.avg_user_impact,
  -- other columns...
FROM sys.dm_db_missing_index_groups mig  
INNER JOIN sys.dm_db_missing_index_group_stats migs 
  ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details mid
  ON mig.index_handle = mid.index_handle
INNER JOIN sys.dm_exec_query_stats qs
  ON qs.sql_handle = mid.sql_handle
ORDER BY migs.avg_total_user_cost DESC, migs.avg_user_impact DESC