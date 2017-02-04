struct NicovideoError: Error {
    let status: Int
    let errorCode: String
    let errorMessage: String

    init(object: Any) {
        let dictionary = object as? [String: Any]
        status = dictionary?["status"] as? Int ?? -1
        errorCode = dictionary?["errorCode"] as? String ?? "UNKNOWN_ERROR"
        errorMessage = dictionary?["errorMessage"] as? String ?? "Unknown error occurred."
    }
}
