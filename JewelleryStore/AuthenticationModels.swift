import Foundation

struct AuthenticationRequest: Encodable {
    let username: String
    let password: String
}

struct AuthenticationResponse: Decodable {
    let success: Bool
    let token: String?
    let message: String?
}
