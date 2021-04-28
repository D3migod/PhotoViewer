//
//  PhotosSearch.swift
//  PhotoViewer
//
//  Created by Bulat Galiev on 4/26/21.
//

import Foundation

struct PhotosSearch: Decodable {
  var photos: PhotosData
}

struct PhotosData: Decodable {
  var photo: [PhotoData]
}

struct PhotoData: Decodable {
  let id: String
  let secret: String
  let title: String
  let server: String
}
