package test

import (
	http "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"log"
	"testing"
	"time"
)

func TestTerraformBasicExample(t *testing.T) {
	// GIVEN the following tf resources
	terraformOptions := infrastructureOptions(t)
	// WHEN we apply them
	terraform.InitAndApply(t, terraformOptions)
	// THEN an http server returning hello world is provisioned
	validateHttpServer(t, terraformOptions)
}

func infrastructureOptions(t *testing.T) *terraform.Options {
	t.Parallel()
	terraformOptions := &terraform.Options{
		TerraformDir: "../basic-infra",
		Vars:         map[string]interface{}{},
		VarFiles:     []string{"varfile.tfvars"},
		NoColor:      true,
	}
	defer terraform.Destroy(t, terraformOptions)
	return terraformOptions
}

func validateHttpServer(t *testing.T, opts *terraform.Options) {
	const timeout = 5 * time.Second
	assert.NotNil(t, terraform.Output(t, opts, "ip"))

	url := "http://" + terraform.Output(t, opts, "ip") + ":8080"
	http.HttpGetWithRetry(t, url, nil, 200,
		"Hello, World", 10, timeout)
	log.Print("Http server is up and running")
}
