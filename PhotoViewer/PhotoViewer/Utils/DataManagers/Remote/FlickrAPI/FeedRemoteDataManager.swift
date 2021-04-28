//
//  FeedRemoteDataManager.swift
//  PhotoViewer
//
//  Created by Bulat Galiev on 4/27/21.
//

import Foundation

class FeedRemoteDataManager {
  private let remoteDataManager: RemoteDataManager<PhotosSearch>
  
  init(remoteDataManager: RemoteDataManager<PhotosSearch>) {
    self.remoteDataManager = remoteDataManager
  }
}

extension FeedRemoteDataManager: FeedRemoteDataManagerInput {
  func getFeed(page: Page, resultHandler: ((Result<[PhotoData]>) -> Void)?) {
    remoteDataManager.getEntity(path, parameters: ["method":"flickr.photos.getRecent", "api_key": apiKey, "format": "json", "nojsoncallback": "1", "page": "\(page.index)"]) { result in
      switch result {
      case let .failure(error):
        resultHandler?(Result.failure(error))
      case let .success(photosSearch):
        resultHandler?(Result.success(photosSearch.photos.photo))
      }
    }
  }
}

private let path = "rest"
private let apiKey = "38d48fadc2a47f9bda3a55dc6668c013" // TODO: obfuscate
