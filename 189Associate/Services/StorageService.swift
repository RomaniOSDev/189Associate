import Foundation

protocol StorageServiceProtocol {
    func save<T: Codable>(_ items: [T], forKey key: String)
    func load<T: Codable>(forKey key: String) -> [T]
    func delete(forKey key: String)
    func append<T: Codable>(_ item: T, forKey key: String)
    func update<T: Codable>(_ item: T, forKey key: String) where T: Identifiable
}

final class UserDefaultsStorageService: StorageServiceProtocol {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func save<T: Codable>(_ items: [T], forKey key: String) {
        guard let data = try? encoder.encode(items) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    func load<T: Codable>(forKey key: String) -> [T] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let items = try? decoder.decode([T].self, from: data) else {
            return []
        }
        return items
    }

    func delete(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }

    func append<T: Codable>(_ item: T, forKey key: String) {
        var items: [T] = load(forKey: key)
        items.append(item)
        save(items, forKey: key)
    }

    func update<T: Codable>(_ item: T, forKey key: String) where T: Identifiable {
        var items: [T] = load(forKey: key)
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            save(items, forKey: key)
        }
    }
}
