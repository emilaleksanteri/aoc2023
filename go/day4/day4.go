package day4

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type card struct {
	cardId       int
	nums         map[int]int
	winning      map[int]int
	winningTotal int
	winningCards int
}

type cards []card
type cardCopies struct {
	copies map[int]int // cardId, num of copies
}

func (c *card) parseWinning(copies *cardCopies) {
	winningNums := 0
	for _, num := range c.winning {
		if _, ok := c.nums[num]; ok {
			if winningNums == 0 {
				c.winningTotal += 1
			} else {
				c.winningTotal *= 2
			}
			c.winningCards += 1

			winningNums += 1
		}
	}

	var copiesOfMe int
	if _, ok := copies.copies[c.cardId]; ok {
		copies.copies[c.cardId] += 1
		copiesOfMe = copies.copies[c.cardId]
	} else {
		copies.copies[c.cardId] = 1
		copiesOfMe = 1
	}

	if c.winningCards != 0 {
		for id := 1; id <= c.winningCards; id++ {
			idToAdd := id + c.cardId
			if _, ok := copies.copies[idToAdd]; ok {
				copies.copies[idToAdd] += copiesOfMe
			} else {
				copies.copies[idToAdd] = copiesOfMe
			}
		}
	}
}

func stringArrToNumMap(arr []string) map[int]int {
	nums := make(map[int]int)
	for _, num := range arr {
		if num != "" {
			n, err := strconv.Atoi(strings.TrimSpace(num))
			if err != nil {
				panic(err)
			}
			nums[n] = n
		}
	}

	return nums
}

func parseToCards(line string) card {
	c := card{}
	c.nums = make(map[int]int)
	c.winning = make(map[int]int)
	splitById := strings.Split(line, ":")
	cardId, err := strconv.Atoi(strings.TrimSpace(strings.Split(splitById[0], "Card")[1]))
	if err != nil {
		panic(err)
	}

	c.cardId = cardId

	splitNumsWinning := strings.Split(splitById[1], "|")

	c.nums = stringArrToNumMap(strings.Split(splitNumsWinning[0], " "))
	c.winning = stringArrToNumMap(strings.Split(splitNumsWinning[1], " "))

	return c
}

func day4() {
	fileName := "input.txt"
	file, err := os.Open(fileName)
	if err != nil {
		panic(err)
	}

	defer file.Close()

	scanner := bufio.NewScanner(file)
	var lines []string
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	cards := make(cards, len(lines))
	cardCopies := cardCopies{copies: make(map[int]int)}
	totalPoints := 0
	totalCards := 0
	for i, line := range lines {
		cards[i] = parseToCards(line)
		cards[i].parseWinning(&cardCopies)
		totalPoints += cards[i].winningTotal
	}

	for _, copies := range cardCopies.copies {
		totalCards += copies
	}

	fmt.Printf("total points: %v\n", totalPoints)
	fmt.Printf("total cards: %v\n", totalCards)
}
