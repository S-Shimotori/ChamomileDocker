import Foundation
import APIKit

struct HogeRequest: Request {
    typealias Response = Hoge
    var baseURL: URL {
        return URL(string: "http://api.search.nicovideo.jp")!
    }
    var method: HTTPMethod {
        return .get
    }
    var path: String {
        return "/api/v2/video/contents/search?q=%E5%88%9D%E9%9F%B3%E3%83%9F%E3%82%AF&targets=title&fields=contentId,title,viewCounter&filters[viewCounter][gte]=10000&_sort=-viewCounter&_offset=0&_limit=3&_context=apiguide"
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Hoge {
        return try Hoge(object: object)
    }
}

struct Hoge {
    let object: Any
    init(object: Any) throws {
        self.object = object
        print(object)
    }
}
