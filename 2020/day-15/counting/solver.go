package counting

import (
	"strconv"
	"strings"
)

func NewCountingSolver(input string) *solver {
	return parse(input)
}

type solver struct {
	verbal_history []int
	number_lookup  map[int][]int
}

func (s *solver) Solve() int {
	turn := len(s.verbal_history)

	result := s.nextNumber()

	s.verbal_history = append(s.verbal_history, result)
	s.number_lookup[result] = append(s.number_lookup[result], turn)

	return result
}

func (s *solver) timesSeen(number int) int {
	return len(s.number_lookup[number])
}

func (s *solver) nextNumber() int {
	turn := len(s.verbal_history)
	last_number := s.verbal_history[turn-1]

	if s.timesSeen(last_number) == 1 {
		return 0
	} else {
		verbal_history := s.number_lookup[last_number]
		turn_last_seen := verbal_history[len(verbal_history)-1]
		return turn_last_seen - verbal_history[len(verbal_history)-2]
	}
}

func (s *solver) NumberSpokenAtTurn(turn int) int {
	if turn-1 < len(s.verbal_history) {
		return s.verbal_history[turn-1]
	}

	for index := len(s.verbal_history); index < turn; index++ {
		s.Solve()
	}

	return s.verbal_history[turn-1]
}

// pragma mark - private
func parse(input string) *solver {
	nums := strings.Split(input, ",")
	verbal_history := make([]int, len(nums))
	number_lookup := map[int][]int{}

	for index, nstr := range nums {
		number, err := strconv.Atoi(nstr)
		if err != nil {
			panic(err)
		}
		verbal_history[index] = number
		number_lookup[number] = []int{index}
	}

	return &solver{verbal_history: verbal_history, number_lookup: number_lookup}
}
