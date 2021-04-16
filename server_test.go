package n26godog

import (
	"testing"

	"github.com/cucumber/godog"
	"github.com/stretchr/testify/assert"
)

func TestServer_loginFailureWrongCredentials(t *testing.T) {
	t.Parallel()

	s := New(t)

	err := s.loginFailureWrongCredentials("username", "password", "wrong")
	expectedError := `invalid UUID length: 5`

	assert.EqualError(t, err, expectedError)
}

func TestServer_loginFailureNoConfirmLogin(t *testing.T) {
	t.Parallel()

	s := New(t)

	err := s.loginFailureNoConfirmLogin("username", "password", "wrong")
	expectedError := `invalid UUID length: 5`

	assert.EqualError(t, err, expectedError)
}

func TestServer_loginSuccess(t *testing.T) {
	t.Parallel()

	s := New(t)

	err := s.loginSuccess("username", "password", "wrong")
	expectedError := `invalid UUID length: 5`

	assert.EqualError(t, err, expectedError)
}

func TestServer_findTransactionsInRangeWithResultFromFile(t *testing.T) {
	t.Parallel()

	s := New(t)

	err := s.findTransactionsInRangeWithResultFromFile("", "", "", &godog.DocString{Content: "unknown"})
	expectedError := `open unknown: no such file or directory`

	assert.EqualError(t, err, expectedError)
}

func TestServer_findTransactionsInRange(t *testing.T) {
	t.Parallel()

	testCases := []struct {
		scenario      string
		from          string
		to            string
		pageSize      string
		result        []byte
		expectedError string
	}{
		{
			scenario:      "invalid from",
			from:          "foobar",
			expectedError: `parsing time "foobar" as "2006-01-02": cannot parse "foobar" as "2006"`,
		},
		{
			scenario:      "invalid from",
			from:          "2020-01-02T03:04:05Z",
			to:            "foobar",
			expectedError: `parsing time "foobar" as "2006-01-02": cannot parse "foobar" as "2006"`,
		},
		{
			scenario:      "invalid page size",
			from:          "2020-01-02T03:04:05Z",
			to:            "2020-01-03T04:05:06Z",
			pageSize:      "foobar",
			expectedError: `strconv.ParseInt: parsing "foobar": invalid syntax`,
		},
		{
			scenario:      "invalid result",
			from:          "2020-01-02T03:04:05Z",
			to:            "2020-01-03T04:05:06Z",
			result:        []byte(`{`),
			expectedError: `unexpected end of JSON input`,
		},
	}

	for _, tc := range testCases {
		tc := tc
		t.Run(tc.scenario, func(t *testing.T) {
			t.Parallel()

			s := New(t)
			err := s.findTransactionsInRange(tc.from, tc.to, tc.pageSize, tc.result)

			assert.EqualError(t, err, tc.expectedError)
		})
	}
}
