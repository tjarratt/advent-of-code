package luggage

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"
)

type bagSorter struct {
	raw string
}

type Graph struct {
	data map[string]*Node
}

type Node struct {
	name     string
	parents  []capture
	children []capture
}

type capture struct {
	quantity int
	node     *Node
}

func NewBagSorter(input string) bagSorter {
	return bagSorter{raw: input}
}

func debug(graph Graph) {
	for name, node := range graph.data {
		if len(node.parents) == 0 {
			println(name, ": <terminal>")
			println()
			continue
		}

		println(fmt.Sprintf("%s <%p> :", name, node))

		for _, parent := range node.parents {
			println(fmt.Sprintf("\t %s <%p>", parent.node.name, parent.node))
		}
		println()
	}
}

func (sorter bagSorter) BagsWhichCouldContain(name string) []string {
	graph := parse(sorter.raw)
	node := graph.FindNode(name)

	containing_nodes := map[string]bool{}
	walk(node, containing_nodes)

	names := []string{}
	for key := range containing_nodes {
		names = append(names, key)
	}
	return names
}

func (sorter bagSorter) BagsContainedBy(name string) int {
	graph := parse(sorter.raw)
	node := graph.FindNode(name)

	return walkChildren(node, 1)
}

// pragma mark - graph
func (graph Graph) FindNode(node_name string) *Node {
	return graph.data[node_name]
}

func (graph Graph) AddTerminal(name string) {
	node := graph.data[name]
	if node != nil {
		return
	}

	graph.data[name] = &Node{
		name:     name,
		parents:  []capture{},
		children: []capture{},
	}
}

func (graph Graph) Add(parent, child string, quantity int) {
	parent_node := graph.data[parent]
	if parent_node == nil {
		parent_node = &Node{name: parent, parents: []capture{}, children: []capture{}}
		graph.data[parent] = parent_node
	}

	child_node := graph.data[child]
	if child_node == nil {
		child_node = &Node{name: child, parents: []capture{}, children: []capture{}}
		graph.data[child] = child_node
	}

	child_node.parents = append(child_node.parents, capture{
		quantity: quantity,
		node:     parent_node,
	})

	parent_node.children = append(parent_node.children, capture{
		quantity: quantity,
		node:     child_node,
	})
}

func (n *Node) Name() string {
	return n.name
}

func (n *Node) Parents() []*Node {
	nodes := []*Node{}

	for _, parent := range n.parents {
		nodes = append(nodes, parent.node)
	}

	return nodes
}

// pragma mark - private
func walk(node *Node, acc map[string]bool) {
	for _, p := range node.Parents() {
		acc[p.Name()] = true

		walk(p, acc)
	}
}

func walkChildren(node *Node, multiplier int) int {
	total := 0

	for _, child := range node.children {
		total += child.quantity * multiplier
		total += walkChildren(child.node, child.quantity*multiplier)
	}

	return total
}

var line_regexp = regexp.MustCompile("^([a-z ]+) bags contain (.*).$")
var bags_regexp = regexp.MustCompile("([0-9]+) ([a-z ]+) bags?")

func parse(input string) Graph {
	graph := Graph{data: map[string]*Node{}}

	for _, line := range strings.Split(input, "\n") {
		matches := line_regexp.FindStringSubmatch(line)
		if matches == nil {
			continue
		}

		containing_bag := matches[1]
		bag_matches := bags_regexp.FindAllStringSubmatch(matches[2], -1)

		if bag_matches == nil {
			// this is a terminal node
			graph.AddTerminal(containing_bag)
		} else {
			// this bag contains 1 or other bags

			for _, stuff := range bag_matches {
				quantity, _ := strconv.Atoi(stuff[1])
				inner_bag := stuff[2]
				graph.Add(containing_bag, inner_bag, quantity)
			}
		}
	}

	return graph
}
