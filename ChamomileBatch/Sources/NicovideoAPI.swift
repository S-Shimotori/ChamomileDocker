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
        let data: [Data]

        struct Meta {
            let status: Int
            let id: String
            let totalCount: Int
        }

        struct Data {
            let contentId: String?
            let title: String?
            let description: String?
            let tags: [String]?
            let categoryTags: [String]?
            let viewCounter: Int?
            let mylistCounter: Int?
            let commentCounter: Int?
            let startTime: String?
            let thumbnailUrl: String?
            let communityIcon: String?
            let scoreTimeshiftReserved: Int?
            let liveStatus: LiveStatus?

            enum LiveStatus: String {
                case past = "past"
                case onair = "onair"
                case reserved = "reserved"
            }
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

extension NicovideoAPI.SearchResponse.Data: Decodable {
    static func decode(_ json: JSON) -> Decoded<NicovideoAPI.SearchResponse.Data> {
        let tags: Decoded<String?> = json <|? "tags"
        let categoryTags: Decoded<String?> = json <|? "categoryTags"

        let temp: Decoded<(Int?)->(Int?)->(String?)->(String?)->(String?)->(Int?)->(NicovideoAPI.SearchResponse.Data.LiveStatus?)->NicovideoAPI.SearchResponse.Data> =
        curry(NicovideoAPI.SearchResponse.Data.init)
            <^> json <|? "contentId"
            <*> json <|? "title"
            <*> json <|? "description"
            <*> tags.map { $0?.components(separatedBy: ",") }
            <*> categoryTags.map { $0?.components(separatedBy: ",") }
            <*> json <|? "viewCounter"
        return temp
            <*> json <|? "mylistCounter"
            <*> json <|? "commentCounter"
            <*> json <|? "startTime"
            <*> json <|? "thumbnailUrl"
            <*> json <|? "communityIcon"
            <*> json <|? "scoreTimeshiftReserved"
            <*> json <|? "liveStatus"
    }
}

extension NicovideoAPI.SearchResponse.Data.LiveStatus: Decodable {
    static func decode(_ json: JSON) -> Decoded<NicovideoAPI.SearchResponse.Data.LiveStatus> {
        switch json {
        case let .string(s):
            if let liveStatus = NicovideoAPI.SearchResponse.Data.LiveStatus(rawValue: s) {
                return pure(liveStatus)
            } else {
                return .customError("got \(s), but expected LiveStatus")
            }
        default:
            return .typeMismatch(expected: "String", actual: json)
        }
    }
}

