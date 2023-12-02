package day2

import (
	"bufio"
	"os"
	"strconv"
	"strings"
)

type cubeStore struct {
	gameId int
	blue   int
	red    int
	green  int
}

type gameStore []cubeStore

func extractColurNum(colourId, colour string) int {
	num, err := strconv.ParseInt(
		strings.TrimSpace(strings.Split(colour, colourId)[0]), 0, 64,
	)

	if err != nil {
		panic("Error parsing colour num")
	}
	return int(num)
}

func extractColours(colours []string, store *cubeStore) {
	for _, colour := range colours {
		noWhiteSpaces := strings.TrimSpace(colour)
		switch {
		case strings.Contains(noWhiteSpaces, "blue"):
			num := extractColurNum("b", noWhiteSpaces)
			if store.blue < num {
				store.blue = num
			}

		case strings.Contains(noWhiteSpaces, "red"):
			num := extractColurNum("r", noWhiteSpaces)
			if store.red < num {
				store.red = num
			}

		case strings.Contains(noWhiteSpaces, "green"):
			num := extractColurNum("g", noWhiteSpaces)
			if store.green < num {
				store.green = num
			}
		default:
			panic("Error parsing colour")
		}
	}
}

func parseGame(game string) cubeStore {
	var store cubeStore
	sliceSpaces := strings.Split(game, " ")
	gameId := strings.Split(sliceSpaces[1], ":")[0]
	id, ok := strconv.ParseInt(gameId, 0, 64)
	if ok != nil {
		panic("Error parsing game id")
	}

	store.gameId = int(id)

	sets := strings.Split(game, ":")[1]
	replaced := strings.Replace(sets, ";", ",", -1)
	colours := strings.Split(replaced, ",")
	extractColours(colours, &store)

	return store
}

// takes string that has a set of colours r,g,b
func game() int {
	var gamesStore gameStore

	file, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}

	defer file.Close()

	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		store := parseGame(scanner.Text())
		gamesStore = append(gamesStore, store)
	}

	var configStore cubeStore
	configStore.red = 12
	configStore.green = 13
	configStore.blue = 14

	var total int
	for _, store := range gamesStore {
		cubeTotal := store.red * store.blue * store.green
		total += cubeTotal
	}
	return total
}
