package calculator

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"
)

func Solve(input string) int {
	expression := parse(strings.Split(input, ""))

	return calculate(expression)
}

func SolveAdvanced(input string) int {
	return calculate_advanced(parse_advanced(strings.Split(input, "")))
}

func calculate(expr *expression) int {
	leftValue := read_value_from(expr.left)
	if expr.operand == undef {
		return leftValue
	}

	rightValue := read_value_from(expr.right)

	var result int
	if expr.operand == add {
		result = leftValue + rightValue
	} else if expr.operand == multiply {
		result = leftValue * rightValue
	} else {
		panic(fmt.Sprintf("Unexpected operator '%s'", expr.operand))
	}

	thunk := expr.right.(*expression)
	thunk.left = result

	return calculate(thunk)
}

func calculate_advanced(input []interface{}) int {
	step_1 := make([]interface{}, 0)

	// recurse and evaluate any nested groups
	for _, item := range input {
		if as_slice, ok := item.([]interface{}); ok {
			step_1 = append(step_1, calculate_advanced(as_slice))
		} else {
			step_1 = append(step_1, item)
		}
	}

	step_2 := make([]interface{}, 0)
	for index := 0; index < len(step_1); {
		item := step_1[index]
		index += 1

		if item == add_str {
			// pop off last item
			var previous interface{}
			previous, step_2 := step_2[len(step_2)-1], step_2[:len(step_2)-1]

			// read next
			next := step_1[index]
			index += 1

			// store result
			step_2 = append(step_2, previous.(int)+next.(int))
		} else if item == multiply_str {
			continue
		} else {
			step_2 = append(step_2, item)
		}
	}

	result := 1
	for _, item := range step_2 {
		result = result * item.(int)
	}

	return result
}

func read_value_from(blackbox interface{}) int {
	if as_int, ok := blackbox.(int); ok {
		return as_int
	} else if as_expr, ok := blackbox.(*expression); ok {
		return read_value_from(as_expr.left)
	} else if as_group, ok := blackbox.(*group); ok {
		return calculate(as_group.root)
	}

	panic(fmt.Sprintf("unexpected type: %T", blackbox))
}

// pragma mark -- debug
func debug(expr *expression) string {
	str := fmt.Sprintf("%#v ", expr.left)
	str += expr.operand.String() + " "

	for next := expr.right.(*expression); next.left != nil; next = next.right.(*expression) {
		if as_expr, ok := next.left.(*expression); ok {
			str += fmt.Sprintf("%s %s", debug(as_expr), next.operand.String())
		} else if as_group, ok := next.left.(*group); ok {
			str += fmt.Sprintf("( %s)", debug(as_group.root))
		} else {
			str += fmt.Sprintf("%#v %s ", next.left, next.operand.String())
		}
	}

	return str
}

func (o operator) String() string {
	switch o {
	case add:
		return "+"
	case multiply:
		return "*"
	default:
		return ""
	}
}

// pragma mark - parsing
//
var integer_expression = regexp.MustCompile("[0-9]")

func parse_advanced(pieces []string) []interface{} {
	result := []interface{}{}

	for index := 0; index < len(pieces); {
		piece := pieces[index]
		index++

		if piece == " " || len(piece) == 0 {
			continue
		}
		if integer_expression.MatchString(piece) {
			as_int, _ := strconv.Atoi(piece)
			result = append(result, as_int)
		} else if piece == "+" {
			result = append(result, add_str)
		} else if piece == "*" {
			result = append(result, multiply_str)
		} else if piece == "(" {
			closing_paren_index := find_balanced_parens(pieces, index)
			sub_slice := pieces[index : closing_paren_index-1]
			index = closing_paren_index + 1
			result = append(result, parse_advanced(sub_slice))
		} else {
			panic(fmt.Sprintf("Unexpected token: %s", piece))
		}
	}

	return result
}

func find_balanced_parens(pieces []string, index int) int {
	parens_count := 1

	for parens_count > 0 {
		if pieces[index] == "(" {
			parens_count += 1
		} else if pieces[index] == ")" {
			parens_count -= 1
		}

		index += 1
	}

	return index
}

func parse(pieces []string) *expression {
	tmp := &expression{}
	root := expression{
		left:    0,
		operand: add,
		right:   tmp,
	}

	index := 0

	for index < len(pieces) {
		var leftVal interface{}
		var op operator

		if pieces[index] == " " {
			index++
			continue
		}

		if integer_expression.MatchString(pieces[index]) {
			leftVal, _ = strconv.Atoi(pieces[index])
			index += 2 // consume left val AND whitespace

			if index < len(pieces) {
				op = operand_at_index(pieces, index)
				index++
			}

		} else if pieces[index] == "(" {
			var new_index int
			leftVal, new_index = parse_parens(pieces, index)
			index = new_index

			if index < len(pieces) && pieces[index] == " " {
				index += 1
			}

			if index < len(pieces) {
				op = operand_at_index(pieces, index)
				index++
			}
		} else {
			panic(fmt.Sprintf("unexpected value '%s'", pieces[index]))
		}

		new_tmp := &expression{}

		tmp.left = leftVal
		tmp.operand = op
		tmp.right = new_tmp

		tmp = new_tmp
	}

	return &root
}

func parse_parens(pieces []string, start int) (*group, int) {
	index := start + 1
	parens_count := 1

	for parens_count > 0 {
		if pieces[index] == "(" {
			parens_count += 1
		} else if pieces[index] == ")" {
			parens_count -= 1
		}

		index += 1
	}

	return &group{root: parse(pieces[start+1 : index-1])}, index
}

func operand_at_index(pieces []string, index int) operator {
	raw := pieces[index]

	if raw == "+" {
		return add
	}
	if raw == "*" {
		return multiply
	}

	panic(fmt.Sprintf("unknown operand '%s' at index %d", raw, index))
}

// pragma mark - type declarations
type expression struct {
	left    interface{}
	operand operator
	right   interface{}
}

type group struct {
	root *expression
}

type operator int

const (
	undef operator = iota
	add
	multiply
)

var add_str string = "+"
var multiply_str string = "*"
