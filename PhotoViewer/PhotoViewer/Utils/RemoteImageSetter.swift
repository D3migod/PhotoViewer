//
//  RemoteImageHolder.swift
//  PhotoViewer
//
//  Created by Bulat Galiev on 4/26/21.
//

import UIKit

final class RemoteImageSetter {
  typealias LoadData = (String, @escaping (Data)->Void) -> Cancelable?
  private let urlString: String
  private let placeholder: UIImage?
  private let loadData: LoadData
  public private(set) weak var image: UIImage?
  private let imageQueue = DispatchQueue(label: "imageProcessingQueue", qos: .userInitiated)
  
  init(urlString: String, placeholder: UIImage?, loadData: @escaping LoadData) {
    self.urlString = urlString
    self.placeholder = placeholder
    self.loadData = loadData
  }
  
  @discardableResult
  func requestImage(completion: ((UIImage)->Void)? = nil) -> Cancelable? {
    if let image = image {
      completion?(image)
      return nil
    }
    let task = loadData(urlString) { [weak self] data in
      guard let self = self else { return }
      if let image = self.image {
        DispatchQueue.main.async {
          completion?(image)
        }
        return
      }
      
      self.imageQueue.async { [weak self] in
        guard let self = self, let loadedImage = UIImage(data: data) else {
          return
        }
        self.image = loadedImage
        DispatchQueue.main.async {
          completion?(loadedImage)
        }
      }
    }
    guard let placeholder = placeholder else { return task }
    completion?(placeholder)
    return task
  }
}
