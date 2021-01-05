import Foundation
import Moya

enum EndpointsAPI {
    case getAlbums(page: UInt)
    case getPhotos(page: UInt, albumId: Int)
}

extension EndpointsAPI: TargetType {
    var baseURL: URL {
        URL(string: "http://testapi.pinch.nl:3000")!
    }

    var path: String {
        switch self {
        case .getAlbums: return "/albums"
        case .getPhotos: return "/photos"
        }
    }

    var method: Moya.Method {
        .get
    }

    var sampleData: Data {
        switch self {
        case .getAlbums: return JSONDataParsingHelper().getData(from: "AlbumsJSON")
        case .getPhotos: return JSONDataParsingHelper().getData(from: "PhotosJSON")
        }
    }

    var task: Task {
        let encoding: ParameterEncoding
        switch method {
        case .get: encoding = URLEncoding.default
        default: encoding = JSONEncoding.default
        }

        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters, encoding: encoding)
        }

        return .requestPlain
    }

    var headers: [String: String]? {
        nil
    }

    var parameters: [String: Any]? {
        switch self {
        case let .getAlbums(page):
            return ["_page": page]
        case let .getPhotos(page, albumId):
            return ["_page": page, "albumId": albumId]
        }
    }
}
