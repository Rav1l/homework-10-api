import Foundation

protocol NetworkServiceProtocol {
    func getMemes(completion: @escaping (Result<Array<Mem>, NetworkError>) -> Void)
    func getCharacters(completion: @escaping (Result<Array<Character>, NetworkError>) -> Void)
    func getPhotos(completion: @escaping (Result<Array<Photo>, NetworkError>) -> Void)
}


final class NetworkService:NetworkServiceProtocol {
    
    
    private let mainQueue = DispatchQueue.main
    private var session: URLSession?
    
    func getMemes(completion: @escaping (Result<Array<Mem>, NetworkError>) -> Void) {
        fetch(request: .fetchMemes, struct: Memes.self) { result in
            do {
                let memes = try result.get().data.memes
                completion(Result.success(memes))
            } catch {
                completion(Result.failure(.parseError(reason: Request.fetchMemes.urlString)))
            }
        }
        
    }
    
    func getCharacters(completion: @escaping (Result<Array<Character>, NetworkError>) -> Void) {
        fetch(request: .fetchCharacters, struct: Characters.self) { result in
            do {
                let characters = try result.get().results
                completion(Result.success(characters))
            } catch {
                completion(Result.failure(.parseError(reason: Request.fetchCharacters.urlString)))
            }
            
        }
    }
    
    func getPhotos(completion: @escaping (Result<Array<Photo>, NetworkError>) -> Void) {
        fetch(request: .fetchPhotos, struct: Array<Photo>.self) { result in
            do {
                let photos = try result.get()
                completion(Result.success(photos))
            } catch {
                completion(Result.failure(.parseError(reason: Request.fetchPhotos.urlString)))
            }
        }
    }
    
    private func fetch<T: Codable>(request: Request, struct: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: request.urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data , response, error in
            guard let self = self else { return }
            
            if let error = error {
                self.mainQueue.async { completion(.failure(.customError(description: error.localizedDescription))) }
                return
            }
            
            guard let data = data else {
                self.mainQueue.async { completion(.failure(.serverError)) }
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(Result.success(decodedData))
            } catch {
                completion(Result.failure(.parseError(reason: "\(url)")))
            }
        }
        
        task.resume()
    }

}
