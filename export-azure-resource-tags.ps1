# Connect to Azure

# Set the tenant ID
$tenantId = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

# Get all subscriptions in the tenant
$subscriptions = Get-AzSubscription -TenantId $tenantId

# Create a new CSV file to store all resource and resource group information
$csv = New-Object System.IO.StreamWriter "c:\temp\Resources.csv"

# Write the header row for the CSV file
$csv.WriteLine("Subscription,Resource Group,Resource,Tags")

# Loop through each subscription
foreach($subscription in $subscriptions)
{
    # Select the subscription as the default
    Select-AzSubscription -SubscriptionName $subscription.Name

    # Get all resource groups in the subscription
    $resourceGroups = Get-AzResourceGroup

    # Loop through each resource group
    foreach($resourceGroup in $resourceGroups)
    {
        # Get all resources in the resource group
        $resources = Get-AzResource -ResourceGroupName $resourceGroup.ResourceGroupName

        # Loop through each resource
        foreach($resource in $resources)
        {
            # Get the tags for the resource
            $tags = $resource.Tags

            # Convert the tags to a string
            $tagsAsString = ""
            if ($null -ne $tags) {
                #$tags.GetEnumerator() | ForEach-Object { $tagsAsString += $_.Key + ":" + $_.Value + ";" + "`n"}
                $tags.GetEnumerator() | ForEach-Object { $tagsAsString += $_.Key + ":" + $_.Value + ";" + " "}
            } else {
                $tagsAsString = "NUll"
            }

            # Write the resource information to the CSV file
            $csv.WriteLine("$($subscription.Name),$($resourceGroup.ResourceGroupName),$($resource.Name),$tagsAsString")
        }
    }
}

# Close the CSV file
$csv.Close()

# Disconnect from Azure

