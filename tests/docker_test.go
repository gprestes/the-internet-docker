package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/docker"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

func TestDockerImage(t *testing.T) {
	tag := "the-internet:docker"

	test_structure.RunTestStage(t, "docker_build", func() {
		buildOptions := &docker.BuildOptions{
			Tags: []string{tag},
			OtherOptions: []string{
				"--pull",
				"--no-cache",
				"-f",
				"../docker/Dockerfile",
			},
		}

		docker.Build(t, "../docker", buildOptions)
	})

	tt := []struct {
		name       string
		entrypoint string
		command    string
		expected   string
	}{
		{name: "test that ruby is installed", entrypoint: "ruby", command: "--version", expected: "2.7.2"},
		{name: "test that VERSION file has the correct version", entrypoint: "cat", command: "VERSION", expected: "0.58.0"},
		{name: "test that bundler is installed", entrypoint: "bundler", command: "--version", expected: "1.17.3"},
	}

	for _, tc := range tt {
		tc := tc
		t.Run(tc.name, func(t *testing.T) {
			t.Parallel()

			opts := &docker.RunOptions{
				Remove: true,

				Entrypoint: tc.entrypoint,

				Command: []string{tc.command},
			}

			output := docker.Run(t, tag, opts)

			assert.Contains(t, output, tc.expected)
		})
	}
}
