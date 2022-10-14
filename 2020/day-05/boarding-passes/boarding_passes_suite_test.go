package boarding_passes_test

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestBoardingPasses(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "BoardingPasses Suite")
}
