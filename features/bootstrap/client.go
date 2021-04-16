package bootstrap

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/cucumber/godog"
	"github.com/google/uuid"
	"github.com/nhatthm/n26api"
	"github.com/nhatthm/n26api/pkg/transaction"
	"github.com/nhatthm/timeparser"
	"github.com/swaggest/assertjson"
)

type client struct {
	uri string
	api *n26api.Client
}

func (c *client) registerContext(ctx *godog.ScenarioContext) {
	ctx.AfterScenario(func(*godog.Scenario, error) {
		c.api = nil
	})

	ctx.Step(`create a n26 client with username "([^"]+)", password "([^"]+)" and device id "([^"]+)"`, c.newAPIClient)

	ctx.Step(`^I find all transactions in between "([^"]+)" and "([^"]+)" and get an error:`, c.findAllTransactionsInRangeError)
	ctx.Step(`^I find all transactions in between "([^"]+)" and "([^"]+)" and receive:`, c.findAllTransactionsInRangeSuccess)
}

func (c *client) newAPIClient(username, password, deviceStr string) error {
	device, err := uuid.Parse(deviceStr)
	if err != nil {
		return err
	}

	c.api = n26api.NewClient(
		n26api.WithBaseURL(c.uri),
		n26api.WithDeviceID(device),
		n26api.WithCredentials(username, password),
		n26api.WithMFAWait(5*time.Millisecond),
		n26api.WithMFATimeout(50*time.Millisecond),
	)

	return nil
}

func (c *client) findAllTransactionsInRange(from, to string) ([]transaction.Transaction, error) {
	start, err := timeparser.Parse(from)
	if err != nil {
		return nil, err
	}

	end, err := timeparser.Parse(to)
	if err != nil {
		return nil, err
	}

	return c.api.FindAllTransactionsInRange(context.Background(), start, end)
}

func (c *client) findAllTransactionsInRangeError(from, to string, expectedError *godog.DocString) error {
	result, err := c.findAllTransactionsInRange(from, to)
	if err == nil {
		return errors.New("error is expected") // nolint: goerr113
	}

	if result != nil {
		raw, err := json.Marshal(result)
		if err != nil {
			return errors.New("could not marshal the unexpected result") // nolint: goerr113
		}

		return fmt.Errorf("unexpected result: %q", string(raw)) // nolint: goerr113
	}

	expected := expectedError.Content
	actual := err.Error()

	if expected != actual {
		// nolint: goerr113
		return fmt.Errorf("error message not equal:\n"+
			"expected: %q\n"+
			"actual  : %q", expected, actual)
	}

	return nil
}

func (c *client) findAllTransactionsInRangeSuccess(from, to string, expectedBody *godog.DocString) error {
	result, err := c.findAllTransactionsInRange(from, to)
	if err != nil {
		return fmt.Errorf("could not get transactions: %w", err)
	}

	actual, err := json.Marshal(result)
	if err != nil {
		return err
	}

	return assertjson.FailNotEqual([]byte(expectedBody.Content), actual)
}

func newClient(uri string) *client {
	return &client{
		uri: uri,
	}
}
