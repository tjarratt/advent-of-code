package jolted_test

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestJolted(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Jolted Suite")
}
