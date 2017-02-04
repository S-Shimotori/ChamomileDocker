import Foundation
import PerfectLib
import MySQL
import PerfectHTTP
import APIKit

let env = ProcessInfo.processInfo.environment
let testHost = env["DB_HOST"]
let testUser = env["DB_USER"]
let testPassword = env["DB_PASS"]
let testPort = UInt32(env["DB_PORT"]!)!

let testSchema = "nicovideo"

let dataMysql = MySQL()

func useMysql() {
    guard dataMysql.connect(host: testHost, user: testUser, password: testPassword, port: testPort) else {
        Log.info(message: "Failure connecting to data server \(testHost)")
        return
    }
    defer {
        dataMysql.close()
    }
    print("connected.")
    guard dataMysql.selectDatabase(named: testSchema) && dataMysql.query(statement: "select * from users limit 1") else {
        Log.info(message: "Failure: \(dataMysql.errorCode()) \(dataMysql.errorMessage())")
        return
    }
    print("exec.")
    let results = dataMysql.storeResults()

    while let row = results?.next() {
        print(row)
    }
}

print("Hello, world!")
useMysql()

let request = NicovideoAPI.SearchVideosRequest(q: "初音ミク", targets: "title", fields: "title", filters: nil, _sort: "-viewCounter", _offset: nil, _limit: nil, _context: "net.terminal-end.Chamomile")

var keepAlive = true
let runLoop = RunLoop.current

Session.send(request) { result in
    print(result)
    keepAlive = false
}
while keepAlive && runLoop.run(mode: .defaultRunLoopMode, before: Date(timeIntervalSinceNow: 0.1)) {
}

