import Fluent
import Vapor

final class Category: Model, Content, Codable {
    static let schema = "categories"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    
    @OptionalField(key: "description")
    var description: String?
    
    @OptionalField(key: "product_id")
    var product_id: UUID?
    
    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
