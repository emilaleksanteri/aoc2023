package day1

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"unicode"
)

func parseLine(line string) (int64, error) {
	var first string
	var second string

	for _, c := range line {
		if unicode.IsNumber(c) {
			first = fmt.Sprintf("%v", (c - '0'))
			break
		}
	}

	for i := len(line) - 1; i >= 0; i-- {
		if unicode.IsNumber(rune(line[i])) {
			second = fmt.Sprintf("%v", (line[i] - '0'))
			break
		}
	}

	final := first + second
	return strconv.ParseInt(final, 0, 64)
}

func calcTotal(input []string) (int64, error) {
	var total int64

	for _, line := range input {
		num, err := parseLine(line)
		if err != nil {
			return 0, err
		}
		total += num
	}

	return total, nil
}

func Run() {
	file, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}

	var toSolve []string

	defer file.Close()
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		input := scanner.Text()
		toSolve = append(toSolve, input)
	}

	res, err := calcTotal(toSolve)
	if err != nil {
		panic(err)
	}

	fmt.Println(res)
}
