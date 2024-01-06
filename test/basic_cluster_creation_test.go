package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestCreateClusterSuccess(t *testing.T) {
	if testing.Short() {
		t.Skip("skipping test in short mode.")
	}
	testCases := []struct {
		testName                string
		terraformDir            string
		expectedClusterName     string
		expectedVPCConfiguredAs []string
	}{
		{
			"basic-cluster-create-success",
			"../examples/basic",
			"basic-cluster-unit-test-nyc1-cluster",
			[]string{
				"use_specified_vpc:true",
				"allow_create_vpc:true",
				"allow_default_vpc:false",
			},
		},
		{
			"basic-cluster-create-success-with-default-vpc",
			"../examples/basic_with_default_vpc",
			"basic-cluster-default-vpc-unit-test-nyc1-cluster",
			[]string{
				"use_specified_vpc:false",
				"allow_create_vpc:true",
				"allow_default_vpc:true",
			},
		},
	}

	for _, tc := range testCases {
		tc := tc // rebind to scope see: https://www.gopherguides.com/articles/table-driven-testing-in-parallel
		t.Run(tc.testName, func(t *testing.T) {
			t.Parallel()
			doToken, found := os.LookupEnv("DO_TOKEN")
			if !found {
				t.Fatal("DO_TOKEN must be set for unit tests")
			}

			// retryable errors in terraform testing.
			terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
				TerraformDir: tc.terraformDir,
				Vars: map[string]interface{}{
					"do_token": doToken,
				},
			})

			defer terraform.Destroy(t, terraformOptions)

			terraform.InitAndApply(t, terraformOptions)

			output := terraform.Output(t, terraformOptions, "cluster_name")
			assert.Equal(t, tc.expectedClusterName, output)

			output = terraform.Output(t, terraformOptions, "vpc_configured_as")
			for _, expected := range tc.expectedVPCConfiguredAs {
				assert.Contains(t, output, expected, "Should contain `%s`", expected)
			}
		})
	}
}

func TestThatCreateClusterFails(t *testing.T) {
	testCases := []struct {
		testName      string
		terraformDir  string
		expectedError string
	}{
		{
			"given-missing-cluster-name",
			"../examples/errors/missing/name",
			"Invalid value for variable",
		},
		{
			"given-missing-cluster-region",
			"../examples/errors/missing/region",
			"Invalid value for variable",
		},
		{
			"given-missing-cluster-version",
			"../examples/errors/missing/version",
			"Invalid value for variable",
		},
	}
	for _, tc := range testCases {
		tc := tc // rebind to scope see: https://www.gopherguides.com/articles/table-driven-testing-in-parallel
		t.Run(tc.testName, func(t *testing.T) {
			t.Parallel()
			terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
				TerraformDir: tc.terraformDir,
			})
			_, err := terraform.InitAndValidateE(t, terraformOptions)
			assert.Error(t, err)
			if err == nil {
				t.Fatalf("Should fail with `%s`, but did not fail.", tc.expectedError)
			}
			assert.Contains(t, err.Error(), tc.expectedError, "Should fail with `%s`, but failed with `%s`", tc.expectedError, err.Error())
		})
	}
}
