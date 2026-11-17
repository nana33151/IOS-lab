import Foundation

final class ProductsService {
    static let shared = ProductsService()
    private init() {}

    private let baseURL = "https://fakestoreapi.com"

    func fetchOrangeSection() async throws -> [Product] {
        try await NetworkService.shared.request(urlString: "\(baseURL)/products?limit=6")
    }

    func fetchGreenSection() async throws -> [Product] {
        try await NetworkService.shared.request(urlString: "\(baseURL)/products")
    }

    func fetchAll() async throws -> (orange: [Product], green: [Product]) {
        async let orange = fetchOrangeSection()
        async let green = fetchGreenSection()
        return try await (orange, green)
    }
}
