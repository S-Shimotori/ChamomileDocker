import Foundation
import APIKit
import Argo

protocol NicovideoRequest: Request {
}

extension NicovideoRequest {
    var baseURL: URL {
        return URL(string: "http://api.search.nicovideo.jp/")!
    }

    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard 200..<300 ~= urlResponse.statusCode else {
            throw NicovideoAPI.SearchError(object: object, status: urlResponse.statusCode)
        }
        return object
    }
}

extension NicovideoRequest where Response: Decodable, Response == Response.DecodedType {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let decoded: Decoded<Response> = decode(object)
        switch decoded {
        case let .success(response):
            return response
        case let .failure(error):
            throw error
        }
    }
}

