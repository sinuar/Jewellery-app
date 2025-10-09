import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "http://localhost:3000" // Change to your backend URL

    // Generic GET request
    func get<T: Decodable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // Generic POST request
    func post<T: Decodable, U: Encodable>(endpoint: String, body: U, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    enum NetworkError: Error {
        case invalidURL
        case noData
    }

    // MARK: - Authentication
    func login(username: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let request = AuthRequest(username: username, password: password)
        post(endpoint: "/login", body: request, completion: completion)
    }

    func signup(username: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let request = AuthRequest(username: username, password: password)
        post(endpoint: "/signup", body: request, completion: completion)
    }
}
