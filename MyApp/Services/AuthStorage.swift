import Foundation

final class AuthStorage {
    static let shared = AuthStorage()
    static let sortAscendingKey = "isSortedAscending"

    private init() {}

    func save(login: String, password: String) {
        SimpleKeychain.save(Credentials(login: login, password: password))
    }

    func load() -> Credentials? {
        SimpleKeychain.load()
    }

    func clear() {
        SimpleKeychain.delete()
        UserDefaults.standard.removeObject(forKey: Self.sortAscendingKey)
    }

    var hasCredentials: Bool {
        load() != nil
    }
}
