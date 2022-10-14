package bus_scheduler_test

import (
	"testing"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

func TestBusScheduler(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "BusScheduler Suite")
}
