import Foundation
import ObjectMapper

/// InternationalizationUserSettings model.
open class InternationalizationUserSettings: Mappable {

    /// The internationalization language user settings.
    public private(set) final var language: InternationalizationUserSetting?

    /// The internationalization date time format user settings.
    public private(set) final var dateTimeFormat: InternationalizationUserSetting?

    /// The internationalization number format user settings.
    public private(set) final var numberFormat: InternationalizationUserSetting?

    /**
      Constructor.

      - parameter language: The internationalization language user settings.
      - parameter dateTimeFormat: The internationalization date time format user settings.
      - parameter numberFormat: The internationalization number format user settings.
    */
    public init(language: InternationalizationUserSetting, dateTimeFormat: InternationalizationUserSetting, numberFormat: InternationalizationUserSetting) {
        self.language = language
        self.dateTimeFormat = dateTimeFormat
        self.numberFormat = numberFormat
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
        language  <- map["language"]
        dateTimeFormat <- map["dateTimeFormat"]
        numberFormat <- map["numberFormat"]
    }

}
