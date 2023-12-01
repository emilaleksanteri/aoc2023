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
	tests := []struct {
		input    []string
		expected int64
	}{
		{[]string{"1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet"}, 142},
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
