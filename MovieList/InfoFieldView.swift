//
//  InfoFieldView.swift
//  MovieList
//
//  Created by coreylin on 8/18/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

import UIKit

final class InfoFieldView: UIView {

  fileprivate let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
    return label
  }()

  fileprivate let valueLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()

  // MARK: - Life Cycle

  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupViews()
    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: -

  private func setupViews() {
    addSubview(nameLabel)
    addSubview(valueLabel)
  }

  private func setupConstraints() {
    nameLabel.snp.makeConstraints { make in
      make.left.top.equalToSuperview()
      make.centerY.equalTo(valueLabel)
    }
    valueLabel.snp.makeConstraints { make in
      make.left.equalTo(nameLabel.snp.right).offset(8)
      make.right.top.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
}

extension InfoFieldView {
  var name: String? {
    set {
      nameLabel.text = newValue
    }
    get {
      return nameLabel.text
    }
  }

  var value: String? {
    set {
      valueLabel.text = newValue
    }
    get {
      return valueLabel.text
    }
  }
}
