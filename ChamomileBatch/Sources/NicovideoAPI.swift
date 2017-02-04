import Foundation
import APIKit

final class NicovideoAPI {
    struct SearchVideosRequest: NicovideoRequest {
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
            return "/api/v2/video/contents/search"
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

        func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
            print(object)
            return NicovideoAPI.SearchResponse(
                meta: NicovideoAPI.MetaData(status: 200, id: "hoge", totalCount: 0),
                data: nil
            )
        }
    }

    struct SearchResponse {
        let meta: MetaData
        let data: [Content]?
    }

    struct MetaData {
        let status: Int
        let id: String
        let totalCount: Int
    }

    struct Content {
        let contentId: String?
        let title: String?
        let description: String?
        let tags: [String]?
        let categoryTags: [String]?
        let viewCounter: Int?
        let mylistCounter: Int?
        let commentCounter: Int?
        let startTime: Date?
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

