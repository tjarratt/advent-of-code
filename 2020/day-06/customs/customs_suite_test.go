package customs_test

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestCustoms(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Customs Suite")
}
