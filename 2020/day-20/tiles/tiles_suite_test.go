package tiles_test

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestTiles(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Tiles Suite")
}
