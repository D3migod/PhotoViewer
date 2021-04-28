//
//  UIViewController+ShowAlert.swift
//  PhotoViewer
//
//  Created by Bulat Galiev on 4/28/21.
//

import UIKit

extension UIViewController {
  func showAlert(title: String? = nil, message : String? = nil, okAction: ((UIAlertAction) -> Void)? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: LocalizationMock.Common.ok, style: UIAlertAction.Style.default, handler: okAction)
    alertController.addAction(okAction)
    self.present(alertController, animated: true, completion: nil)
  }
}
