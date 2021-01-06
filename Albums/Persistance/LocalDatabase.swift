import Foundation

struct LocalDatabase {
    let storage = UserDefaults.standard
    static let shared = LocalDatabase()
    private init() {}
}

extension LocalDatabase {
    enum KeyIdentifier: String {
        case albumsPage
        case photosPage
    }
}
