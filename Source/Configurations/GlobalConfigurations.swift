import Foundation

/// The global SDK configurations class.
open class GlobalConfigurations {

    /// Uphold's Swift SDK bundle name.
    open static let BUNDLE_NAME: String = Bundle.main.bundleIdentifier == nil ? "com.uphold.uphold-swift-sdk" : Bundle.main.bundleIdentifier!

    /// Uphold's Swift SDK github repository URL.
    open static let SDK_GITHUB_URL: String = "https://github.com/uphold/uphold-sdk-ios"

    /// Uphold's Swift SDK current version.
    open static let UPHOLD_SDK_VERSION: String = ResourcesUtil.getValueFromInfoPlist(key: "CFBundleShortVersionString")

    /// Uphold's API URL.
    open static let UPHOLD_API_URL: String = ResourcesUtil.getValueFromConfigurationsPlist(key: "API_URL")

    /// Uphold's authorization server URL.
    open static let UPHOLD_AUTHORIZATION_SERVER_URL: String = ResourcesUtil.getValueFromConfigurationsPlist(key: "AUTHORIZATION_SERVER_URL")

}
