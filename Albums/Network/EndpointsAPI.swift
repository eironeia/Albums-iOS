import Foundation
import Moya

enum EndpointsAPI {
    case getAlbums(page: UInt)
}

extension EndpointsAPI: TargetType {
    var baseURL: URL {
        URL(string: "http://testapi.pinch.nl:3000")!
    }

    var path: String {
        switch self {
        case let .getAlbums(page): return "/albums?_page=\(page)"
        }
    }

    var method: Moya.Method {
        .get
    }

    var sampleData: Data {
        switch self {
        case .getAlbums: return JSONDataParsingHelper().getData(from: "AlbumsJSON")
        }
    }

    var task: Task {
        .requestPlain
    }

    var headers: [String: String]? {
        nil
    }
}
