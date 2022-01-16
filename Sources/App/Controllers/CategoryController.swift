import Fluent
import Vapor

struct CategoryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categories = routes.grouped("category")
<<<<<<< HEAD
      
        let categoriesAuth = categories.grouped(AuthMiddleware())
    
        categoriesAuth.get(use: index)
        categoriesAuth.get("count", use: indexCount)
        categoriesAuth.post(use: create)
        categoriesAuth.group(":categoryID") { category in
            category.delete(use: delete)
            category.put(use: update)
            category.get(use: indexById)
        }
=======
        let categoriesAuth = categories.grouped(AuthMiddleware())

        categoriesAuth.get(use: index)
        categoriesAuth.get(":categoryID", use: indexById)
>>>>>>> 924ac1f03ad2db2a6a3c9e8826a3b52ceab9a531
    }

    func index(req: Request) throws -> EventLoopFuture<[Category]> {
        return Category.query(on: req.db).sort(\.$title).all()
    }
    
    
    func indexById(req: Request) -> EventLoopFuture<Category> {
        return Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.noContent))
            
    }
}
