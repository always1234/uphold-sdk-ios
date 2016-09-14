import Fakery
import Foundation
import UpholdSdk

/// Fixtures to generate users, cards, etc.
public class Fixtures {

    /**
      Fixture to generate an account.

      - returns: An account.
    */
    public static func loadAccount() -> Account {
        return loadAccount(fields: nil)
    }

    /**
      Fixture to generate an account.

      - parameter fields: A dictionary containing specific fields for the account to have.

      - returns: An account.
    */
    public static func loadAccount(fields: [String: String]?) -> Account {
        let faker = Faker(locale: "en")

        var fakerFields = [
            "currency": faker.lorem.characters(amount: 3),
            "id": faker.lorem.characters(amount: 20),
            "label": faker.lorem.characters(amount: 10),
            "status": faker.lorem.characters(amount: 8),
            "type": faker.lorem.characters(amount: 8)
        ]

        if let fields = fields {
            _ = fields.flatMap { (key, value) in fakerFields[key] = value }
        }

        return Account(currency: fakerFields["currency"]!, id: fakerFields["id"]!, label: fakerFields["label"]!, status: fakerFields["status"]!, type: fakerFields["type"]!)
    }

    /**
      Fixture to generate a card.

      - returns: A card.
    */
    public static func loadCard() -> Card {
        return loadCard(fields: nil)
    }

    /**
      Fixture to generate a card.

      - parameter fields: A dictionary containing specific fields for the card to have.

      - returns: A card.
    */
    public static func loadCard(fields: [String: String]?) -> Card {
        let faker = Faker(locale: "en")

        var fakerFields = [
            "addressKeys": String(format: "%@,%@,%@", faker.lorem.characters(amount: 24), faker.lorem.characters(amount: 24), faker.lorem.characters(amount: 24)),
            "addressValues": String(format: "%@,%@,%@", faker.lorem.characters(amount: 24), faker.lorem.characters(amount: 24), faker.lorem.characters(amount: 24)),
            "available": faker.lorem.numerify("123456789"),
            "balance": faker.lorem.numerify("123456789"),
            "currency": faker.lorem.characters(amount: 3),
            "id": faker.lorem.characters(amount: 20),
            "label": faker.lorem.characters(amount: 20),
            "lastTransactionAt": faker.lorem.characters(amount: 24),
            "normalizedAvailable": String(format: "%@,%@,%@", faker.lorem.numerify("123456789"), faker.lorem.numerify("123456789"), faker.lorem.numerify("123456789")),
            "normalizedBalance": String(format: "%@,%@,%@", faker.lorem.numerify("123456789"), faker.lorem.numerify("123456789"), faker.lorem.numerify("123456789")),
            "normalizedCurrencies": String(format: "%@,%@,%@", faker.lorem.characters(amount: 3), faker.lorem.characters(amount: 3), faker.lorem.characters(amount: 3)),
            "settingsPosition": faker.lorem.numerify("#"),
            "settingsStarred": "true"
        ]

        if let fields = fields {
            _ = fields.flatMap { (key, value) in fakerFields[key] = value }
        }

        var address = [String: String]()

        for (index, key) in fakerFields["addressKeys"]!.components(separatedBy: ",").enumerated() {
            address.updateValue(fakerFields["addressValues"]!.components(separatedBy: ",")[index], forKey: key)
        }

        var normalized: [NormalizedCard] = []

        for (index, available) in fakerFields["normalizedAvailable"]!.components(separatedBy: ",").enumerated() {
            normalized.append(NormalizedCard(available: available, balance: fakerFields["normalizedBalance"]!.components(separatedBy: ",")[index], currency: fakerFields["normalizedCurrencies"]!.components(separatedBy: ",")[index]))
        }

        let cardSettings = CardSettings(position: NSString(string: fakerFields["settingsPosition"]!).integerValue, starred: NSString(string: fakerFields["settingsStarred"]!).boolValue)

        return Card(id: fakerFields["id"]!, address: address, available: fakerFields["available"]!, balance: fakerFields["balance"]!, currency: fakerFields["currency"]!, label: fakerFields["label"]!, lastTransactionAt: fakerFields["lastTransactionAt"], normalized: normalized, settings: cardSettings)
    }

    /**
      Fixture to generate a transaction.

      - returns: A transaction.
    */
    public static func loadTransaction() -> Transaction {
        return loadTransaction(fields: nil)
    }

    /**
      Fixture to generate a transaction.

      - parameter fields: A dictionary containing specific fields for the transaction to have.

      - returns: A transaction.
    */
    public static func loadTransaction(fields: [String: String]?) -> Transaction {
        let faker = Faker(locale: "en")

        var fakerFields = [
            "denominationAmount": faker.lorem.numerify("123456789"),
            "denominationCurrency": faker.lorem.characters(amount: 3),
            "denominationPair": faker.lorem.characters(amount: 6),
            "denominationRate": faker.lorem.numerify("123456789"),
            "destinationAccountId": faker.lorem.numerify("123456789"),
            "destinationAccountType": faker.lorem.characters(amount: 7),
            "destinationAmount": faker.lorem.numerify("123456789"),
            "destinationBase": faker.lorem.numerify("123456789"),
            "destinationCardId": faker.lorem.characters(amount: 24),
            "destinationCommission": faker.lorem.numerify("123456789"),
            "destinationCurrency": faker.lorem.characters(amount: 3),
            "destinationDescription": faker.name.name(),
            "destinationFee": faker.lorem.characters(amount: 3),
            "destinationRate": faker.lorem.characters(amount: 3),
            "destinationType": faker.lorem.characters(amount: 6),
            "destinationUsername": faker.lorem.characters(amount: 10),
            "feeAmount": faker.lorem.numerify("123456789"),
            "feeCurrency": faker.lorem.characters(amount: 3),
            "feePercentage": faker.lorem.numerify("123456789"),
            "feeTarget": faker.lorem.characters(amount: 10),
            "feeType": faker.lorem.characters(amount: 10),
            "normalizedAmount": faker.lorem.numerify("123456789"),
            "normalizedCommission": faker.lorem.numerify("123456789"),
            "normalizedCurrency": faker.lorem.characters(amount: 3),
            "normalizedFee": faker.lorem.numerify("123456789"),
            "normalizedRate": faker.lorem.numerify("123456789"),
            "originAccountId": faker.lorem.numerify("123456789"),
            "originAccountType": faker.lorem.characters(amount: 7),
            "originAmount": faker.lorem.numerify("123456789"),
            "originBase": faker.lorem.numerify("123456789"),
            "originCardId": faker.lorem.characters(amount: 24),
            "originCommission": faker.lorem.numerify("123456789"),
            "originCurrency": faker.lorem.characters(amount: 3),
            "originDescription": faker.name.name(),
            "originFee": faker.lorem.numerify("123456789"),
            "originRate": faker.lorem.numerify("123456789"),
            "originSourcesAmount": String(format: "%@,%@,%@", faker.lorem.numerify("123456789"), faker.lorem.numerify("123456789"), faker.lorem.numerify("123456789")),
            "originSourcesId": String(format: "%@,%@,%@", faker.lorem.characters(amount: 24), faker.lorem.characters(amount: 24), faker.lorem.characters(amount: 24)),
            "originType": faker.lorem.characters(amount: 10),
            "originUsername": faker.internet.username(),
            "parametersCurrency": faker.lorem.characters(amount: 3),
            "parametersMargin": faker.lorem.numerify("123456789"),
            "parametersPair": faker.lorem.characters(amount: 6),
            "parametersProgress": faker.lorem.numerify("123456789"),
            "parametersRate": faker.lorem.numerify("123456789"),
            "parametersRefunds": faker.lorem.characters(amount: 24),
            "parametersTtl": faker.lorem.numerify("123456789"),
            "parametersTxid": faker.lorem.numerify("123456789"),
            "parametersType": faker.lorem.characters(amount: 10),
            "transactionCreatedAt": faker.lorem.characters(amount: 24),
            "transactionId": faker.lorem.characters(amount: 24),
            "transactionMessage": faker.lorem.characters(amount: 24),
            "transactionNetwork": faker.lorem.characters(amount: 24),
            "transactionRefundedById": faker.lorem.characters(amount: 24),
            "transactionRefunds": faker.lorem.characters(amount: 24),
            "transactionStatus": faker.lorem.characters(amount: 24),
            "transactionType": faker.lorem.characters(amount: 24),
        ]

        if let fields = fields {
            _ = fields.flatMap { (key, value) in fakerFields[key] = value }
        }

        let denomination = Denomination(amount: fakerFields["denominationAmount"]!, currency: fakerFields["denominationCurrency"]!, pair: fakerFields["denominationPair"]!, rate: fakerFields["denominationRate"]!)
        let destination = Destination(accountId: fakerFields["destinationAccountId"]!, cardId: fakerFields["destinationCardId"]!, accountType: fakerFields["destinationAccountType"]!, amount: fakerFields["destinationAmount"]!, base: fakerFields["destinationBase"]!, commission: fakerFields["destinationCommission"]!, currency: fakerFields["destinationCurrency"]!, description: fakerFields["destinationDescription"]!, fee: fakerFields["destinationFee"]!, rate: fakerFields["destinationRate"]!, type: fakerFields["destinationType"]!, username: fakerFields["destinationUsername"]!)
        let fees = [Fee(amount: fakerFields["feeAmount"]!, currency: fakerFields["feeCurrency"]!, percentage: fakerFields["feePercentage"]!, target: fakerFields["feeTarget"]!, type: fakerFields["feeType"]!)]
        var sources: [Source] = []

        for (index, ids) in fakerFields["originSourcesId"]!.components(separatedBy: ",").enumerated() {
            sources.append(Source(id: ids, amount: fakerFields["originSourcesAmount"]!.components(separatedBy: ",")[index]))
        }

        let normalized = [NormalizedTransaction(amount: fakerFields["normalizedAmount"]!, commission: fakerFields["normalizedCommission"]!, currency: fakerFields["normalizedCurrency"]!, fee: fakerFields["normalizedFee"]!, rate: fakerFields["normalizedRate"]!)]
        let origin = Origin(accountId: fakerFields["originAccountId"]!, cardId: fakerFields["originCardId"]!, accountType: fakerFields["originAccountType"]!, amount: fakerFields["originAmount"]!, base: fakerFields["originBase"]!, commission: fakerFields["originCommission"]!, currency: fakerFields["originCurrency"]!, description: fakerFields["originDescription"]!, fee: fakerFields["originFee"]!, rate: fakerFields["originRate"]!, sources: sources, type: fakerFields["originType"]!, username: fakerFields["originUsername"]!)
        let parameters = Parameters(currency: fakerFields["parametersCurrency"]!, margin: fakerFields["parametersMargin"]!, pair: fakerFields["parametersPair"]!, progress: fakerFields["parametersProgress"]!, rate: fakerFields["parametersRate"]!, refunds: fakerFields["parametersRefunds"]!, ttl: NSString(string: fakerFields["parametersTtl"]!).integerValue, txid: fakerFields["parametersTxid"]!, type: fakerFields["parametersType"]!)

        return Transaction(id: fakerFields["transactionId"]!, createdAt: fakerFields["transactionCreatedAt"]!, denomination: denomination, destination: destination, fees: fees, message: fakerFields["transactionMessage"]!, network: fakerFields["transactionNetwork"]!, normalized: normalized, origin: origin, params: parameters, refundedById: fakerFields["transactionRefundedById"]!, status: fakerFields["transactionStatus"]!, type: fakerFields["transactionType"]!)
    }

    /**
      Fixture to generate a user.

      - returns: A user.
    */
    public static func loadUser() -> User {
        return loadUser(fields: nil)
    }

    /**
      Fixture to generate a user.

      - parameter fields: A dictionary containing specific fields for the user to have.

      - returns: A user.
    */
    public static func loadUser(fields: [String: String]?) -> User {
        let faker = Faker(locale: "en")

        var fakerFields = [
            "country": faker.locale,
            "currencies": String(format: "%@,%@,%@", faker.lorem.characters(amount: 3), faker.lorem.characters(amount: 3), faker.lorem.characters(amount: 3)),
            "currency": faker.lorem.characters(amount: 3),
            "email": faker.internet.email(),
            "firstName": faker.name.firstName(),
            "hasNewsSubscription": "true",
            "internationalizationUserSettingDateTimeFormat": faker.lorem.characters(amount: 5),
            "internationalizationUserSettingLanguage": faker.lorem.characters(amount: 5),
            "internationalizationUserSettingNumberFormat": faker.lorem.characters(amount: 5),
            "lastName": faker.name.lastName(),
            "name": faker.name.name(),
            "settingsOTPLogin": "true",
            "settingsOTPTransactionsSend": "true",
            "settingsOTPTransactionsTransfer": "true",
            "settingsOTPTransactionsWithdrawCrypto": "true",
            "state": faker.address.stateAbbreviation(),
            "status": faker.lorem.characters(amount: 10),
            "theme": faker.lorem.characters(amount: 10),
            "username": faker.lorem.characters(amount: 10)
        ]

        if let fields = fields {
            _ = fields.flatMap { (key, value) in fakerFields[key] = value }
        }

        let internationalizationUserSettingDateTimeFormat = InternationalizationUserSetting(locale: fakerFields["internationalizationUserSettingDateTimeFormat"]!)
        let internationalizationUserSettingLanguage = InternationalizationUserSetting(locale: fakerFields["internationalizationUserSettingLanguage"]!)
        let internationalizationUserSettingNumberFormat = InternationalizationUserSetting(locale: fakerFields["internationalizationUserSettingNumberFormat"]!)
        let internationalizationUserSettings = InternationalizationUserSettings(language: internationalizationUserSettingLanguage, dateTimeFormat: internationalizationUserSettingDateTimeFormat, numberFormat: internationalizationUserSettingNumberFormat)
        let otp = Otp(login: Login(enabled: NSString(string: fakerFields["settingsOTPLogin"]!).boolValue), transactions: Transactions(send: Send(enabled: NSString(string: fakerFields["settingsOTPTransactionsSend"]!).boolValue), transfer: Transfer(enabled: NSString(string: fakerFields["settingsOTPTransactionsTransfer"]!).boolValue), withdraw: Withdraw(crypto: Crypto(enabled: NSString(string: fakerFields["settingsOTPTransactionsWithdrawCrypto"]!).boolValue))))
        let userSettings = UserSettings(currency: fakerFields["currency"]!, hasNewsSubscription: NSString(string: fakerFields["hasNewsSubscription"]!).boolValue, intl: internationalizationUserSettings, otp: otp, theme: fakerFields["theme"]!)

        return User(country: fakerFields["country"]!, currencies: fakerFields["currencies"]!.components(separatedBy: ","), email: fakerFields["email"]!, firstName: fakerFields["firstName"]!, lastName: fakerFields["lastName"]!, name: fakerFields["name"]!, settings: userSettings, state: fakerFields["state"]!, status: fakerFields["status"]!, username: fakerFields["username"]!)
    }

}
