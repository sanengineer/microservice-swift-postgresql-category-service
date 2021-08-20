import Fluent

struct AddSomeColumnOnCategorySchema:Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("categories")
            .field("image_featured", .string)
            .field("icon", .string)
            .update()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("categories")
            .delete()
    }
}
