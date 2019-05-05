//
//  BookMovieWebViewController.swift
//  MovieList
//
//  Created by coreylin on 8/18/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

import SnapKit
import WebKit

final class BookMovieWebViewController: UIViewController {

  private let webView: WKWebView = {
    let webView = WKWebView()
    return webView
  }()

  private let urlString: String

  public init(urlString: String) {
    self.urlString = urlString
    super.init(nibName: nil, bundle: nil)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override open func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()

    loadWebContent()
  }

  private func setupViews() {
    view.addSubview(webView)
  }

  private func setupConstraints() {
    webView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  public func loadWebContent() {
    guard let url = URL(string: urlString) else { return }
    let request = URLRequest(url: url)
    webView.load(request)
  }

  deinit {
    webView.stopLoading()
  }

}
