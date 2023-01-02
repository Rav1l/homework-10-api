import Foundation

// MARK: - ResultElement
struct Photo: Codable {
    let id, author: String
    let width, height: Int
    let url, downloadUrl: String

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadUrl = "download_url"
    }
}
