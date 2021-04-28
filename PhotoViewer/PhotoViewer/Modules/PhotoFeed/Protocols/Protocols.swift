//
//  Protocols.swift
//  PhotoViewer
//
//  Created by Bulat Galiev on 4/27/21.
//

import UIKit

protocol FeedWireframeInput {
  static func createConnections() -> UIViewController
}

protocol FeedInteractorCore {
  var outputDelegate: FeedInteractorOutputDelegate? { get set }
}

protocol FeedInteractorOutputDelegate: class {
  func didFailToLoadPhotos(with: Error, for page: Page)
  func didLoadPhotos(_ photos: [PhotoData], for page: Page)
}

protocol FeedRemoteDataManagerInput {
  func getFeed(page: Page, resultHandler: ((Result<[PhotoData]>)-> Void)?)
}

protocol FeedViewInput: class {
  var posts: [Post] { get set }
  var outputDelegate: FeedViewOutputDelegate! { get set }
  
  func showLoadingIndicator()
  
  func hideLoadingIndicator()
  
  func refreshData()
  
  func showAlert(title: String?, message: String?, okAction: ((UIAlertAction) -> Void)?)
}

protocol FeedViewOutputDelegate {
  func willLoadViewsAt(rowNumbers: [Int])
}

protocol FeedPresenterCore {
  var view: FeedViewInput! { get set }
}

protocol FeedInteractorInput {
  func load(page: Page, callbackQueue: DispatchQueue)
  func loadImageData(urlString: String, completion: @escaping (Data)->Void) -> Cancelable?
}

extension FeedInteractorInput {
  func load(page: Page, callbackQueue: DispatchQueue = DispatchQueue.main) {
    load(page: page, callbackQueue: callbackQueue)
  }
}
