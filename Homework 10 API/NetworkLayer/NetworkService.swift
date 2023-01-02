import Foundation

protocol NetworkServiceProtocol {
    func getMemes(url: String, completion: @escaping MemCompletion)
}

final class NetworkService:NetworkServiceProtocol {
    
    private let mainQueue = DispatchQueue.main
    private var session: URLSession?
    
    func getMemes(url: String, completion: @escaping MemCompletion) {
        guard let url = URL(string: url) else { return }
        
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
                let memes = try JSONDecoder().decode(Memes.self, from: data)
                completion(Result.success(memes.data.memes))
            } catch {
                completion(Result.failure(.parseError(reason: "\(url)")))
            }
        }
        
           task.resume()
    }

}
