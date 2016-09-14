import Foundation

/// Resources util class.
open class ResourcesUtil {

    /// The SwiftLint rules that must be disabled.
    // swiftlint:disable force_try

    /**
      Gets the value of a given key and configuration file.

      - parameter file: The configuration file.
      - parameter key: The configuration key.

      - throws: A ConfigurationMissingError.

      - returns: The configuration value.
    */
    open static func getValueFromKey(file: String, key: String) throws -> String {
        switch file {
            case "ConfigurationsPlist":
                guard let configurationsPath = Bundle(for: self).path(forResource: "Configurations", ofType: "plist"), let configurationDictionary = NSDictionary(contentsOfFile: configurationsPath), let value = configurationDictionary[key] as? String else {
                    throw ConfigurationMissingError(message: String(format: "There is no value for the key: %@", key)) as Error
                }

                return value
            case "InfoPlist":
                guard let infoDictionary = Bundle(for: self).infoDictionary, let value = infoDictionary[key] as? String else {
                    throw ConfigurationMissingError(message: String(format: "There is no value for the key: %@", key)) as Error
                }

                return value
            default:
                throw ConfigurationMissingError(message: String(format: "There is no value for the key: %@", key)) as Error
        }
    }

    /**
      Gets the value of a given key from the Configurations.plist file.

      - parameter key: The configuration key.

      - returns: The configuration value.
    */
    open static func getValueFromConfigurationsPlist(key: String) -> String {
        return try! ResourcesUtil.getValueFromKey(file: "ConfigurationsPlist", key: key)
    }

    /**
      Gets the value of a given key from the Info.plist file.

      - parameter key: The configuration key.

      - returns: The configuration value.
    */
    open static func getValueFromInfoPlist(key: String) -> String {
        return try! ResourcesUtil.getValueFromKey(file: "InfoPlist", key: key)
    }

}
