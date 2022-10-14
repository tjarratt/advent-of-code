package jolted

import (
	"sort"
	"strconv"
	"strings"
)

type adapterChain struct {
	adapters []adapter
}

type adapter struct {
	jolts int
}

func ChainedJoltageAdapters(raw string) adapterChain {
	return adapterChain{adapters: parse(raw)}
}

func (chain adapterChain) DifferencesOfJolts(quantity int) int {
	count := 0

	current := chain.adapters[0]
	for _, next := range chain.adapters[1:] {
		if (next.jolts - current.jolts) == quantity {
			count += 1
		}

		current = next
	}

	return count
}

func (chain adapterChain) CountValidCombinations() int {
	counter := 0
	mapp := map[int]int{}
	current := chain.adapters[0]

	for index := 1; index < len(chain.adapters); index++ {
		if chain.adapters[index].jolts-current.jolts == 1 {
			counter += 1
		} else {
			mapp[counter] += 1
			counter = 0
		}

		current = chain.adapters[index]
	}

	result := 1
	result *= pow(mapp[7], 44)
	result *= pow(mapp[6], 24)
	result *= pow(mapp[5], 13)
	result *= pow(mapp[4], 7)
	result *= pow(mapp[3], 4)
	result *= pow(mapp[2], 2)

	return result
}

func pow(power int, base int) int {
	if power == 0 {
		return 1
	}

	result := base
	for i := 1; i < power; i++ {
		result *= base
	}

	return result
}

// pragma mark - private
func countRecursiveCombinations(chain []adapter) int {
	if len(chain) == 2 {
		return 1
	}

	total := 1
	current := chain[0]
	for index := 2; index < len(chain); index++ {
		if chain[index].jolts-current.jolts > 3 {
			current = chain[index-1]
			continue
		}

		// construct a new chain by removing the link between these two
		newChain := append([]adapter{current}, chain[index:]...)
		total += countRecursiveCombinations(newChain)

		current = chain[index-1]
	}

	return total
}

func parse(input string) []adapter {
	lines := strings.Split(input, "\n")
	charges := []int{}
	for _, line := range lines {
		if len(line) == 0 {
			continue
		}

		charge, err := strconv.Atoi(line)
		if err != nil {
			panic(err)
		}

		charges = append(charges, charge)
	}

	sort.Slice(charges, func(i, j int) bool {
		return charges[i] < charges[j]
	})

	// wall outlet has effective jolts of 0
	adapters := []adapter{adapter{jolts: 0}}

	for _, charge := range charges {
		adapter := adapter{jolts: charge}
		adapters = append(adapters, adapter)
	}

	// always add one for the handheld
	adapters = append(adapters, adapter{jolts: adapters[len(adapters)-1].jolts + 3})

	return adapters
}
