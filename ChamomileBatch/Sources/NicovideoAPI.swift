import Foundation
import APIKit
import Argo
import Curry
import Runes

final class NicovideoAPI {
    enum Service: String {
        case video = "video"
        case live = "live"
        case illust = "illust"
        case manga = "manga"
        case book = "book"
        case channel = "channel"
        case channelarticle = "channelarticle"
        case news = "news"
    }

    struct SearchRequest: NicovideoRequest {
        let service: Service
        let q: String
        let targets: String
        let fields: String?
        let filters: String?
        let _sort: String
        let _offset: Int?
        let _limit: Int?
        let _context: String

        typealias Response = SearchResponse

        var method: HTTPMethod {
            return .get
        }

        var path: String {
            return "/api/v2/\(service.rawValue)/contents/search"
        }

        var parameters: Any? {
            var dictionary: [String: Any] = [
                "q": q,
                "targets": targets,
                "_sort": _sort,
                "_context": _context
            ]
            if let fields = fields {
                dictionary["fields"] = fields
            }
            if let filters = filters {
                dictionary["filters"] = filters
            }
            if let _offset = _offset {
                dictionary["_offset"] = _offset
            }
            if let _limit = _limit {
                dictionary["_limit"] = _limit
            }
            return dictionary
        }
    }

    struct SearchResponse {
        let meta: Meta
        let data: [NicovideoData]

        struct Meta {
            let status: Int
            let id: String
            let totalCount: Int
        }

    }

    struct SearchError: Error {
        let status: Int
        let errorCode: String?
        let errorMessage: String?

        init(object: Any, status: Int) {
            let dictionary = object as? [String: Any]
            self.status = status
            self.errorCode = dictionary?["errorCode"] as? String
            self.errorMessage = dictionary?["errorMessage"] as? String
        }
    }
}

extension NicovideoAPI.SearchResponse: Decodable {
    static func decode(_ json: JSON) -> Decoded<NicovideoAPI.SearchResponse> {
        return curry(NicovideoAPI.SearchResponse.init)
            <^> json <| "meta"
            <*> json <|| "data"
    }
}

extension NicovideoAPI.SearchResponse.Meta: Decodable {
    static func decode(_ json: JSON) -> Decoded<NicovideoAPI.SearchResponse.Meta> {
        return curry(NicovideoAPI.SearchResponse.Meta.init)
            <^> json <| "status"
            <*> json <| "id"
            <*> json <| "totalCount"
    }
}


