# This script reads in a list of folders containing temporary files and attempts to delete their contents.

# This function takes the path of a folder as its parameter and attempts to delete it.
function Remove-EverythingInFolder {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$FolderPath
    )

    Write-Output "Attempting to empty folder $FolderPath."
    
    Write-Verbose -Message "Checking if folder $FolderPath exists."
    if (Test-Path -Path $FolderPath) {
        
        Write-Verbose -Message "The folder $FolderPath exists."

        Write-Verbose -Message "Checking if $FolderPath contains this script, which we don't want to delete!"
        if ($FolderPath.ToUpper() -eq $PSScriptRoot.ToUpper()) {

            Write-Output "ERROR: The folder $FolderPath contains this script and cannot be emptied without moving the script!"

        } else {

            Write-Verbose -Message "The folder $FolderPath does not contain this script, so we will proceed."

            Write-Verbose -Message "Deleting all files and folders in $FolderPath."
            Remove-Item $FolderPath\* -Recurse -Force

            Write-Verbose -Message "Checking how many items are still in the folder to tell if it's empty."
            
            # Get the number of items left in the folder.
            [int32]$NumberItemsInFolder = (Get-ChildItem $FolderPath | Measure-Object).Count
            
            # Check if it's zero.
            if ($NumberItemsInFolder -eq 0) {
                
                Write-Output "Folder $FolderPath has been emptied."
            
            } else {

                Write-Output "Folder $FolderPath has $NumberItemsInFolder items remaining. Check if you have permission to empty it."

            }         

        }


    } else {

        Write-Output "ERROR: The folder $FolderPath does not exist!"

    }

}


# This is the body of the script. It reads the list of folders and uses a method to try to empty each one. 

Write-Verbose -Message "Reading the list of folders to empty into a array."
$Folders_To_Empty = Get-Content "Folders_To_Empty.txt" | Where-Object { $_.Trim() -ne '' }

Write-Verbose -Message "Trying to empty each folder in the array."
foreach ($Folder in $Folders_To_Empty) {
    
    Write-Verbose -Message "If the path has any environment variables, convert them to their full path values."
    $Folder = Convert-EnvironmentVariablesInPath($Folder)

    Write-Verbose -Message "Call a helper function to empty the folder if it exists."
    Remove-EverythingInFolder $Folder

}