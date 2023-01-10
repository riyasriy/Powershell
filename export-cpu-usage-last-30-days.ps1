#Connect-AzAccount

# Set the tenant ID
$tenantId = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

# Get all subscriptions in the tenant
$subscriptions = Get-AzSubscription -TenantId $tenantId

# Set the start and end dates to be 30 days in the past
$startDate = (Get-Date).AddDays(-30)
$endDate = (Get-Date)

foreach($subscription in $subscriptions)
{
# Set the resource group and subscription for the VMs
$ResourceGroups = (Get-AzResourceGroup).ResourceGroupName

    foreach ($ResourceGroup in $ResourceGroups) {

# Get a list of all the VMs in the resource group
$vms = Get-AzVM -ResourceGroupName $ResourceGroup

$vms

# Loop through each VM and get the CPU usage for the past 30 days
foreach ($vm in $vms) {
    # Get the name of the VM
    $vmName = $vm.Name

    # Get the resource ID of the VM
    $vmResourceId = $vm.Id

    # Use the Azure Monitor API to get the CPU usage data for the VM
    $cpuUsage = Get-AzMetric -ResourceId $vmResourceId -MetricNames "Percentage CPU" -StartTime $startDate -EndTime $endDate -AggregationType Average -TimeGrain 1.00:00:00 -WarningAction SilentlyContinue


    # Loop through each day of data
    foreach ($day in $cpuUsage.Data) {
        # Get the date for the day
        $date = $day.TimeStamp.ToString('dd/MM/yyyy')
       

        # Get the average CPU usage for the day
        $usage = $day.Average
        $perusage=[math]::round($usage,2)
        # Print the VM name, date, and usage
       
       New-Object -TypeName PsObject -Property @{VMname=$vmname;Date=$date;CPUpercentage=$perusage} | Export-Csv "c:\temp\outputfile.csv" -append -NoTypeInformation


    }
}
}

}

