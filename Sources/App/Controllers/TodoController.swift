import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        return Todo.query(on: req).all()
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap { todo in
            return todo.save(on: req)
        }
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
    
    func heavyDatabaseOperation(_ req: Request) throws -> Future<Todo> {
        let todo = Todo(id: nil, title: "title")
        
        var future = todo.save(on: req)
        
        for i in 0..<100 {
            future = future.flatMap { todo in
                todo.title = "title\(i)"
                return todo.save(on: req)
            }
        }
        
        return future
    }
}
