import Foundation
import APIKit
import SwiftKnex

let environment = ProcessInfo.processInfo.environment
let dbHost = environment["DB_HOST"]!
let dbUser = environment["DB_USER"]!
let dbPassword = environment["DB_PASS"]!
let dbPort = UInt(environment["DB_PORT"]!)!

let dbName = "nicovideo"
let videosTableName = "videos"

let config = KnexConfig(
   host: dbHost,
   port: dbPort,
   user: dbUser,
   password: dbPassword,
   database: dbName,
   isShowSQLLog: true
)

do {
    let connection = try KnexConnection(config: config)
    let knex = connection.knex()

    let create =  queryToCreateVideosTableMake(videosTableName)
    try knex.execRaw(sql: create.toDDL())
    let result = try knex.insert(into: videosTableName, values: [
        "contentId": "sm1097445",
        "title": "【初音ミク】みくみくにしてあげる♪【してやんよ】",
        "viewCounter": 11904784
    ])
    let results = try knex.table(videosTableName).fetch()
    print(results)
    let drop = Drop(table: videosTableName)
    try knex.execRaw(sql: drop.toDDL())
} catch let error {
    print(error)
}

let request = NicovideoAPI.SearchRequest(service: .video, q: "初音ミク", targets: "title", fields: "title", filters: nil, _sort: "-viewCounter", _offset: nil, _limit: nil, _context: "net.terminal-end.Chamomile")

var keepAlive = true
let runLoop = RunLoop.current

Session.send(request) { result in
    print(result)
    keepAlive = false
}
while keepAlive && runLoop.run(mode: .defaultRunLoopMode, before: Date(timeIntervalSinceNow: 0.1)) {
}

