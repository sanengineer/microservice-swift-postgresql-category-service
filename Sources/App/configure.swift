import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    
    
    guard let serverHostname = Environment.get("CATEGORY_HOSTNAME") else {
        return print("No Env Server Hostname")
    }
    
    guard let dbName = Environment.get("DB_NAME") else {
        return print("No Env DB Name")
    }
    
    
    
    let serverPort: Int = Environment.get("CATEGORY_PORT").flatMap(Int.init(_:)) ?? 8081
    
    app.databases.use(.postgres(
        hostname: Environment.get("DB_HOSTNAME") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DB_USERNAME") ?? "vapor_username",
        password: Environment.get("DB_PASSWORD") ?? "vapor_password",
        database: dbName
    ), as: .psql)

    app.http.server.configuration.port = serverPort
    app.http.server.configuration.hostname = serverHostname
    app.migrations.add(CreateSchemaCategory(), CreateSchemaProduct())
    
    app.logger.logLevel = .debug

    // register routes
    try routes(app)
}
