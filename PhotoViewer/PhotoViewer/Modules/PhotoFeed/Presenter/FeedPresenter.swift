//
//  FeedPresenter.swift
//  PhotoViewer
//
//  Created by Bulat Galiev on 4/26/21.
//

import Foundation

final class FeedPresenter: FeedPresenterCore {
  private var interactor: FeedInteractorInput!
  private var maxPage: Page = .initial
  weak var view: FeedViewInput!
  
  init(interactor: FeedInteractorInput) {
    self.interactor = interactor
    interactor.load(page: .initial)
  }
}

extension FeedPresenter: FeedViewOutputDelegate {
  func willLoadViewsAt(rowNumbers: [Int]) {
    // TODO: Handle repeated queries.
    guard let lastRowNumber = rowNumbers.last, lastRowNumber > view.posts.count-11 else { return }
    interactor?.load(page: maxPage.nextPage)
  }
}

extension FeedPresenter: FeedInteractorOutputDelegate {
  func didLoadPhotos(_ photos: [PhotoData], for page: Page) {
    defer { view.hideLoadingIndicator() }
    guard page == .initial || maxPage.index < page.index else { return }
    maxPage = page
    let newPosts = photos.compactMap { $0.post(loadData: interactor.loadImageData) }
    if page == .initial {
      view.posts = newPosts
    } else {
      view.posts += newPosts
    }
    view.refreshData()
  }
  
  
  func didFailToLoadPhotos(with error: Error, for page: Page) {
    print("ERROR: Failed to load feed for page \(page)") // TODO: Add logs
    DispatchQueue.main.async {
      self.view?.showAlert(title: LocalizationMock.LoadErrorAlert.title, // TODO: Add localization
                           message: LocalizationMock.LoadErrorAlert.message + error.localizedDescription,
                           okAction: { [weak self] _ in
                            // TODO: Reload failed page instead of initial
                            self?.interactor?.load(page: .initial)
                           })
    }
    view?.hideLoadingIndicator()
  }
}

private extension PhotoData {
  func post(loadData: @escaping RemoteImageSetter.LoadData) -> Post? {
    Post(
      imageSetter: RemoteImageSetter(urlString: feedPhotoUrlString, placeholder: #imageLiteral(resourceName: "cookpad_placeholder"), loadData: loadData),
      title: title
    )
  }
  
  var feedPhotoUrlString: String {
    "https://live.staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
  }
}

private extension Page {
  var nextPage: Page {
    switch self {
    case .initial:
      return .next(index: 1)
    case let .next(index):
      return .next(index: index + 1)
    }
  }
}
