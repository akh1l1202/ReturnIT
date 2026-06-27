import Foundation
import UIKit

class DataLoader {
    static let shared = DataLoader()
    
    private let fileManager = FileManager.default
    private let documentsURL: URL
    
    private let itemsFileName = ".items.json"
    private let usersFileName = ".users.json"
    
    var items: [LostFoundItem] = []
    var users: [User] = []
    var currentUser: User?
    
    private init() {
        documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("📁 JSON files are stored here: \(documentsURL.path)")
        loadAllData()
    }
    
    private func loadAllData() {
        loadItems()
        loadUsers()
    }
    
    // MARK: - Items Management
    
    func loadItems() {
        let fileURL = documentsURL.appendingPathComponent(itemsFileName)
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                items = try JSONDecoder().decode([LostFoundItem].self, from: data)
            } catch {
                print("Error decoding items from documents: \(error)")
                loadItemsFromBundle()
            }
        } else {
            loadItemsFromBundle()
        }
    }
    
    private func loadItemsFromBundle() {
        if let bundleURL = Bundle.main.url(forResource: "items", withExtension: "json") {
            do {
                let data = try Data(contentsOf: bundleURL)
                items = try JSONDecoder().decode([LostFoundItem].self, from: data)
                saveItems()
            } catch {
                print("Error decoding items from bundle: \(error)")
                initializeFallbackData()
            }
        } else {
            initializeFallbackData()
        }
    }
    
    private func initializeFallbackData() {
        items = [
            LostFoundItem(name: "Blue Water Bottle", category: "Accessories", status: .lost, location: "Library 2nd Floor", date: "Today", description: "A blue Hydro Flask with a campus sticker.", imageFileName: "item_1.jpg", posterEmail: "student@university.edu"),
            LostFoundItem(name: "AirPods Pro", category: "Electronics", status: .found, location: "Cafeteria", date: "Yesterday", description: "White AirPods Pro case, no name engraved.", imageFileName: "item_2.jpg", posterEmail: "student@university.edu"),
            LostFoundItem(name: "Calculus Textbook", category: "Books", status: .lost, location: "Math Building Rm 101", date: "Oct 26", description: "Stewart Calculus 8th Edition, slightly torn cover.", imageFileName: "item_3.jpg", posterEmail: "admin@university.edu")
        ]
        saveItems()
    }
    
    func saveItems() {
        let fileURL = documentsURL.appendingPathComponent(itemsFileName)
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: fileURL)
        } catch {
            print("Error encoding items: \(error)")
        }
    }
    
    func addItem(_ item: LostFoundItem) {
        items.insert(item, at: 0) // Newest first
        saveItems()
    }
    
    // MARK: - Users Management
    
    func loadUsers() {
        let fileURL = documentsURL.appendingPathComponent(usersFileName)
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                users = try JSONDecoder().decode([User].self, from: data)
            } catch {
                print("Error decoding users: \(error)")
            }
        }
    }
    
    func saveUsers() {
        let fileURL = documentsURL.appendingPathComponent(usersFileName)
        do {
            let data = try JSONEncoder().encode(users)
            try data.write(to: fileURL)
        } catch {
            print("Error encoding users: \(error)")
        }
    }
    
    func addUser(_ user: User) {
        users.append(user)
        saveUsers()
    }
    
    // MARK: - Image Helper
    func saveImage(_ image: UIImage, withName name: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let fileURL = documentsURL.appendingPathComponent(name)
        do {
            try data.write(to: fileURL)
            return name
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    func loadImage(named name: String) -> UIImage? {
        // First check documents directory (for user uploaded images)
        let fileURL = documentsURL.appendingPathComponent(name)
        if let image = UIImage(contentsOfFile: fileURL.path) {
            return image
        }
        // Then fallback to main bundle (for pre-initialized dummy data)
        return UIImage(named: name)
    }
}
