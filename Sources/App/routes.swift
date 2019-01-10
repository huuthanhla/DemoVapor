import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("hello", "vapor") { (req) in
        return "Hello Vapor !"
    }
    
    router.get("hello", String.parameter) { req -> String in
        let name = try req.parameters.next(String.self)
        return "Hello, \(name)"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
    
    
    router.post("info") { (req) -> Future<InfoResponse> in
        return try req.content
            .decode(InfoData.self)
            .map({ InfoResponse(request: $0) })
    }
    
    // Lession 5
    // https://www.raywenderlich.com/4493-server-side-swift-with-vapor/lessons/5
    router.get("date") { (req) in
        return "\(Date())"
    }
    
    router.get("counter", Int.parameter) { (req) -> CountJSON in
        let countValue = try req.parameters.next(Int.self)
        return CountJSON(count: countValue)
    }
    
    router.post("user-info") { (req) -> Future<String> in
        return try req.content.decode(InfoData.self)
            .map({ (user) -> String in
                return "Hello \(user.name), you are \(user.age)"
            })
    }
    
}

struct InfoData: Content {
    let name: String
    let age: Int
}

struct InfoResponse: Content {
    let request: InfoData
}

struct CountJSON: Content {
    let count: Int
}
