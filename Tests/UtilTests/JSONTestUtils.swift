import Foundation

/// JSON test util methods.
public class JSONTestUtils {

    /**
      Convert a JSON object to a dictionary.

      - parameter json: The JSON string to convert.

      - returns: The dictionary.
    */
    public static func JSONtoDictionary(json: String) -> [String: AnyObject]? {
        if let data = json.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])

                guard let dictionary = json as? [String: AnyObject] else {
                    return nil
                }

                return dictionary
            } catch {
                return nil
            }
        }

        return nil
    }

}
