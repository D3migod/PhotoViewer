//
//  FeedWireframe.swift
//  PhotoViewer
//
//  Created by Bulat Galiev on 4/27/21.
//

import UIKit

final class FeedWireframe: FeedWireframeInput {
  private static let mainStoryboardIdentifier = "Main"
  
  class func createConnections() -> UIViewController {
    let dataManagerFactory = FlickrRemoteDataManagerFactory()
    let remoteDataManager: FeedRemoteDataManagerInput = dataManagerFactory.createFeedDataManager()
    
    var interactor: FeedInteractorInput & FeedInteractorCore = FeedInteractor(remoteDatamanager: remoteDataManager)
    
    var presenter: FeedViewOutputDelegate &
      FeedPresenterCore &
      FeedInteractorOutputDelegate = FeedPresenter(interactor: interactor)
    interactor.outputDelegate = presenter
    
    let controller = FeedViewController()
    controller.outputDelegate = presenter
    presenter.view = controller
    
    return controller
  }
}
