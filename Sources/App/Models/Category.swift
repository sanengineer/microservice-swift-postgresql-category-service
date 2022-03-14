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
    
    @OptionalField(key: "icon")
    var icon: String?
    
    @OptionalField(key: "image_featured")
    var image_featured: String?
    
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

final class CategoryNumbers: Content, Codable {

    var number: Int

    init(number: Int) {
        self.number = number
    }
}


final class UpdateCategory: Content, Codable {
    var title: String?
    var description: String?
    var icon: String?
    var image_featured: String?

    init(title: String? ,description: String?, icon: String?, image_featured: String?) {
        self.title = title
        self.description = description
        self.icon = icon
        self.image_featured = image_featured
    }
}