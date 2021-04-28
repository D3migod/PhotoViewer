//
//  FeedInteractor.swift
//  PhotoViewer
//
//  Created by Bulat Galiev on 4/27/21.
//

import Foundation

class FeedInteractor: FeedInteractorCore {
  weak var outputDelegate: FeedInteractorOutputDelegate?
  
  private var remoteDatamanager: FeedRemoteDataManagerInput?
  
  private let dataLoadingQueue = DispatchQueue.global()
  private let imageLoadingQueue = DispatchQueue(label: "imageLoadingQueue", qos: .utility)
  
  init(
    remoteDatamanager: FeedRemoteDataManagerInput?
  ) {
    self.remoteDatamanager = remoteDatamanager
  }
}

extension FeedInteractor: FeedInteractorInput {
  func loadImageData(urlString: String, completion: @escaping (Data) -> Void) -> Cancelable? {
    let networkRouter = NetworkRouter() // TODO: Make repeatable network requests
    imageLoadingQueue.async {
      networkRouter.data(.get, path: urlString, parameters: nil) { data, _, error in
        guard let data = data, error == nil else {
          print("Image loading \(error?.localizedDescription ?? "failed")")
          return
        }
        completion(data)
      }
    }
    return networkRouter
  }
  
  func load(page: Page, callbackQueue: DispatchQueue) {
    // TODO: Check internet connection
    dataLoadingQueue.async {
      self.remoteDatamanager?.getFeed(page: page) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .failure(let error):
          callbackQueue.async {
            self.outputDelegate?.didFailToLoadPhotos(with: error, for: page)
          }
        case .success(let Feed):
          callbackQueue.async {
            self.outputDelegate?.didLoadPhotos(Feed, for: page)
          }
        }
      }
    }
  }
}
