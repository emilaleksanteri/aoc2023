package day5

import (
	"bufio"
	"fmt"
	"os"
	"slices"
	"strconv"
	"strings"
)

var possibleNumStart = []string{"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}

type seed = []int
type seed2 = []rng

type soildMapRow struct {
	destRangeStart int
	destRangeEnd   int
	srcRangeStart  int
	srcRangeEnd    int
	rangeLen       int
	addKey         int
}

type rng struct {
	start int
	end   int
}

type soilMap struct {
	title        string
	translateMap map[rng]soildMapRow // if key not here then relation is 1:1, made out of rows
}

type maps []soilMap

func parseInt(str string) int {
	int, err := strconv.Atoi(str)
	if err != nil {
		panic(err)
	}

	return int
}

func parseMapRow(row string) soildMapRow {
	newRow := soildMapRow{}
	codes := strings.Split(row, " ")
	for i := 0; i < len(codes); i++ {
		code := parseInt(codes[i])
		if i == 0 {
			newRow.destRangeStart = code
		} else if i == 1 {
			newRow.srcRangeStart = code
		} else {
			newRow.rangeLen = code
		}
	}

	newRow.destRangeEnd = newRow.destRangeStart + newRow.rangeLen - 1
	newRow.srcRangeEnd = newRow.srcRangeStart + newRow.rangeLen - 1
	newRow.addKey = newRow.destRangeStart - newRow.srcRangeStart

	return newRow
}

func (s *soilMap) parseMap(rows []string) {
	for _, row := range rows {
		if slices.Contains(possibleNumStart, string(row[0])) {
			mapRow := parseMapRow(row)
			rng := rng{mapRow.srcRangeStart, mapRow.srcRangeEnd}
			s.translateMap[rng] = mapRow
		} else {
			s.title = strings.Split(row, " map")[0]
		}
	}
}

func (s *soilMap) translate(input int) int {
	for rng, row := range s.translateMap {
		if input >= rng.start && input <= rng.end {
			return row.addKey + input
		}
	}

	return input
}

func solve(lines []string, seeds seed) int {
	maps := maps{}
	currMapLines := []string{}
	for _, line := range lines {
		if line == "" {
			currMap := soilMap{}
			currMap.translateMap = make(map[rng]soildMapRow)
			currMap.parseMap(currMapLines)
			maps = append(maps, currMap)
			currMapLines = []string{}
		} else {
			currMapLines = append(currMapLines, line)
		}
	}

	var finals []int
	for _, seed := range seeds {
		first := true
		num := 0
		for _, m := range maps {
			if first {
				num = m.translate(seed)
				first = false
			} else {
				num = m.translate(num)
			}
		}
		finals = append(finals, num)
		first = true
	}

	return slices.Min(finals)
}

func translateSeed(seed int, maps maps) int {
	first := true
	num := 0
	for _, m := range maps {
		if first {
			num = m.translate(seed)
			first = false
		} else {
			num = m.translate(num)
		}
	}

	return num
}

func translateSeed2(seed int, maps maps) int {
	first := true
	num := 0
	for _, m := range maps {
		changed := false
		for rng, row := range m.translateMap {
			if seed >= rng.start && seed <= rng.end && first {
				num = row.addKey + seed
				first = false
				changed = true
				break
			} else if num >= rng.start && num <= rng.end && !first {
				num = row.addKey + num
				changed = true
				break
			}
		}
		if !changed {
			if first {
				num = seed
			}
		}
	}

	return num
}

func solve2(lines []string, seeds seed2) int {
	maps := maps{}
	currMapLines := []string{}
	for _, line := range lines {
		if line == "" {
			currMap := soilMap{}
			currMap.translateMap = make(map[rng]soildMapRow)
			currMap.parseMap(currMapLines)
			maps = append(maps, currMap)
			currMapLines = []string{}
		} else {
			currMapLines = append(currMapLines, line)
		}
	}

	lowest := int(^uint(0) >> 1)

	for _, seed := range seeds {
		m := maps[0]
		for rng, vals := range m.translateMap {
			if seed.start >= rng.start && seed.end+seed.start <= rng.end {
				for i := 0; i < seed.end; i++ {
					num := i + seed.start + vals.addKey
					calNum := translateSeed2(num, maps[1:])
					if calNum < lowest {
						lowest = calNum
					}
				}
			}
		}
	}

	return lowest
}

func parseSeeds(seedsStr string) seed {
	seeds := strings.Split(seedsStr, " ")
	newSeed := seed{}
	for _, seed := range seeds {
		newSeed = append(newSeed, parseInt(seed))
	}

	return newSeed
}

func parseSeeds2(seedsStr string) seed2 {
	seeds := strings.Split(seedsStr, " ")
	newSeed := seed2{}
	startNum := 0
	for i, seed := range seeds {
		if (i+1)%2 == 0 {
			rng := rng{startNum, parseInt(seed)}
			newSeed = append(newSeed, rng)
		} else {
			startNum = parseInt(seed)
		}
	}

	return newSeed
}

func Day5() {
	fileName := "input.txt"
	file, err := os.Open(fileName)
	if err != nil {
		panic(err)
	}

	defer file.Close()

	scanner := bufio.NewScanner(file)
	var seeds seed
	var seeds2 seed2
	lines := []string{}
	line := 0
	for scanner.Scan() {
		if line == 0 {
			seeds = parseSeeds(strings.Split(scanner.Text(), ": ")[1])
			seeds2 = parseSeeds2(strings.Split(scanner.Text(), ": ")[1])
		} else if line > 1 {
			lines = append(lines, scanner.Text())
		}

		line++
	}

	minNum := solve(lines, seeds)
	minNum2 := solve2(lines, seeds2)
	fmt.Println(minNum)
	fmt.Println(minNum2)
}
