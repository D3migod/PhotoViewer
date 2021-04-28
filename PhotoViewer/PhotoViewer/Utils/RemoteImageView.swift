//
//  RemoteImageView.swift
//  PhotoViewer
//
//  Created by Bulat Galiev on 4/26/21.
//

import UIKit

final class RemoteImageView: UIImageView {
  private var task: Cancelable?
  var remoteImageSetter: RemoteImageSetter? {
    didSet {
      task?.cancel()
      image = nil
      let currentImageSetter = remoteImageSetter
      task = remoteImageSetter?.requestImage { [weak self] image in
        guard let self = self, self.remoteImageSetter === currentImageSetter else {
          return
        }
        self.image = image
      }
    }
  }
}
