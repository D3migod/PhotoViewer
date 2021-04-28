//
//  NetworkRouter.swift
//  PhotoViewer
//
//  Created by Bulat Galiev on 4/26/21.
//

import Foundation

typealias JSONObject = [String: Any]
typealias AccessToken = String
typealias HTTPParameters = [String: String]
typealias HTTPHeaders = [String: String]


enum HTTPRequestMethod: String {
  case get = "GET"
}

final class NetworkRouter: Cancelable {
  private var task: URLSessionTask?
  
  func data(_ method: HTTPRequestMethod, path: String, parameters: HTTPParameters?, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
    let session = URLSession.shared
    guard let request = createRequest(URL(string: path), parameters: parameters, method: method) else { completion(nil, nil, NetworkError.badRequest); return }
    task = session.dataTask(with: request, completionHandler: { data, response, error in
      completion(data, response as? HTTPURLResponse, error)
    })
    self.task?.resume()
  }
  
  func cancel() {
    self.task?.cancel()
  }
  
  private func createRequest(_ url: URL?, parameters: HTTPParameters? = nil, bodyParameters: String? = nil, headers: HTTPHeaders? = nil, method: HTTPRequestMethod = .get) -> URLRequest? {
    guard let unwrappedUrl = url, var comps = URLComponents(string: unwrappedUrl.absoluteString) else {
      print("Incorrect url \(String(describing: url))")
      return nil
    }
    if let parameters = parameters {
      comps.queryItems = parameters.map(URLQueryItem.init)
    }
    
    guard let compsUrl = comps.url else {
      print("Incorrect parameters \(parameters ?? [:]) or url \(unwrappedUrl)")
      return nil
    }
    var request = URLRequest(url: compsUrl)
    if let bodyParameters = bodyParameters {
      request.httpBody = bodyParameters.data(using: .utf8)
    }
    request.httpMethod = method.rawValue
    headers?.forEach({request.setValue($0.1, forHTTPHeaderField: $0.0)})
    return request
  }
  
}
