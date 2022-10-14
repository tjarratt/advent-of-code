package conway_cubes_test

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestConwayCubes(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "ConwayCubes Suite")
}
