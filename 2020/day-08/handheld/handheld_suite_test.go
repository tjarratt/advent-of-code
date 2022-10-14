package handheld_test

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestHandheld(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Handheld Suite")
}
