package day1

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

var digits = map[string]int64{
	"one":   1,
	"two":   2,
	"three": 3,
	"four":  4,
	"five":  5,
	"six":   6,
	"seven": 7,
	"eight": 8,
	"nine":  9,
}

func parseLine(line string) (int64, error) {
	var first string
	var second string
	var currFinal string
	var num string

	for i := 0; i < len(line); i++ {
		num = ""
		c := strings.ToLower(string(line[i]))
		if _, err := strconv.ParseInt(c, 0, 64); err == nil {
			num = c
		} else {
			if len(line)-1 >= i+2 {
				if val, ok := digits[line[i:i+3]]; ok {
					num = fmt.Sprintf("%d", val)
					i += 1
				}
			}

			if len(line)-1 >= i+3 && num == "" {
				if val, ok := digits[line[i:i+4]]; ok {
					num = fmt.Sprintf("%d", val)
					i += 2
				}
			}

			if len(line)-1 >= i+4 && num == "" {
				if val, ok := digits[line[i:i+5]]; ok {
					num = fmt.Sprintf("%d", val)
					i += 3
				}
			}

		}
		if num != "" {
			if first == "" {
				first = num
				currFinal = num
			}

			currFinal = num
		}

	}

	second = currFinal

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

	defer file.Close()

	var toSolve []string
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		toSolve = append(toSolve, scanner.Text())
	}

	res, err := calcTotal(toSolve)
	if err != nil {
		panic(err)
	}

	fmt.Println(res)
}
