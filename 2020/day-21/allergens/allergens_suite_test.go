package allergens_test

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestAllergens(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Allergens Suite")
}
