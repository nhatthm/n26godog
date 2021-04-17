# Cucumber N26 API for Golang

[![Build Status](https://github.com/nhatthm/n26godog/actions/workflows/test.yaml/badge.svg)](https://github.com/nhatthm/{}name/actions/workflows/test.yaml)
[![codecov](https://codecov.io/gh/nhatthm/n26godog/branch/master/graph/badge.svg?token=eTdAgDE2vR)](https://codecov.io/gh/nhatthm/n26godog)
[![Go Report Card](https://goreportcard.com/badge/github.com/nhatthm/n26godog)](https://goreportcard.com/report/github.com/nhatthm/n26godog)
[![GoDevDoc](https://img.shields.io/badge/dev-doc-00ADD8?logo=go)](https://pkg.go.dev/github.com/nhatthm/n26godog)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/donate/?hosted_button_id=PJZSGJN57TDJY)

`n26godog` provides `cucumber/godog` steps for testing N26 API.

## Prerequisites

- `Go >= 1.14`

## Install

```bash
go get github.com/nhatthm/n26godog
```

## Usage

For example:

```go
package mypackage

import (
    "testing"

    "github.com/cucumber/godog"
    "github.com/nhatthm/n26godog"
)

func TestIntegration(t *testing.T) {
    server := n26godog.New(t)
    suite := godog.TestSuite{
        Name:                 "Integration",
        TestSuiteInitializer: nil,
        ScenarioInitializer: func(ctx *godog.ScenarioContext) {
            server.RegisterContext(t, ctx)
        },
        Options: &godog.Options{
            Strict:    true,
            Output:    out,
            Randomize: rand.Int63(),
        },
    }

    // Initiate your client and run it with the suite.
    status := suite.Run()
}
```

## Steps

### Authentication
- `^n26 receives a login request with username "([^"]+)", password "([^"]+)" and device id "([^"]+)" but the credentials is wrong`
- `^n26 receives a login request with username "([^"]+)", password "([^"]+)" and device id "([^"]+)" but no one confirms login`
- `^n26 receives a success login request with username "([^"]+)", password "([^"]+)" and device id "([^"]+)"`
- `^n26 receives a refresh token request but the token is invalid`
- `^n26 receives a success refresh token request`

### Transactions

- `^n26 receives a request to find all transactions in between "([^"]+)" and "([^"]+)"(?: with page size ([0-9]+))? and responses:$`
- `^n26 receives a request to find all transactions in between "([^"]+)" and "([^"]+)"(?: with page size ([0-9]+))? and responses with result from file:$`

## Examples

See https://github.com/nhatthm/n26godog/tree/master/features

## Donation

If this project help you reduce time to develop, you can give me a cup of coffee :)

### Paypal donation

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate/?hosted_button_id=PJZSGJN57TDJY)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;or scan this

<img src="https://user-images.githubusercontent.com/1154587/113494222-ad8cb200-94e6-11eb-9ef3-eb883ada222a.png" width="147px" />
