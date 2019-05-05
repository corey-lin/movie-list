//
//  LoadingCell.swift
//  MovieList
//
//  Created by coreylin on 8/19/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

import UIKit
import SnapKit

final class LoadingCell: UITableViewCell {
  static let cellReuseIdentifier = "LoadingCell"

  private let loadingView = UIActivityIndicatorView(style: .gray)

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(loadingView)
    loadingView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.height.equalTo(50).priority(999)
    }
    loadingView.startAnimating()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    loadingView.startAnimating()
  }
}
