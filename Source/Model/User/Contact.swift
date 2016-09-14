import Foundation
import ObjectMapper

/// Contact model.
open class Contact: Mappable {

    /// The contact id.
    public private(set) final var id: String?

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

    /// The contact name.
    public private(set) final var name: String?

    /**
      Constructor.

      - parameter id: The contact id.
      - parameter addresses: The list of addresses.
      - parameter company: The company name.
      - parameter emails: The list of contact emails.
      - parameter firstName: The contact first name.
      - parameter lastName: The contact last name.
      - parameter name: The contact name.
    */
    public init(id: String, addresses: [String], company: String, emails: [String], firstName: String, lastName: String, name: String) {
        self.id = id
        self.addresses = addresses
        self.company = company
        self.emails = emails
        self.firstName = firstName
        self.lastName = lastName
        self.name = name
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
        self.id <- map["id"]
        self.addresses <- map["addresses"]
        self.company <- map["company"]
        self.emails <- map["emails"]
        self.firstName <- map["firstName"]
        self.lastName <- map["lastName"]
        self.name <- map["name"]
    }

}
