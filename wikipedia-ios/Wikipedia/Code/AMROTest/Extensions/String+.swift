import Foundation

extension String {
    /// transform String to Decodable object.
    func toDataObject<T: Decodable>() -> T? {
        guard let data = data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
