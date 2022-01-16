import Vapor

final class AuthMiddleware: Middleware {
    let authHostname: String = Environment.get("AUTH_HOSTNAME")!
    let authPort: Int = Int(Environment.get("AUTH_PORT")!)!
    
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard let token = request.headers.bearerAuthorization else {
            return request.eventLoop.future(error: Abort(.unauthorized))
        }
        
        //debug
        print("\n", "TOKEN", token, "\n")
        
        return request
            .client
            .post("http://\(authHostname):\(authPort)/user/auth/authenticate", beforeSend: { authRequest in
                //debug
                print("\n","AUTH_REQUEST",authRequest,"\n")
                
                try authRequest.content.encode(AuthenticateData(token: token.token))
            })
            .flatMapThrowing { ClientResponse in
                guard ClientResponse.status == .ok else {
                    if ClientResponse.status == .unauthorized {
                        throw Abort (.unauthorized)
                    } else {
                        throw Abort (.internalServerError)
                    }
                }
                
                let user = try ClientResponse.content.decode(User.self)
                
                //debug
                print("\n","RESPONSE:\n", ClientResponse,"\n")
                print("\n","USER:", user,"\n")
                
                request.auth.login(user)
            }
            .flatMap {
                return next.respond(to: request)
            }
    }
}


