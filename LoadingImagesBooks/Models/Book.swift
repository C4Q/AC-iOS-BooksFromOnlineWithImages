import Foundation

struct BookInfo: Codable {
    let totalItems: Int
    let items: [Book]
}

struct Book: Codable {
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let subtitle: String?
    let description: String?
    let imageLinks: ImageLinks?
}

struct ImageLinks: Codable {
    let smallThumbnail: String
    let thumbnail: String
}
