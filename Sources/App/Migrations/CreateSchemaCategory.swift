import Fluent

struct CreateSchemaCategory: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("categories")
            .id()
            .field("title", .sql(raw: "character varying(100)"), .required)
            .field("description", .sql(raw: "text"))
            .field("product_id", .uuid, .references("products", "id"))
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "title")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("categories").delete()
    }
}
