import Vapor
import Fluent

struct CategoryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {

        let superUserMiddleware = SuperUserAuthMiddleware()
        let midUserMiddleware = MidUserAuthMiddleware()
        let userMiddleware = UserAuthMiddleware()
        let categories = routes.grouped("category")
      
        let categoriesAuthSuperUser = categories.grouped(superUserMiddleware)
        let categoriesAuthMidUser = categories.grouped(midUserMiddleware)
        let categoriesAuthUser = categories.grouped(userMiddleware)
    
        categoriesAuthSuperUser.delete(":categoryID", use: delete)

        categoriesAuthMidUser.get(use: index)
        categoriesAuthMidUser.get("count", use: indexCount)
        categoriesAuthMidUser.post(use: create)
        categoriesAuthMidUser.group(":categoryID") { category in
            category.put(use: update)
            category.get(use: indexById)
        }

        categoriesAuthUser.get(use: index)
    }

    func index(req: Request) throws -> EventLoopFuture<[Category]> {
        return Category.query(on: req.db).sort(\.$title).all()
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
    
    
    func indexById(req: Request) -> EventLoopFuture<Category> {
        return Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.noContent))       
    }

    func create(req: Request) throws -> EventLoopFuture<Category> {
        let category = try req.content.decode(Category.self)
        return category.save(on: req.db).map { category }
    }

    func update(req: Request) throws -> EventLoopFuture<Category> {
        let category = try req.content.decode(UpdateCategory.self)

        return Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { db in
                db.description =  category.description
                db.image_featured = category.image_featured
                db.icon = category.icon

                return
                   db.save(on: req.db).map{db}
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
