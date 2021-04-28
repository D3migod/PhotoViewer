//
//  PostCell.swift
//  PhotoViewer
//
//  Created by Bulat Galiev on 4/26/21.
//

import UIKit

final class PostCell: UITableViewCell {
  private let titleLabel = UILabel()
  private let previewImageView = RemoteImageView()
  
  var post: Post! {
    didSet {
      updateContents()
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(titleLabel)
    addSubview(previewImageView)
    previewImageView.contentMode = .scaleAspectFill
    previewImageView.clipsToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func updateContents() {
    titleLabel.text = post.title
    titleLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 15)
    titleLabel.textColor = .black
    previewImageView.remoteImageSetter = post.imageSetter
    previewImageView.contentMode = .scaleAspectFill
    setNeedsLayout()
  }
  
  override func layoutSubviews() {
    let contentWidth = frame.width - sideInset*2
    previewImageView.frame = CGRect(x: sideInset, y: sideInset, width: contentWidth, height: 140)
    titleLabel.frame = CGRect(x: 10, y: previewImageView.frame.maxY, width: contentWidth, height: 30)
  }
}

private let sideInset: CGFloat = 10
