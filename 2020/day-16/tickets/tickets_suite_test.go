package tickets_test

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestTickets(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Tickets Suite")
}
