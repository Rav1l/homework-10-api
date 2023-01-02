import Foundation

typealias NetworkResult = Result<Array<Mem>, NetworkErrors>
typealias MemCompletion = (NetworkResult) -> Void
