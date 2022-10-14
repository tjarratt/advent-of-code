package navigation_test

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestNavigation(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Navigation Suite")
}
