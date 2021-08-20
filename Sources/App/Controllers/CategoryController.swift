import Fluent
import Vapor

struct CategoryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categories = routes.grouped("category")
        let categoriesAuth = categories.grouped(AuthMiddleware())

        categoriesAuth.get(use: index)
        categoriesAuth.get(":categoryID", use: indexById)
    }

    func index(req: Request) throws -> EventLoopFuture<[Category]> {
        return Category.query(on: req.db).sort(\.$title).all()
    }
    
    
    func indexById(req: Request) -> EventLoopFuture<Category> {
        return Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.noContent))
            
    }
}
