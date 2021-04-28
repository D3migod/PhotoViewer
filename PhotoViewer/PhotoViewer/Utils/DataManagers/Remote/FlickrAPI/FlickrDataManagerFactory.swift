//
//  FlickrDataManagerFactory.swift
//  PhotoViewer
//
//  Created by Bulat Galiev on 4/26/21.
//

import Foundation

class FlickrRemoteDataManagerFactory {
  func createFeedDataManager() -> FeedRemoteDataManager {
    let remoteDataManager = RemoteDataManager<PhotosSearch>(apiEndpoint, networkRouter: NetworkRouter())
    return FeedRemoteDataManager(remoteDataManager: remoteDataManager)
  }
}

let apiEndpoint = "https://api.flickr.com/services"
