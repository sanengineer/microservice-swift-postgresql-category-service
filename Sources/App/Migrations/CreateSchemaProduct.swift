import Fluent

struct CreateSchemaProduct: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("products")
            .id()
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("products").delete()
    }
}
