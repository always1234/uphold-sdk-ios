import Foundation
import ObjectMapper

/// ContactRequest model.
open class ContactRequest: Mappable {

    /// The list of addresses.
    public private(set) final var addresses: [String]?

    /// The company name.
    public private(set) final var company: String?

    /// The list of contact emails.
    public private(set) final var emails: [String]?

    /// The contact first name.
    public private(set) final var firstName: String?

    /// The contact last name.
    public private(set) final var lastName: String?

    /**
      Constructor.

      - parameter addresses: The list of addresses.
      - parameter company: The company name.
      - parameter emails: The list of contact emails.
      - parameter firstName: The contact first name.
      - parameter lastName: The contact last name.
    */
    public init(addresses: [String], company: String, emails: [String], firstName: String, lastName: String) {
        self.addresses = addresses
        self.company = company
        self.emails = emails
        self.firstName = firstName
        self.lastName = lastName
    }

    // MARK: Required by the ObjectMapper.

    /**
      Constructor.

      - parameter map: Mapping data object.
    */
    required public init?(map: Map) {
    }

    /**
      Maps the JSON to the Object.

      - parameter map: The object to map.
     */
    open func mapping(map: Map) {
        self.addresses <- map["addresses"]
        self.company <- map["company"]
        self.emails <- map["emails"]
        self.firstName <- map["firstName"]
        self.lastName <- map["lastName"]
    }

}
