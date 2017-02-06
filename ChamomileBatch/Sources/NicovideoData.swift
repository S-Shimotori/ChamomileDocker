import Foundation
import Argo
import Runes
import Curry

struct NicovideoData {
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

    init(contentId: String? = nil, title: String? = nil, description: String? = nil, tags: [String]? = nil, categoryTags: [String]? = nil, viewCounter: Int? = nil, mylistCounter: Int? = nil, commentCounter: Int? = nil, startTime: Date? = nil, thumbnailUrl: String? = nil, communityIcon: String? = nil, scoreTimeshiftReserved: Int? = nil, liveStatus: LiveStatus? = nil) {
        self.contentId = contentId
        self.title = title
        self.description = description
        self.tags = tags
        self.categoryTags = categoryTags
        self.viewCounter = viewCounter
        self.mylistCounter = mylistCounter
        self.commentCounter = commentCounter
        self.startTime = startTime
        self.thumbnailUrl = thumbnailUrl
        self.communityIcon = communityIcon
        self.scoreTimeshiftReserved = scoreTimeshiftReserved
        self.liveStatus = liveStatus
    }

    enum LiveStatus: String {
        case past = "past"
        case onair = "onair"
        case reserved = "reserved"
    }

    func toDictionary() -> [String: Any] {
        var result = [String: Any]()
        result["contentId"] = contentId
        result["title"] = title
        result["description"] = description
        result["tags"] = tags
        result["categoryTags"] = categoryTags
        result["viewCounter"] = viewCounter
        result["mylistCounter"] = mylistCounter
        result["commentCounter"] = commentCounter
        result["startTime"] = startTime
        result["thumbnailUrl"] = thumbnailUrl
        result["communityIcon"] = communityIcon
        result["scoreTimeshiftReserved"] = scoreTimeshiftReserved
        result["liveStatus"] = liveStatus?.rawValue
        return result
    }
}

extension NicovideoData: Decodable {
    static func decode(_ json: JSON) -> Decoded<NicovideoData> {
        let tags: Decoded<String?> = json <|? "tags"
        let categoryTags: Decoded<String?> = json <|? "categoryTags"

        let temp: Decoded<(Int?)->(Int?)->(Date?)->(String?)->(String?)->(Int?)->(NicovideoData.LiveStatus?)->NicovideoData> =
        curry(NicovideoData.init)
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

extension NicovideoData.LiveStatus: Decodable {
    static func decode(_ json: JSON) -> Decoded<NicovideoData.LiveStatus> {
        switch json {
        case let .string(s):
            if let liveStatus = NicovideoData.LiveStatus(rawValue: s) {
                return pure(liveStatus)
            } else {
                return .customError("got \(s), but expected LiveStatus")
            }
        default:
            return .typeMismatch(expected: "String", actual: json)
        }
    }
}

