package day3

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

// 11.....5..*
// ..+........
// ..15....1..
// .......33..
// ....9$.....

// 11, 15, 1, 9 are adjacent to a symbol

var invalidSymbols = map[string]bool{
	"1": true,
	"2": true,
	"3": true,
	"4": true,
	"5": true,
	"6": true,
	"7": true,
	"8": true,
	"9": true,
	"0": true,
	".": true,
}

var nums = map[string]bool{
	"0": true,
	"1": true,
	"2": true,
	"3": true,
	"4": true,
	"5": true,
	"6": true,
	"7": true,
	"8": true,
	"9": true,
}

var regNum = regexp.MustCompile("[0-9]+")

type numInLine struct {
	number    string
	validPart bool
	checked   bool
}

type coordinate struct {
	x int
	y int
}

type checkedNum struct {
	num   string
	xFrom int
	yFrom int
	xTo   int
	yTo   int
}

type partScanner struct {
	preLine     string
	currLine    string
	nextLine    string
	checkedNums map[string]map[coordinate]bool
	curr        int
	next        int
	board       []string
	total       int
	calNums     []string
}

type parts []int

func (ps *partScanner) nextIsSymbol() bool {
	if _, ok := invalidSymbols[string(ps.readByte())]; !ok {
		return true
	}

	return false
}

func (ps *partScanner) previousIsSymbol(numStart int) bool {
	if _, ok := invalidSymbols[string(ps.currLine[numStart-1])]; !ok {
		return true
	}

	return false
}

func (ps *partScanner) parseNum(num string) int {
	int, err := strconv.Atoi(num)
	if err != nil {
		panic(err)
	}

	return int
}

func (ps *partScanner) scanNumberBackwards(currIdx int, currLine string) string {
	var wholeNum string
	for {
		if _, ok := nums[string(currLine[currIdx])]; ok {
			wholeNum += string(currLine[currIdx])

		} else {
			break
		}

		currIdx -= 1
		if currIdx < 0 {
			break
		}
	}

	var reverseNum string
	for i := len(wholeNum) - 1; i >= 0; i-- {
		reverseNum += string(wholeNum[i])
	}

	return reverseNum
}

func (ps *partScanner) scanNumber(currIdx int, currLine string) string {
	var wholeNum string
	for {
		if _, ok := nums[string(currLine[currIdx])]; ok {
			wholeNum += string(currLine[currIdx])
		} else {
			break
		}

		currIdx++
		if currIdx > len(ps.currLine)-1 {
			break
		}
	}

	return wholeNum
}

func (ps *partScanner) move() bool {
	if ps.curr < len(ps.currLine)-1 {
		ps.curr++

		return true
	}

	return false
}

func (ps *partScanner) moveNext() {
	if ps.next < len(ps.currLine) {
		ps.next++
	}
}

func (ps *partScanner) readByte() byte {
	return ps.currLine[ps.curr]
}

func (ps *partScanner) peak() byte {
	return ps.currLine[ps.next]
}

func (ps *partScanner) peakBack() byte {
	return ps.currLine[ps.curr-1]
}

func (ps *partScanner) scanForNums(number string, i int, line string, y, x int) {
	numRange := len(number) + i
	coordMap := map[coordinate]bool{}
	for j := i; j < numRange; j++ {
		coordMap[coordinate{x: j, y: y}] = true
	}

	seen := false
	if num, ok := ps.checkedNums[number]; ok {
		for k := range num {
			if _, ok := coordMap[k]; ok {
				seen = true
				break
			}
		}
	}

	if !seen {
		ps.total += ps.parseNum(number)
		ps.calNums = append(ps.calNums, number)
		ps.checkedNums[number] = coordMap
	}
}

func (ps *partScanner) scanOneLine(line string, y int, x int) {
	var scanTill int
	if x+1 < len(line) {
		scanTill = x + 1
	} else {
		scanTill = x
	}

	for i := x - 1; i <= scanTill; i++ {
		if _, ok := nums[string(line[i])]; ok {
			var peak byte
			if i+1 < len(line) {
				peak = line[i+1]
			} else {
				peak = line[i]
			}

			var backwards byte
			if i-1 > 0 {
				backwards = line[i-1]
			} else {
				backwards = line[i]
			}

			_, forwardOk := nums[string(peak)]
			_, backwardsOk := nums[string(backwards)]
			_, currOk := nums[string(line[i])]

			if forwardOk && backwardsOk {
				b := ps.scanNumberBackwards(i, line)
				c := string(line[i])
				f := ps.scanNumber(i, line)
				number := b[:len(b)-1] + c + f[1:]

				ps.scanForNums(number, i, line, y, i)

			} else if forwardOk {
				number := ps.scanNumber(i, line)
				ps.scanForNums(number, i, line, y, i)
			} else if backwardsOk {
				number := ps.scanNumberBackwards(i, line)
				ps.scanForNums(number, i, line, y, i)
			} else if currOk {
				number := string(line[i])
				ps.scanForNums(number, i, line, y, i)
			}
		}
	}

}

func (ps *partScanner) scanSquare(pos coordinate) {
	// 3 x 3 square
	if ps.preLine != "" {
		ps.scanOneLine(ps.preLine, pos.y-1, pos.x)
	}
	if ps.currLine != "" {
		ps.scanOneLine(ps.currLine, pos.y, pos.x)
	}
	if ps.nextLine != "" {
		ps.scanOneLine(ps.nextLine, pos.y+1, pos.x)
	}
}

func (ps *partScanner) scanLine(line string, y int) {
	ps.curr = -1
	ps.next = 1

	for ps.move() {
		if _, ok := invalidSymbols[string(ps.readByte())]; !ok {
			ps.scanSquare(coordinate{x: ps.curr, y: y})
		}
	}

}

func day3() {
	fileName := "input.txt"
	file, err := os.Open(fileName)
	if err != nil {
		panic(err)
	}

	defer file.Close()

	scanner := bufio.NewScanner(file)
	var lines []string
	var ps partScanner
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	ps.board = lines
	ps.checkedNums = map[string]map[coordinate]bool{}

	for y, line := range ps.board {
		if y != 0 {
			ps.preLine = ps.currLine
		}

		if y+1 < len(ps.board) {
			ps.nextLine = ps.board[y+1]
		} else {
			ps.nextLine = ""
		}
		ps.currLine = line

		ps.scanLine(line, y)
	}

	fmt.Println(ps.total)

	if fileName == "test.txt" {
		fmt.Println(ps.total == 6384)
	}
}
