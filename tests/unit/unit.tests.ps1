$DataFile   = Import-PowerShellDataFile .\$($env:repoName).psd1 -ErrorAction SilentlyContinue
$TestModule = Test-ModuleManifest       .\$($env:repoName).psd1 -ErrorAction SilentlyContinue

Describe "$($env:repoName)-Manifest" {
    Context Validation {
        It "[Import-PowerShellDataFile] - $($env:repoName).psd1 is a valid PowerShell Data File" {
            $DataFile | Should Not BeNullOrEmpty
        }

        It "[Test-ModuleManifest] - $($env:repoName).psd1 should pass the basic test" {
            $TestModule | Should Not BeNullOrEmpty
        }

        Import-Module .\$($env:repoName).psd1 -ErrorAction SilentlyContinue
        $Module = Get-Module $($env:repoName) -ErrorAction SilentlyContinue

        'VMNetworkAdapterTeamMapping', 'VMNetworkAdapterSettings', 'VMNetworkAdapterIsolation' | ForEach-Object {
            It "Should have exported the DSC Resource: $_" {
                $_ -in $module.ExportedDSCResources | Should Be $true
            }
        }
    }
}
