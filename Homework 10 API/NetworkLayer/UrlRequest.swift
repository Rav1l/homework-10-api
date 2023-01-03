import Foundation

enum Request {
    case fetchMemes
    case fetchCharacters
    case fetchPhotos
    var urlString: String {
        switch self {
        case .fetchMemes:
            return "https://api.imgflip.com/get_memes"
        case .fetchCharacters:
            return "https://rickandmortyapi.com/api/character"
        case .fetchPhotos:
            return "https://picsum.photos/v2/list"
        }
    }
}
