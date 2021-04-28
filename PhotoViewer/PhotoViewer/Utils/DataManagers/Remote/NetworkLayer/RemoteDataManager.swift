//
//  RemoteDataManager.swift
//  PhotoViewer
//
//  Created by Bulat Galiev on 4/26/21.
//

import Foundation

enum NetworkError: Error {
  case noConnection
  case auth
  case badRequest
  case outdated
  case unknown
}

class RemoteDataManager<T: Decodable> {
  private let networkRouter: NetworkRouter
  private let endPoint: String
  
  init(_ endPoint: String, networkRouter: NetworkRouter) {
    self.endPoint = endPoint
    self.networkRouter = networkRouter
  }
  
  func getEntity(_ path: String, parameters: HTTPParameters?, resultHandler: ((Result<T>) -> Void)?) {
    networkRouter.data(.get,
                       path: "\(endPoint)/\(path)",
                       parameters: parameters) { [weak self] data, response, error in
      if let error = self?.checkError(response: response, error: error) {
        resultHandler?(Result.failure(error))
      } else {
        guard let data = data else { resultHandler?(Result.failure(NetworkError.noConnection)); return }
        do {
          let entities = try JSONDecoder().decode(T.self, from: data)
          resultHandler?(Result.success(entities))
        } catch {
          resultHandler?(Result.failure(error))
        }
      }
    }
  }
  
  func checkError(response: HTTPURLResponse?, error: Error?) -> Error? {
    guard error == nil else { return error }
    guard let response = response else { return NetworkError.noConnection }
    
    switch response.statusCode {
    case 200...299: return nil
    case 401...500: return NetworkError.auth
    case 501...599: return NetworkError.badRequest
    case 600: return NetworkError.badRequest
    default: return NetworkError.unknown
    }
  }
}

