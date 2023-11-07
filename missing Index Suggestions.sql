Sure, I can help you with that. To retrieve missing index details with query id in T-SQL, you can use the following script:

```sql
SELECT 
    migs.avg_total_user_cost,
    migs.avg_user_impact,
    migs.user_seeks,
    migs.user_scans,
    migs.last_user_seek,
    migs.last_user_scan,
    migs.avg_total_logical_reads,
    migs.avg_total_logical_writes,
    migs.last_logical_reads,
    migs.last_logical_writes,
    migs.database_id,
    mid.database_id,
    mid.[object_id],
    mid.statement,
    mid.equality_columns,
    mid.inequality_columns,
    mid.included_columns,
    mid.unique_compiles,
    mid.user_seeks,
    mid.user_scans,
    mid.last_user_seek,
    mid.last_user_scan,
    mid.system_seeks,
    mid.system_scans,
    mid.last_system_seek,
    mid.last_system_scan,
    mid.avg_total_user_cost,
    mid.avg_total_logical_reads,
    mid.avg_total_logical_writes,
    migs.unique_compiles,
    migs.last_compile_start,
    migs.last_compile_end,
    migs.avg_compile_duration,
    migs.query_id,
    migs.query_plan_hash
FROM 
    sys.dm_db_missing_index_group_stats AS migs
INNER JOIN 
    sys.dm_db_missing_index_groups AS mig ON migs.group_handle = mig.index_group_handle
INNER JOIN 
    sys.dm_db_missing_index_details AS mid ON mig.index_handle = mid.index_handle
```

This script retrieves information about missing indexes along with details like query id. Keep in mind that this script is just a starting point and may need to be adjusted depending on your specific requirements or environment.