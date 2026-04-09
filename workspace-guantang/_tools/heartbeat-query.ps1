param()
try {
    [void][System.Reflection.Assembly]::LoadWithPartialName('MySql.Data')
    $connStr = 'Server=localhost;Port=3306;Database=baozipu_pipeline;Uid=pipeline_user;Pwd=Pipeline2026!;'
    $conn = New-Object MySql.Data.MySqlClient.MySqlConnection($connStr)
    $conn.Open()
    
    # Query active plans
    $cmd = $conn.CreateCommand()
    $cmd.CommandText = "SELECT plan_id, plan_name, status, current_round, total_rounds FROM pipeline_plans WHERE status IN ('waiting', 'processing') ORDER BY priority, created_at"
    $reader = $cmd.ExecuteReader()
    Write-Host "=== Active Plans ==="
    while ($reader.Read()) {
        Write-Host "$($reader['plan_id']) | $($reader['plan_name']) | $($reader['status']) | R$($reader['current_round'])/$($reader['total_rounds'])"
    }
    $reader.Close()
    
    # Query active agent tasks
    $cmd2 = $conn.CreateCommand()
    $cmd2.CommandText = "SELECT agent_id, plan_id, round_id, status, assigned_at FROM pipeline_agent_tasks WHERE status IN ('assigned', 'executing') ORDER BY assigned_at DESC"
    $reader2 = $cmd2.ExecuteReader()
    Write-Host "`n=== Active Agent Tasks ==="
    while ($reader2.Read()) {
        Write-Host "$($reader2['agent_id']) | $($reader2['plan_id']) | R$($reader2['round_id']) | $($reader2['status']) | $($reader2['assigned_at'])"
    }
    $reader2.Close()
    
    $conn.Close()
} catch {
    Write-Host "DB Error: $($_.Exception.Message)"
}
