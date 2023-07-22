<#
Created by Lince Sebastian
For more please visit 
https://www.dbascrolls.com/

#>

# Database connection settings
$serverName = "localhost"
$databaseName = "DatabaseName"
# T-SQL query to execute
$query = "exec newtsql"

# Define color variables
$headerFontColor = "white"
$headerBackgroundColor = "green"
$cellFontColor = "black"
$cellBackgroundColor = "lightyellow"

# SQL Server Database Mail settings
$subject = "T-SQL Results"
$profileName = "MailProfile" # Replace with the name of your Database Mail profile
$recipients = "recipient@outlook.com"    # Replace with the email address of the recipient

$connectionString = "Server=$serverName;Database=$databaseName;Integrated Security=True;"

# Function to execute T-SQL query and convert results to HTML table
function Get-TSQLResultsAsHtmlTable {
    param (
        [string]$connectionString,
        [string]$query,
        [string]$headerFontColor = "black",
        [string]$headerBackgroundColor = "lightgray",
        [string]$cellFontColor = "black",
        [string]$cellBackgroundColor = "white"
    )
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $command = $connection.CreateCommand()
    $command.CommandText = $query

    $dataAdapter = New-Object System.Data.SqlClient.SqlDataAdapter $command
    $dataTable = New-Object System.Data.DataTable
    $dataAdapter.Fill($dataTable) | Out-Null

    $columns = $dataTable.Columns
    $htmlTable = "<table><tr>"
    foreach ($column in $columns) {
        $columnName = $column.ColumnName
        # Extract just the column name without the table name prefix
        if ($columnName.Contains(".")) {
            $columnName = $columnName.Split(".")[-1]
        }
        $htmlTable += "<th style='color: $headerFontColor; background-color: $headerBackgroundColor;'>$columnName</th>"
    }
    $htmlTable += "</tr>"
    foreach ($row in $dataTable.Rows) {
        $htmlTable += "<tr>"
        foreach ($column in $columns) {
            $cellValue = $row[$column]
            $htmlTable += "<td style='color: $cellFontColor; background-color: $cellBackgroundColor;'>$cellValue</td>"
        }
        $htmlTable += "</tr>"
    }
    $htmlTable += "</table>"

    $connection.Close()

    return $htmlTable
}


# Get the HTML table with custom font and background colors
$htmlTable = Get-TSQLResultsAsHtmlTable -connectionString $connectionString -query $query `
    -headerFontColor $headerFontColor -headerBackgroundColor $headerBackgroundColor `
    -cellFontColor $cellFontColor -cellBackgroundColor $cellBackgroundColor


# Build the email body with HTML table
$emailBody = @"
<html>
<head>
<style>
    table {
        border-collapse: collapse;
    }
    th, td {
        border: 1.5px solid black;
        padding: 8px;
    }
</style>
</head>
<body>
<p>Hello, 
 <br>

 <br>Please find the results in the table below:
</p>
$htmlTable
</body>
</html>
"@

# Replace single quotes with double quotes in the email body
$emailBody = $emailBody -replace "'", "''"

# Send the email using sp_send_dbmail
$sendMailQuery = @"
EXEC msdb.dbo.sp_send_dbmail
    @profile_name = '$profileName',
    @recipients = '$recipients',
    @subject = '$subject',
    @body = '$emailBody',
    @body_format = 'HTML';
"@

# Execute the query using the SQL Server connection
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$command = $connection.CreateCommand()
$command.CommandText = $sendMailQuery

$connection.Open()
$command.ExecuteNonQuery()
$connection.Close()
