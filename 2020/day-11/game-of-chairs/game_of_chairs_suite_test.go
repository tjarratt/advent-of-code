package game_of_chairs_test

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestGameOfChairs(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "GameOfChairs Suite")
}
