import Foundation
import ObjectMapper

/// Phone model.
open class Phone: Mappable {

    /// The contact id.
    public private(set) final var id: String?

    /// The E.164 phone mask.
    public private(set) final var e164Masked: String?

    /// The international phone mask.
    public private(set) final var internationalMasked: String?

    /// The national phone mask.
    public private(set) final var nationalMasked: String?

    /// A boolean indicating if the phone is the primary user phone.
    public private(set) final var primary: Bool?

    /// A boolean indicating if the phone is verified.
    public private(set) final var verified: Bool?

    /**
      Constructor.

      - parameter id: The contact id.
      - parameter e164Masked: The E.164 phone mask.
      - parameter internationalMasked: The international phone mask.
      - parameter nationalMasked: The national phone mask.
      - parameter primary: A boolean indicating if the phone is the primary user phone.
      - parameter verified: A boolean indicating if the phone is verified.
    */
    public init(id: String, e164Masked: String, internationalMasked: String, nationalMasked: String, primary: Bool, verified: Bool) {
        self.id = id
        self.e164Masked = e164Masked
        self.internationalMasked = internationalMasked
        self.nationalMasked = nationalMasked
        self.primary = primary
        self.verified = verified
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
        self.e164Masked <- map["e164Masked"]
        self.internationalMasked <- map["internationalMasked"]
        self.nationalMasked <- map["nationalMasked"]
        self.primary <- map["primary"]
        self.verified <- map["verified"]
    }

}
