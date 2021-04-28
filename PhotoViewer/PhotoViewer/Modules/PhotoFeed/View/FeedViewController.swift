//
//  ViewController.swift
//  PhotoViewer
//
//  Created by Bulat Galiev on 4/25/21.
//

import UIKit

final class FeedViewController: UIViewController, FeedViewInput {
  private let tableView = UITableView()
  var outputDelegate: FeedViewOutputDelegate!
  
  var posts = [Post]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    setupAppearance()
  }
  
  override func viewWillLayoutSubviews() {
    tableView.frame = view.bounds
  }
  
  private func configureTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.allowsSelection = false
    tableView.prefetchDataSource = self
    tableView.tableFooterView = UIActivityIndicatorView()
    tableView.register(PostCell.self, forCellReuseIdentifier: String(describing: PostCell.self))
    tableView.separatorColor = .clear
  }
  
  private func setupAppearance() {
    view.addSubview(tableView)
    tableView.backgroundColor = .white
    self.navigationController?.setNavigationBarHidden(true, animated: true)
  }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    190
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard indexPath.row < posts.count,
          let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostCell.self), for: indexPath) as? PostCell else { return UITableViewCell() }
    cell.post = posts[indexPath.row]
    return cell
  }
}

extension FeedViewController {
  func showLoadingIndicator() {
    DispatchQueue.main.async {
      self.tableView.tableFooterView?.isHidden = false
    }
  }
  
  func hideLoadingIndicator() {
    DispatchQueue.main.async {
      self.tableView.tableFooterView?.isHidden = true
    }
  }
  
  func refreshData() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}

extension FeedViewController: UITableViewDataSourcePrefetching {
  public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    for indexPath in indexPaths {
      posts[indexPath.row].imageSetter.requestImage()
    }
    outputDelegate.willLoadViewsAt(rowNumbers: indexPaths.map{$0.row})
  }
}

