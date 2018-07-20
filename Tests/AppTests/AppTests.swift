import App
import XCTest
import Vapor

final class AppTests: XCTestCase {
    func testTwoRequest() throws {
        
        var config = Config.default()
        var env = try Environment.detect()
        var services = Services.default()
        
        try App.configure(&config, &env, &services)
        
        let app = try Application(
            config: config,
            environment: env,
            services: services
        )
        
        let req1 = Request(http: HTTPRequest(method: .POST, url: "/heavy"), using: app)
        let req2 = Request(http: HTTPRequest(method: .POST, url: "/heavy"), using: app)
        
        let res1 = try app.make(Responder.self).respond(to: req1)
        let res2 = try app.make(Responder.self).respond(to: req2)
        
        
        
        print(try res1.wait())
        print(try res2.wait())
    }
}
