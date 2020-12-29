import Foundation

struct JSONDataParsingHelper {
    let decoder = JSONDecoder()
    let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func getData(from fileName: String) -> Data {
        guard let filePath = bundle.path(forResource: fileName, ofType: "json"),
              let jsonString = try? String(contentsOfFile: filePath, encoding: .utf8),
              let data = jsonString.data(using: .utf8) else {
            assertionFailure("Error mapping JSON file.")
            return Data()
        }
        return data
    }
}
