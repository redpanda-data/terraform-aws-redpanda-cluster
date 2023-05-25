package tests

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

var AwsSecretAccessKey = os.Getenv("AWS_SECRET_ACCESS_KEY")
var AwsAccessKeyId = os.Getenv("AWS_ACCESS_KEY_ID")

func TestTerraformPlan(t *testing.T) {
	tests := []struct {
		Name      string
		Directory string
	}{
		{
			Name:      "simple",
			Directory: "simple",
		},
		{
			Name:      "tiered_storage",
			Directory: "tiered_storage",
		},
	}

	// Run each test case in the list.
	for _, test := range tests {
		t.Run(test.Name, func(t *testing.T) {
			terraformOptions := &terraform.Options{
				// The path to where our Terraform code is located
				TerraformDir: fmt.Sprintf("../examples/%s", test.Directory),
				EnvVars: map[string]string{
					"AWS_ACCESS_KEY_ID":     AwsAccessKeyId,
					"AWS_SECRET_ACCESS_KEY": AwsSecretAccessKey,
				},
			}

			terraform.InitAndPlan(t, terraformOptions)
		})
	}
}
