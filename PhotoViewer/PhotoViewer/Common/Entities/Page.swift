//
//  Page.swift
//  PhotoViewer
//
//  Created by Bulat Galiev on 4/27/21.
//

import Foundation

enum Page: Equatable {
  case initial
  case next(index: Int) 
}

extension Page {
  var index: Int {
    switch self {
    case .initial:
      return 0
    case let .next(index: index):
      return index
    }
  }
}
