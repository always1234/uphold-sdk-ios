import Foundation

/// URL utils class.
open class URLUtils {

    /**
      Escapes the given URL string and generates an NSURL.

      - parameter url: The URL.

      - throws: A MalformedUrlError.

      - returns: The escaped NSURL.
    */
    open static func escapeURL(url: String) throws -> URL {
        guard let escapedUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let uri = URL(string: escapedUrl) else {
            throw MalformedUrlError(message: "Invalid URL.") as Error
        }

        return uri
    }
}
