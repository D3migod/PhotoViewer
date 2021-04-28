//
//  Result.swift
//  PhotoViewer
//
//  Created by Bulat Galiev on 4/26/21.
//

import Foundation

enum Result<Value> {
  case success(Value)
  case failure(Error)
}
