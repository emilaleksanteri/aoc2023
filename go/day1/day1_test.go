package day1

import (
	"testing"
)

func TestParseLine(t *testing.T) {
	tests := []struct {
		input    string
		expected int64
	}{
		{"1abc2", 12},
		{"pqr3stu8vwx", 38},
		{"a1b2c3d4e5f", 15},
		{"treb7uchet", 77},
		{"two1nine", 29},
		{"one2three", 13},
		{"four5six", 46},
		{"4nineeightseven2", 42},
		{"7pqrstsixteen", 76},
		{"two1nine", 29},
		{"eightwothree", 83},
		{"abcone2threexyz", 13},
		{"xtwone3four", 24},
		{"4nineeightseven2", 42},
		{"zoneight234", 14},
		{"7pqrstsixteen", 76},
		{"one", 11},
		{"two", 22},
		{"three", 33},
		{"four", 44},
		{"five", 55},
		{"six", 66},
		{"seven", 77},
		{"eight", 88},
		{"nine", 99},
		{"838mjxsleightnine", 89},
		{"seven4ninefivefourhxplgzfvsevenbbdjqc", 77},
		{"five2sixfourcjfvnmhrxrtwovhrdrfrssphgtcqthhzxh", 52},
		{"tpvoneight1sixjzkrtjcbpkxgvnccxvxbglhhgsevenkchhvchz", 17},
		{"5mnhgg", 55},
		{"sixseve", 66},
		{"heightseven4two5", 85},
		{"959eight3two", 92},
		{"sixpmvlkkdjf3frr91", 61},
		{"4fhcmhdtfourlzdphfxvlmvm6", 46},
		{"9threehmbt5", 95},
		{"9plgm", 99},
		{"eighthree", 83},
		{"eightwothree", 83},
		{"abcone2threexyz", 13},
		{"twone", 21},
		{"eightwo", 82},
		{"eighthree", 83},
		{"fiveight", 58},
		{"fivethree8sevenone", 51},
		{"prqr1krjgkllqrdmjbdjnvvc", 11},
		{"tonenine9nine", 19},
		{"2onefivenrsgzpdzgjztpzpmeighteightttdfkgtkvltl", 28},
		{"1", 11},
		{"26", 26},
		{"45fourmxzqzmpsixr3", 43},
	}

	for _, test := range tests {
		actual, err := parseLine(test.input)

		if err != nil {
			t.Errorf("parseLine(%v) returned error %v", test.input, err)
		}

		if actual != test.expected {
			t.Errorf("parseLine(%v) = %v, expected %v", test.input, actual, test.expected)
		}
	}
}

func TestCalcTotal(t *testing.T) {
	return
	tests := []struct {
		input    []string
		expected int64
	}{
		{[]string{
			"1abc2",
			"pqr3stu8vwx",
			"a1b2c3d4e5f",
			"treb7uchet",
			"two1nine",
			"one2three",
			"four5six",
			"4nineeightseven2",
			"7pqrstsixteen",
		}, 348},
		{[]string{
			"two1nine",
			"eightwothree",
			"abcone2threexyz",
			"xtwone3four",
			"4nineeightseven2",
			"zoneight234",
			"7pqrstsixteen",
		}, 281},
	}

	for _, test := range tests {
		actual, err := calcTotal(test.input)

		if err != nil {
			t.Errorf("calcTotal(%v) returned error %v", test.input, err)
		}

		if actual != test.expected {
			t.Errorf("calcTotal(%v) = %v, expected %v", test.input, actual, test.expected)
		}
	}
}

func TestMain(t *testing.T) {
	Run()
}
