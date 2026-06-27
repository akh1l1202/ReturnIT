import Foundation

struct LostFoundItem: Codable, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var category: String
    var status: ItemStatus
    var location: String
    var date: String
    var description: String
    var imageFileName: String?
    
    var posterEmail: String?
    var posterResolved: Bool = false
    var finderResolvedEmail: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case title
        case category
        case status
        case location
        case date
        case description
        case imageFileName
        case posterEmail
        case posterResolved
        case finderResolvedEmail
    }
    
    init(id: String = UUID().uuidString, name: String, category: String, status: ItemStatus, location: String, date: String, description: String, imageFileName: String? = nil, posterEmail: String? = nil, posterResolved: Bool = false, finderResolvedEmail: String? = nil) {
        self.id = id
        self.name = name
        self.category = category
        self.status = status
        self.location = location
        self.date = date
        self.description = description
        self.imageFileName = imageFileName
        self.posterEmail = posterEmail
        self.posterResolved = posterResolved
        self.finderResolvedEmail = finderResolvedEmail
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        
        // Handle fallback from 'title' to 'name'
        if let nameDecoded = try container.decodeIfPresent(String.self, forKey: .name) {
            self.name = nameDecoded
        } else if let titleDecoded = try container.decodeIfPresent(String.self, forKey: .title) {
            self.name = titleDecoded
        } else {
            self.name = "Unknown"
        }
        
        self.category = try container.decodeIfPresent(String.self, forKey: .category) ?? "Unknown"
        
        // Handle raw string to enum conversion safely
        if let statusString = try container.decodeIfPresent(String.self, forKey: .status) {
            self.status = ItemStatus(rawValue: statusString.lowercased()) ?? .lost
        } else if let statusEnum = try container.decodeIfPresent(ItemStatus.self, forKey: .status) {
            self.status = statusEnum
        } else {
            self.status = .lost
        }
        
        self.location = try container.decodeIfPresent(String.self, forKey: .location) ?? "Unknown"
        self.date = try container.decodeIfPresent(String.self, forKey: .date) ?? "Unknown"
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? "No description"
        self.imageFileName = try container.decodeIfPresent(String.self, forKey: .imageFileName)
        self.posterEmail = try container.decodeIfPresent(String.self, forKey: .posterEmail)
        self.posterResolved = try container.decodeIfPresent(Bool.self, forKey: .posterResolved) ?? false
        self.finderResolvedEmail = try container.decodeIfPresent(String.self, forKey: .finderResolvedEmail)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(status.rawValue, forKey: .status)
        try container.encode(location, forKey: .location)
        try container.encode(date, forKey: .date)
        try container.encode(description, forKey: .description)
        try container.encodeIfPresent(imageFileName, forKey: .imageFileName)
        try container.encodeIfPresent(posterEmail, forKey: .posterEmail)
        try container.encode(posterResolved, forKey: .posterResolved)
        try container.encodeIfPresent(finderResolvedEmail, forKey: .finderResolvedEmail)
    }
}
