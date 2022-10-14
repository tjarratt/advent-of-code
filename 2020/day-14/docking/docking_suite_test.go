package docking_test

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestDocking(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Docking Suite")
}
