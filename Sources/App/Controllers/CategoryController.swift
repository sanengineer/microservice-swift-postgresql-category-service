import Fluent
import Vapor

struct CategoryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categories = routes.grouped("category")
        categories.get(use: index)
        categories.get("count", use: indexCount)
        categories.post(use: create)
        categories.group(":categoryID") { todo in
            todo.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Category]> {
        return Category.query(on: req.db).all()
    }
    
    func indexCount(req: Request) -> EventLoopFuture<CategoryNumbers> {
        return
            Category
            .query(on: req.db)
            .count()
            .map { number in
                CategoryNumbers(number: number)
            }
    }

    func create(req: Request) throws -> EventLoopFuture<Category> {
        let category = try req.content.decode(Category.self)
        return category.save(on: req.db).map { category }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
