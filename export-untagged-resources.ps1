# Set the tenant ID
$tenantId = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

# Get all subscriptions in the tenant
$subscriptions = Get-AzSubscription -TenantId $tenantId

foreach($subscription in $subscriptions)
{


 $Path = "c:\temp"

# Create an array to store the untagged resources
$untaggedResources = @()

# Get all resource groups in the subscription
$resourceGroups = Get-AzResourceGroup

# Iterate through each resource group
foreach ($resourceGroup in $resourceGroups) {
    # Get all resources in the resource group
    $resources = Get-AzResource -ResourceGroupName $resourceGroup.ResourceGroupName

    # Iterate through each resource
    foreach ($resource in $resources) {
        # Check if the resource has no tags
        if ([string]::IsNullOrEmpty($resource.Tags)) {
            # Add the resource to the untagged resources array
            $untaggedResources += $resource
        }
    }
}

# Print the number of untagged resources
Write-Output "Number of untagged resources: $($untaggedResources.Count)"


$untaggedResources | Select-Object -Property Name, Resourcegroupname, Resourcetype, Tags | Export-Csv -path "$Path\$subscription-untaggedresources.csv" -NoTypeInformation 


}
