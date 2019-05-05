//
//  HomeViewController.swift
//  MovieList
//
//  Created by coreylin on 8/18/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
  private let disposeBag = DisposeBag()

  private lazy var movieListView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.register(MovieListCell.self, forCellReuseIdentifier: MovieListCell.cellReuseIdentifier)
    tableView.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.cellReuseIdentifier)
    tableView.dataSource = self
    tableView.delegate = self
    return tableView
  }()

  private lazy var listRefreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] in
      self.viewModel.inputs.pullToRefresh()
    }).disposed(by: self.disposeBag)
    return refreshControl
  }()

  fileprivate let viewModel: HomeViewModel

  // MARK: - Life Cycle

  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    title = "Home"
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

  // MARK: - View Setup

  private func setupViews() {
    view.addSubview(movieListView)
    movieListView.addSubview(listRefreshControl)
  }

  private func setupConstraints() {
    movieListView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func setupSubscriptions() {
    viewModel.outputs.moviesStream.subscribe(onNext: { [unowned self] _ in
      self.movieListView.reloadData()
      self.listRefreshControl.endRefreshing()
    }).disposed(by: disposeBag)
  }

}

extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numOfMovies = viewModel.outputs.movies.count

    // When it has more movies to load, add one loading cell at bottom
    return viewModel.outputs.hasMoreMoviesToLoad ? numOfMovies + 1 : numOfMovies
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellReuseIdentifier = indexPath.row == viewModel.outputs.movies.count
      ? LoadingCell.cellReuseIdentifier
      : MovieListCell.cellReuseIdentifier
    let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

    if let movieListCell = cell as? MovieListCell {
      movieListCell.updateCell(with: viewModel.outputs.movies[indexPath.row])
    }

    return cell
  }

}

extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let vm = viewModel.outputs.getDetailViewModel(index: indexPath.row) else { return }
    navigationController?.pushViewController(DetailViewController(viewModel: vm), animated: true)
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if cell is LoadingCell {
      viewModel.inputs.willDisplayLoadingCell()
    }
  }
}
