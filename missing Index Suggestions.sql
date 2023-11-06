SELECT 
  migs.query_id,
  migs.avg_total_user_cost,
  migs.avg_user_impact,  
  migs.user_seeks,
  migs.user_scans,
  migs.last_user_seek,
  migs.last_user_scan,  
  migs.unique_compiles,
  migs.equality_columns, 
  migs.inequality_columns,
  migs.included_columns,
  migs.index_type_desc,  
  QUOTENAME(DB_NAME(mid.[database_id])) + '.' 
      + QUOTENAME(OBJECT_SCHEMA_NAME(mid.[object_id],mid.[database_id])) + '.'  
      + QUOTENAME(OBJECT_NAME(mid.[object_id],mid.[database_id])) AS [table_name],
  COL_NAME(mid.[object_id], mid.equality_column_id) AS equality_column,
  COL_NAME(mid.[object_id], mid.inequality_column_id) AS inequality_column,
  COL_NAME(mid.[object_id], mid.included_column_id) AS included_column 
FROM sys.dm_db_missing_index_groups mig
INNER JOIN sys.dm_db_missing_index_group_stats migs 
  ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details mid
  ON mig.index_handle = mid.index_handle
ORDER BY migs.avg_total_user_cost DESC, migs.avg_user_impact DESC