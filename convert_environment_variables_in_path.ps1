# This script contains a function that converts any environment variables in a given path into their full paths.

# This function takes the path of a folder as its parameter and converts any environment variables in a given path into their full paths.
# If the paramater contains no environment variables, it will not be changed.
function Convert-EnvironmentVariablesInPath {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    Write-Verbose -Message "Attempting to convert any environment variables to full paths in $Path."

    # Variable declarations.
    [int32]$FirstParseCharacterPosition = 0
    [int32]$SecondParseCharacterPosition = 0
    [string]$ParseCharacter = "%"
    [string]$StartOfPath = ""
    [string]$EnvironmentVariable = ""
    [string]$RestOfPath = ""

    Write-Verbose -Message "Searching for the character that denotes an environment variable ($ParseCharacter)."
    $FirstParseCharacterPosition = $Path.IndexOf($ParseCharacter)

    Write-Verbose -Message "The first occurrence of the environment variable character $ParseCharacter is at position $FirstParseCharacterPosition."

    Write-Verbose -Message "Checking whether the path has an environment variable."
    if ($FirstParseCharacterPosition -ge 0) {

        Write-Verbose -Message "The path contains an environment variable, so convert it to a full path."

        # Get the part of the string before the environment variable character and the part after.
        $StartOfPath = $Path.Substring(0, $FirstParseCharacterPosition)
        $RestOfPath = $Path.Substring($FirstParseCharacterPosition + 1)

        Write-Verbose -Message "Start of path: $StartofPath. Rest of path: $RestOfPath."

        # Separate the rest of the environment variable from the remainder of the path.
        $SecondParseCharacterPosition = $RestOfPath.IndexOf($ParseCharacter)
        $EnvironmentVariable = $RestOfPath.Substring(0, $SecondParseCharacterPosition)
        $RestOfPath = $RestOfPath.Substring($SecondParseCharacterPosition + 1)

        Write-Verbose -Message "Start of path: $StartofPath. Environment variable: $EnvironmentVariable. Rest of path: $RestOfPath."

        # Convert the environment variable into its full path.
        $EnvironmentVariable = [System.Environment]::GetEnvironmentVariable($EnvironmentVariable)

        Write-Verbose -Message "Start of path: $StartofPath. Environment variable: $EnvironmentVariable. Rest of path: $RestOfPath."

        # Combine the pieces to re-create the path with the envionment variable translated.
        $Path = $StartofPath + $EnvironmentVariable + $RestOfPath

        Write-Verbose -Message "Running this function recurisvely in case $Path contains more environment variables."
        $Path = Convert-EnvironmentVariablesInPath -Path $Path

    } else {
    
        Write-Verbose -Message "The path does not contain an environment variable, so leave it as-is."

    }

    Write-Verbose -Message "Return the converted path string."
    return $Path

}