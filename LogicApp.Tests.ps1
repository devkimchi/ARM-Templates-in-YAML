#
# This tests whether the ARM template for Logic App has been properly deployed or not.
#

Param(
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
    [string] [Parameter(Mandatory=$true)] $SrcDirectory
)

Describe "Logic App Deployment Tests" {
    # Init
    BeforeAll {
    }

    # Teardown
    AfterAll {
    }

    # Tests whether the cmdlet returns value or not.
    Context "When Logic App deployed with parameters" {
        $output = az group deployment validate `
            -g $ResourceGroupName `
            --template-file $SrcDirectory\azuredeploy.json `
            --parameters `@$SrcDirectory\azuredeploy.parameters.json `
            | ConvertFrom-Json
        
        $result = $output.properties

        It "Should be deployed successfully" {
            $result.provisioningState | Should -Be "Succeeded"
        }

        It "Should have state of" {
            $expected = "Enabled"
            $resource = $result.validatedResources[0]

            $resource.properties.state | Should -Be $expected
        }

        It "Should have name of" {
            $expected = "my-logic-app"
            $resource = $result.validatedResources[0]

            $resource.name | Should -Be $expected
        }
    }
}
