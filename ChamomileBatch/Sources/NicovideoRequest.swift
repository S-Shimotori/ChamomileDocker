import Foundation
import APIKit

protocol NicovideoRequest: Request {
}

extension NicovideoRequest {
    var baseURL: URL {
        return URL(string: "http://api.search.nicovideo.jp/")!
    }

    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard 200..<300 ~= urlResponse.statusCode else {
            throw NicovideoError(object: object)
        }
        return object
    }
}

