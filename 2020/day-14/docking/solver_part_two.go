package docking

import (
	"regexp"
	"strconv"
	"strings"
)

func (s solver) V2Solution() int {
	mask := initMask()
	memory := map[int]int{}

	for _, line := range strings.Split(s.input, "\n") {
		if len(line) == 0 {
			continue
		}

		if maskRegex.MatchString(line) {
			mask = updateMaskV2(line)
		} else if memoryRegex.MatchString(line) {
			updateMemoryV2(memory, mask, line)
		}
	}

	result := 0
	for _, value := range memory {
		result += value
	}

	return result
}

func updateMaskV2(line string) []blit {
	pieces := strings.Split(line, " = ")

	newMask := initMask()
	for index, bit := range strings.Split(pieces[1], "") {
		switch bit {
		case "X":
			newMask[len(newMask)-1-index] = floating
		case "1":
			newMask[len(newMask)-1-index] = on
		case "0":
			newMask[len(newMask)-1-index] = off
		}
	}
	return newMask
}

func updateMemoryV2(memory map[int]int, mask []blit, line string) {
	re := regexp.MustCompile("^mem\\[([0-9]+)\\] = ([0-9]+)")
	matches := re.FindStringSubmatch(line)

	addr, _ := strconv.Atoi(matches[1])
	value, _ := strconv.Atoi(matches[2])
	floated_addr := apply_mask_to_address(addr, mask)

	for _, defloated_addr := range all_possible_values(floated_addr) {
		memory[defloated_addr] = value
	}
}

func apply_mask_to_address(addr int, mask []blit) []blit {
	floating_address := make([]blit, len(mask))
	for i, blit := range mask {
		switch blit {
		case floating:
			floating_address[i] = floating
		case on:
			floating_address[i] = on
		case off:
			if addr&(1<<i) != 0 {
				floating_address[i] = on
			} else {
				floating_address[i] = off
			}
		default:
			panic("this should never happen")
		}
	}

	return floating_address
}

func all_possible_values(mask []blit) []int {
	for i, b := range mask {
		if b == floating {
			mask_copy := make([]blit, len(mask))
			copy(mask_copy, mask)

			addrs := []int{}
			mask_copy[i] = on
			addrs = append(addrs, all_possible_values(mask_copy)...)

			mask_copy[i] = off
			addrs = append(addrs, all_possible_values(mask_copy)...)

			// early return to avoid 2^N runtime of address generation
			// where N is the number of floating addresses
			// if we continue the iteration then we generate too much addresses by
			// revisiting the floating bits in OUR mask that are handled by the recursion

			// one helpful way to see this is to note that addresses returned by recusion
			// will already include permutations of later floating bits
			return addrs
		}
	}

	// if we got here it means there are no floating bits in the mask
	// and we can terminate our recursion by evaluating the de-floated address
	result := 0
	for i, b := range mask {
		switch b {
		case on:
			result += (1 << i)
		case off:
			continue
		}
	}

	return []int{result}
}

func noFloatingBlits(mask []blit) bool {
	for _, blit := range mask {
		if blit == floating {
			return false
		}
	}

	return true
}
