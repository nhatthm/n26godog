package n26godog

import (
	"context"
	"encoding/json"
	"os"
	"path/filepath"
	"strconv"

	"github.com/cucumber/godog"
	"github.com/google/uuid"
	"github.com/nhatthm/n26api"
	"github.com/nhatthm/n26api/pkg/testkit"
	"github.com/nhatthm/n26api/pkg/transaction"
	"github.com/nhatthm/timeparser"
	"github.com/stretchr/testify/assert"
)

// Server is a wrapper around *testkit.Server to provide support for cucumber/godog.
type Server struct {
	*testkit.Server

	test testkit.TestingT
}

// RegisterContext registers Server to a scenario.
//
// Deprecated: use Server.RegisterSteps instead.
func (s *Server) RegisterContext(sc *godog.ScenarioContext) {
	s.RegisterSteps(sc)
}

// RegisterSteps registers Server to a scenario.
func (s *Server) RegisterSteps(sc *godog.ScenarioContext) {
	sc.After(func(context.Context, *godog.Scenario, error) (context.Context, error) {
		assert.NoError(s.test, s.ExpectationsWereMet())

		s.ResetExpectations()

		return nil, nil
	})

	// Auth.
	sc.Step(`^n26 receives a login request with username "([^"]+)", password "([^"]+)" and device id "([^"]+)" but the credentials is wrong`, s.loginFailureWrongCredentials)
	sc.Step(`^n26 receives a login request with username "([^"]+)", password "([^"]+)" and device id "([^"]+)" but no one confirms login`, s.loginFailureNoConfirmLogin)
	sc.Step(`^n26 receives a success login request with username "([^"]+)", password "([^"]+)" and device id "([^"]+)"`, s.loginSuccess)
	sc.Step(`^n26 receives a refresh token request but the token is invalid`, s.refreshTokenInvalid)
	sc.Step(`^n26 receives a success refresh token request`, s.refreshTokenSuccess)

	// Transactions.
	sc.Step(`^n26 receives a request to find all transactions in between "([^"]+)" and "([^"]+)"(?: with page size ([0-9]+))? and responses:$`, s.findTransactionsInRangeWithResult)
	sc.Step(`^n26 receives a request to find all transactions in between "([^"]+)" and "([^"]+)"(?: with page size ([0-9]+))? and responses with result from file:$`, s.findTransactionsInRangeWithResultFromFile)
}

func (s *Server) loginFailureWrongCredentials(username, password, deviceID string) error {
	device, err := uuid.Parse(deviceID)
	if err != nil {
		return err
	}

	testkit.WithAuthPasswordLoginFailureWrongCredentials(username, password, device)(s.Server)

	return nil
}

func (s *Server) loginFailureNoConfirmLogin(username, password, deviceID string) error {
	device, err := uuid.Parse(deviceID)
	if err != nil {
		return err
	}

	testkit.WithAuthPasswordLoginSuccess(username, password, device)(s.Server)
	testkit.WithAuthMFAChallengeSuccess()(s.Server)
	testkit.WithAuthConfirmLoginFailureInvalidToken(0)(s.Server) // Unlimited times.

	return nil
}

func (s *Server) loginSuccess(username, password, deviceID string) error {
	device, err := uuid.Parse(deviceID)
	if err != nil {
		return err
	}

	testkit.WithAuthSuccess(username, password, device)(s.Server)

	return nil
}

func (s *Server) refreshTokenInvalid() error {
	testkit.WithAuthRefreshTokenFailureInvalidToken()(s.Server)

	return nil
}

func (s *Server) refreshTokenSuccess() error {
	testkit.WithAuthRefreshTokenSuccess()(s.Server)

	return nil
}

func (s *Server) findTransactionsInRangeWithResult(from, to, pageSize string, rawResult *godog.DocString) error {
	return s.findTransactionsInRange(from, to, pageSize, []byte(rawResult.Content))
}

func (s *Server) findTransactionsInRangeWithResultFromFile(from, to, pageSize string, result *godog.DocString) error {
	raw, err := loadBodyFromFile(result.Content)
	if err != nil {
		return err
	}

	return s.findTransactionsInRange(from, to, pageSize, raw)
}

func (s *Server) findTransactionsInRange(from, to, pageSize string, result []byte) error {
	f, t, err := timeparser.ParsePeriod(from, to)
	if err != nil {
		return err
	}

	ps := n26api.DefaultPageSize

	if pageSize != "" {
		ps, err = strconv.ParseInt(pageSize, 10, 64)
		if err != nil {
			return err
		}
	}

	var transactions []transaction.Transaction

	if err := json.Unmarshal(result, &transactions); err != nil {
		return err
	}

	testkit.WithFindAllTransactionsInRange(f, t, ps, transactions)(s.Server)

	return nil
}

// New initiates a new Server.
func New(t testkit.TestingT) *Server {
	return &Server{
		Server: testkit.NewServer(t),
		test:   t,
	}
}

func loadBodyFromFile(filePath string) ([]byte, error) {
	body, err := os.ReadFile(filepath.Clean(filePath))
	if err != nil {
		return nil, err
	}

	return body, nil
}
