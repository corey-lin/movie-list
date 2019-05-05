//
//  MovieListCell.swift
//  MovieList
//
//  Created by coreylin on 8/18/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

protocol MovieListCellInfo {
  var title: String? { get }
  var popularityString: String? { get }
  var posterURL: URL? { get }
}

final class MovieListCell: UITableViewCell {
  static let cellReuseIdentifier = "MovieListCell"

  private let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private let titleInfoFieldView: InfoFieldView = {
    let view = InfoFieldView()
    view.name = "Title:"
    return view
  }()

  private let popularityInfoFieldView: InfoFieldView = {
    let view = InfoFieldView()
    view.name = "Popularity:"
    return view
  }()

  // MAKR: - Life Cycle

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    selectionStyle = .none
    contentView.addSubview(posterImageView)
    contentView.addSubview(titleInfoFieldView)
    contentView.addSubview(popularityInfoFieldView)
  }

  private func setupConstraints() {
    posterImageView.snp.makeConstraints { make in
      make.width.equalTo(92)
      make.left.equalToSuperview().offset(5)
      make.top.equalToSuperview()
      make.bottom.lessThanOrEqualToSuperview()
    }
    titleInfoFieldView.snp.makeConstraints { make in
      make.left.equalTo(posterImageView.snp.right).offset(5)
      make.right.equalToSuperview().offset(-10)
      make.top.equalToSuperview().offset(30)
    }
    popularityInfoFieldView.snp.makeConstraints { make in
      make.left.equalTo(posterImageView.snp.right).offset(5)
      make.top.equalTo(titleInfoFieldView.snp.bottom).offset(30)
      make.right.equalToSuperview().offset(-10)
      make.bottom.lessThanOrEqualToSuperview()
    }
  }

  // MARK: -

  func updateCell(with info: MovieListCellInfo) {
    titleInfoFieldView.value = info.title
    popularityInfoFieldView.value = info.popularityString
    posterImageView.kf.setImage(with: info.posterURL, placeholder: UIImage(named: "poster_placeholder"))
  }
}
