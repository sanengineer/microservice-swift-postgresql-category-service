import Fluent
import Vapor

final class Product: Model, Content, Codable {
    static let schema = "products"
    
    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?

    init() { }

    init(id: UUID? = nil) {
        self.id = id
    }
}
