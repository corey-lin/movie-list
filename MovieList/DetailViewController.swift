//
//  DetailViewController.swift
//  MovieList
//
//  Created by coreylin on 8/18/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class DetailViewController: UIViewController {

  private let disposeBag = DisposeBag()
  private let viewModel: DetailViewModel
  private let bookMovieURLString = "https://www.cathaycineplexes.com.sg/"

  private let scrollableContainerView: UIScrollView = {
    let scrollView = UIScrollView()
    return scrollView
  }()

  private let contentView = UIView()

  private let backdropImageView: UIImageView = {
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

  private let synopsisInfoFieldView: InfoFieldView = {
    let view = InfoFieldView()
    view.name = "Synopsis:"
    return view
  }()

  private let genresInfoFieldView: InfoFieldView = {
    let view = InfoFieldView()
    view.name = "Genres:"
    return view
  }()

  private let languageInfoFieldView: InfoFieldView = {
    let view = InfoFieldView()
    view.name = "Language:"
    return view
  }()

  private let durationInfoFieldView: InfoFieldView = {
    let view = InfoFieldView()
    view.name = "Duration:"
    return view
  }()

  private let bookButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .gray
    button.setTitle("Book the movie", for: .normal)
    return button
  }()

  // MARK: - Life Cycle

  init(viewModel: DetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    title = "Detail"
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
    setupSubscriptions()

    viewModel.inputs.viewDidLoad()
  }

  // MAKR: - View Setup

  private func setupViews() {
    view.backgroundColor = .white
    view.addSubview(scrollableContainerView)
    scrollableContainerView.addSubview(contentView)
    contentView.addSubview(backdropImageView)
    contentView.addSubview(titleInfoFieldView)
    contentView.addSubview(popularityInfoFieldView)
    contentView.addSubview(synopsisInfoFieldView)
    contentView.addSubview(genresInfoFieldView)
    contentView.addSubview(languageInfoFieldView)
    contentView.addSubview(durationInfoFieldView)
    view.addSubview(bookButton)
  }

  private func setupConstraints() {
    scrollableContainerView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }
    contentView.snp.makeConstraints { make in
      make.width.equalTo(UIScreen.main.bounds.width)
      make.edges.equalToSuperview()
    }
    backdropImageView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }

    let infoFieldViews = [
      titleInfoFieldView,
      popularityInfoFieldView,
      synopsisInfoFieldView,
      genresInfoFieldView,
      languageInfoFieldView,
      durationInfoFieldView
    ]

    infoFieldViews.first?.snp.makeConstraints { make in
      make.top.equalTo(backdropImageView.snp.bottom).offset(26)
      make.left.equalToSuperview().offset(16)
      make.right.equalToSuperview().offset(-16)
    }
    infoFieldViews.forEachPair { prevView, curView in
      curView.snp.makeConstraints { make in
        make.top.equalTo(prevView.snp.bottom).offset(16)
        make.left.equalTo(prevView)
        make.right.equalTo(prevView)
      }
    }
    infoFieldViews.last?.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-5)
    }

    bookButton.snp.makeConstraints { make in
      make.top.equalTo(scrollableContainerView.snp.bottom)
      make.left.right.bottom.equalToSuperview()
      make.height.equalTo(40)
    }
  }

  private func setupSubscriptions() {
    bookButton.rx.tap.subscribe(onNext: { [unowned self] in
      let viewController = BookMovieWebViewController(urlString: self.bookMovieURLString)
      self.navigationController?.pushViewController(viewController, animated: true)
    }).disposed(by: disposeBag)

    viewModel.titleStream.subscribe(onNext: { [unowned self] title in
      self.titleInfoFieldView.value = title
    }).disposed(by: disposeBag)

    viewModel.popularityStream.subscribe(onNext: { [unowned self] popularity in
      self.popularityInfoFieldView.value = popularity
    }).disposed(by: disposeBag)

    viewModel.synopsisStream.subscribe(onNext: { [unowned self] synopsis in
      self.synopsisInfoFieldView.value = synopsis
    }).disposed(by: disposeBag)

    viewModel.genresStream.subscribe(onNext: { [unowned self] genres in
      self.genresInfoFieldView.value = genres
    }).disposed(by: disposeBag)

    viewModel.languageStream.subscribe(onNext: { [unowned self] language in
      self.languageInfoFieldView.value = language
    }).disposed(by: disposeBag)

    viewModel.durationStream.subscribe(onNext: { [unowned self] duration in
      self.durationInfoFieldView.value = duration
    }).disposed(by: disposeBag)

    viewModel.backdropURLStream.subscribe(onNext: { [unowned self] backdropURL in
      self.backdropImageView.kf.setImage(with: backdropURL, placeholder: UIImage(named: "poster_placeholder"))
    }).disposed(by: disposeBag)
  }

}
