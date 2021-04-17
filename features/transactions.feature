Feature: Transactions

    Background:
        Given create a n26 client with username "john.doe", password "123456" and device id "45ce8f77-b470-4563-a95b-3b27211894bb"

    Scenario: Could not login because of wrong credentials
        Given n26 receives a login request with username "john.doe", password "123456" and device id "45ce8f77-b470-4563-a95b-3b27211894bb" but the credentials is wrong

        Then I find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and get an error:
        """
        could not find transactions: wrong credentials
        """

    Scenario: Could not login because of no confirmation
        Given n26 receives a login request with username "john.doe", password "123456" and device id "45ce8f77-b470-4563-a95b-3b27211894bb" but no one confirms login

        Then I find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and get an error:
        """
        could not find transactions: could not confirm login
        """

    Scenario: Result is inline
        Given n26 receives a success login request with username "john.doe", password "123456" and device id "45ce8f77-b470-4563-a95b-3b27211894bb"
        And n26 receives a request to find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and responses:
        """
        [
            {
                "id": "801d35f4-f550-446a-974a-0d5dc2c1f55d",
                "userId": "7e3f710b-349d-4203-9c5d-cfbc716e1b8e",
                "type": "CT",
                "amount": 10,
                "currencyCode": "EUR",
                "visibleTS": 1617631557000,
                "partnerBic": "NTSBDEB1XXX",
                "partnerName": "Jane Doe",
                "accountId": "98f0afa3-e906-493a-a37f-afe29c7f9f2e",
                "partnerIban": "DEXX1001100126XXXXXXXX",
                "category": "micro-v2-income",
                "cardId": "f2252c42-c188-4b43-ab68-131024782b3d",
                "userCertified": 1617545157000,
                "pending": false,
                "transactionNature": "NORMAL",
                "createdTS": 1617541557000,
                "smartLinkId": "fcdec3cb-47b2-4ca3-b98d-b326e1cc5a0c",
                "smartContactId": "3edce485-6853-40bf-aa08-309c2eb3e7db",
                "linkId": "6f06f5fb-074d-4242-b280-db2af2fe6405",
                "confirmed": 1617545157000
            }
        ]
        """

        Then I find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and receive:
        """
        [
            {
                "id": "801d35f4-f550-446a-974a-0d5dc2c1f55d",
                "userId": "7e3f710b-349d-4203-9c5d-cfbc716e1b8e",
                "type": "CT",
                "amount": 10,
                "currencyCode": "EUR",
                "visibleTS": 1617631557000,
                "partnerBic": "NTSBDEB1XXX",
                "partnerName": "Jane Doe",
                "accountId": "98f0afa3-e906-493a-a37f-afe29c7f9f2e",
                "partnerIban": "DEXX1001100126XXXXXXXX",
                "category": "micro-v2-income",
                "cardId": "f2252c42-c188-4b43-ab68-131024782b3d",
                "userCertified": 1617545157000,
                "pending": false,
                "transactionNature": "NORMAL",
                "createdTS": 1617541557000,
                "smartLinkId": "fcdec3cb-47b2-4ca3-b98d-b326e1cc5a0c",
                "smartContactId": "3edce485-6853-40bf-aa08-309c2eb3e7db",
                "linkId": "6f06f5fb-074d-4242-b280-db2af2fe6405",
                "confirmed": 1617545157000
            }
        ]
        """

    Scenario: Result is from a file
        Given n26 receives a success login request with username "john.doe", password "123456" and device id "45ce8f77-b470-4563-a95b-3b27211894bb"
        And n26 receives a request to find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and responses with result from file:
        """
        ../../resources/fixtures/transactions.json
        """

        Then I find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and receive:
        """
        [
            {
                "id": "801d35f4-f550-446a-974a-0d5dc2c1f55d",
                "userId": "7e3f710b-349d-4203-9c5d-cfbc716e1b8e",
                "type": "CT",
                "amount": 10,
                "currencyCode": "EUR",
                "visibleTS": 1617631557000,
                "partnerBic": "NTSBDEB1XXX",
                "partnerName": "Jane Doe",
                "accountId": "98f0afa3-e906-493a-a37f-afe29c7f9f2e",
                "partnerIban": "DEXX1001100126XXXXXXXX",
                "category": "micro-v2-income",
                "cardId": "f2252c42-c188-4b43-ab68-131024782b3d",
                "userCertified": 1617545157000,
                "pending": false,
                "transactionNature": "NORMAL",
                "createdTS": 1617541557000,
                "smartLinkId": "fcdec3cb-47b2-4ca3-b98d-b326e1cc5a0c",
                "smartContactId": "3edce485-6853-40bf-aa08-309c2eb3e7db",
                "linkId": "6f06f5fb-074d-4242-b280-db2af2fe6405",
                "confirmed": 1617545157000
            }
        ]
        """

    Scenario: Refresh token is invalid
        Given n26 receives a success login request with username "john.doe", password "123456" and device id "45ce8f77-b470-4563-a95b-3b27211894bb"
        And n26 receives a request to find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and responses with result from file:
        """
        ../../resources/fixtures/transactions.json
        """
        And now is "2020-05-06T07:08:09Z"

        Then I find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and receive:
        """
        [
            {
                "id": "801d35f4-f550-446a-974a-0d5dc2c1f55d",
                "userId": "7e3f710b-349d-4203-9c5d-cfbc716e1b8e",
                "type": "CT",
                "amount": 10,
                "currencyCode": "EUR",
                "visibleTS": 1617631557000,
                "partnerBic": "NTSBDEB1XXX",
                "partnerName": "Jane Doe",
                "accountId": "98f0afa3-e906-493a-a37f-afe29c7f9f2e",
                "partnerIban": "DEXX1001100126XXXXXXXX",
                "category": "micro-v2-income",
                "cardId": "f2252c42-c188-4b43-ab68-131024782b3d",
                "userCertified": 1617545157000,
                "pending": false,
                "transactionNature": "NORMAL",
                "createdTS": 1617541557000,
                "smartLinkId": "fcdec3cb-47b2-4ca3-b98d-b326e1cc5a0c",
                "smartContactId": "3edce485-6853-40bf-aa08-309c2eb3e7db",
                "linkId": "6f06f5fb-074d-4242-b280-db2af2fe6405",
                "confirmed": 1617545157000
            }
        ]
        """

        Given I add 15m to the clock
        And n26 receives a refresh token request but the token is invalid
        And n26 receives a success login request with username "john.doe", password "123456" and device id "45ce8f77-b470-4563-a95b-3b27211894bb"
        And n26 receives a request to find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and responses with result from file:
        """
        ../../resources/fixtures/transactions.json
        """

        Then I find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and receive:
        """
        [
            {
                "id": "801d35f4-f550-446a-974a-0d5dc2c1f55d",
                "userId": "7e3f710b-349d-4203-9c5d-cfbc716e1b8e",
                "type": "CT",
                "amount": 10,
                "currencyCode": "EUR",
                "visibleTS": 1617631557000,
                "partnerBic": "NTSBDEB1XXX",
                "partnerName": "Jane Doe",
                "accountId": "98f0afa3-e906-493a-a37f-afe29c7f9f2e",
                "partnerIban": "DEXX1001100126XXXXXXXX",
                "category": "micro-v2-income",
                "cardId": "f2252c42-c188-4b43-ab68-131024782b3d",
                "userCertified": 1617545157000,
                "pending": false,
                "transactionNature": "NORMAL",
                "createdTS": 1617541557000,
                "smartLinkId": "fcdec3cb-47b2-4ca3-b98d-b326e1cc5a0c",
                "smartContactId": "3edce485-6853-40bf-aa08-309c2eb3e7db",
                "linkId": "6f06f5fb-074d-4242-b280-db2af2fe6405",
                "confirmed": 1617545157000
            }
        ]
        """

    Scenario: Refresh token is valid
        Given n26 receives a success login request with username "john.doe", password "123456" and device id "45ce8f77-b470-4563-a95b-3b27211894bb"
        And n26 receives a request to find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and responses with result from file:
        """
        ../../resources/fixtures/transactions.json
        """
        And now is "2020-05-06T07:08:09Z"

        Then I find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and receive:
        """
        [
            {
                "id": "801d35f4-f550-446a-974a-0d5dc2c1f55d",
                "userId": "7e3f710b-349d-4203-9c5d-cfbc716e1b8e",
                "type": "CT",
                "amount": 10,
                "currencyCode": "EUR",
                "visibleTS": 1617631557000,
                "partnerBic": "NTSBDEB1XXX",
                "partnerName": "Jane Doe",
                "accountId": "98f0afa3-e906-493a-a37f-afe29c7f9f2e",
                "partnerIban": "DEXX1001100126XXXXXXXX",
                "category": "micro-v2-income",
                "cardId": "f2252c42-c188-4b43-ab68-131024782b3d",
                "userCertified": 1617545157000,
                "pending": false,
                "transactionNature": "NORMAL",
                "createdTS": 1617541557000,
                "smartLinkId": "fcdec3cb-47b2-4ca3-b98d-b326e1cc5a0c",
                "smartContactId": "3edce485-6853-40bf-aa08-309c2eb3e7db",
                "linkId": "6f06f5fb-074d-4242-b280-db2af2fe6405",
                "confirmed": 1617545157000
            }
        ]
        """

        Given I add 15m to the clock
        And n26 receives a success refresh token request
        And n26 receives a request to find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and responses with result from file:
        """
        ../../resources/fixtures/transactions.json
        """

        Then I find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and receive:
        """
        [
            {
                "id": "801d35f4-f550-446a-974a-0d5dc2c1f55d",
                "userId": "7e3f710b-349d-4203-9c5d-cfbc716e1b8e",
                "type": "CT",
                "amount": 10,
                "currencyCode": "EUR",
                "visibleTS": 1617631557000,
                "partnerBic": "NTSBDEB1XXX",
                "partnerName": "Jane Doe",
                "accountId": "98f0afa3-e906-493a-a37f-afe29c7f9f2e",
                "partnerIban": "DEXX1001100126XXXXXXXX",
                "category": "micro-v2-income",
                "cardId": "f2252c42-c188-4b43-ab68-131024782b3d",
                "userCertified": 1617545157000,
                "pending": false,
                "transactionNature": "NORMAL",
                "createdTS": 1617541557000,
                "smartLinkId": "fcdec3cb-47b2-4ca3-b98d-b326e1cc5a0c",
                "smartContactId": "3edce485-6853-40bf-aa08-309c2eb3e7db",
                "linkId": "6f06f5fb-074d-4242-b280-db2af2fe6405",
                "confirmed": 1617545157000
            }
        ]
        """

    Scenario: Refresh token is expired
        Given n26 receives a success login request with username "john.doe", password "123456" and device id "45ce8f77-b470-4563-a95b-3b27211894bb"
        And n26 receives a request to find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and responses with result from file:
        """
        ../../resources/fixtures/transactions.json
        """
        And now is "2020-05-06T07:08:09Z"

        Then I find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and receive:
        """
        [
            {
                "id": "801d35f4-f550-446a-974a-0d5dc2c1f55d",
                "userId": "7e3f710b-349d-4203-9c5d-cfbc716e1b8e",
                "type": "CT",
                "amount": 10,
                "currencyCode": "EUR",
                "visibleTS": 1617631557000,
                "partnerBic": "NTSBDEB1XXX",
                "partnerName": "Jane Doe",
                "accountId": "98f0afa3-e906-493a-a37f-afe29c7f9f2e",
                "partnerIban": "DEXX1001100126XXXXXXXX",
                "category": "micro-v2-income",
                "cardId": "f2252c42-c188-4b43-ab68-131024782b3d",
                "userCertified": 1617545157000,
                "pending": false,
                "transactionNature": "NORMAL",
                "createdTS": 1617541557000,
                "smartLinkId": "fcdec3cb-47b2-4ca3-b98d-b326e1cc5a0c",
                "smartContactId": "3edce485-6853-40bf-aa08-309c2eb3e7db",
                "linkId": "6f06f5fb-074d-4242-b280-db2af2fe6405",
                "confirmed": 1617545157000
            }
        ]
        """

        Given I add 2h to the clock
        And n26 receives a success login request with username "john.doe", password "123456" and device id "45ce8f77-b470-4563-a95b-3b27211894bb"
        And n26 receives a request to find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and responses with result from file:
        """
        ../../resources/fixtures/transactions.json
        """

        Then I find all transactions in between "2020-01-02T03:04:05Z" and "2020-02-03T04:05:06Z" and receive:
        """
        [
            {
                "id": "801d35f4-f550-446a-974a-0d5dc2c1f55d",
                "userId": "7e3f710b-349d-4203-9c5d-cfbc716e1b8e",
                "type": "CT",
                "amount": 10,
                "currencyCode": "EUR",
                "visibleTS": 1617631557000,
                "partnerBic": "NTSBDEB1XXX",
                "partnerName": "Jane Doe",
                "accountId": "98f0afa3-e906-493a-a37f-afe29c7f9f2e",
                "partnerIban": "DEXX1001100126XXXXXXXX",
                "category": "micro-v2-income",
                "cardId": "f2252c42-c188-4b43-ab68-131024782b3d",
                "userCertified": 1617545157000,
                "pending": false,
                "transactionNature": "NORMAL",
                "createdTS": 1617541557000,
                "smartLinkId": "fcdec3cb-47b2-4ca3-b98d-b326e1cc5a0c",
                "smartContactId": "3edce485-6853-40bf-aa08-309c2eb3e7db",
                "linkId": "6f06f5fb-074d-4242-b280-db2af2fe6405",
                "confirmed": 1617545157000
            }
        ]
        """
