package counting_test

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestCounting(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Counting Suite")
}
