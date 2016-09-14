import Foundation
import ObjectMapper

/// InternationalizationUserSetting model.
open class InternationalizationUserSetting: Mappable {

    /// The locale for the setting.
    public private(set) final var locale: String?

    /**
      Constructor.

      - parameter locale: The locale for the setting.
    */
    public init(locale: String) {
        self.locale = locale
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
        locale  <- map["locale"]
    }

}
