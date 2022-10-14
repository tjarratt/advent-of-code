package luggage_test

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestLuggage(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Luggage Suite")
}
