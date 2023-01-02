import Foundation

enum NetworkErrors: Error {
    case cancelled
    case customError(description: String)
    case noInternetConnectionError
    case serverError
    case parseError(reason: String)
    case unknownError
}

extension NetworkErrors: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .cancelled:
            return "Запрос отменен"
        case .customError(let description):
            return description
        case .noInternetConnectionError:
            return "Отсутствует интернет-соединение"
        case .serverError:
            return "Ошибка сервера"
        case .parseError(let reason):
            return "Ошибка в обработке ответа от сервера (\(reason)"
        case .unknownError:
            return "Неизвестная ошибка"
        }
    }
}
