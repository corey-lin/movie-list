//
//  HomeViewModel.swift
//  MovieList
//
//  Created by coreylin on 8/18/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeViewModelProtocol {
  var inputs: HomeViewModelInputs { get }
  var outputs: HomeViewModelOutputs { get }
}

protocol HomeViewModelInputs {
  func viewDidLoad()
  func pullToRefresh()
  func willDisplayLoadingCell()
}

protocol HomeViewModelOutputs {
  func getDetailViewModel(index: Int) -> DetailViewModel?
  var moviesStream: Observable<[Movie]> { get }
  var movies: [Movie] { get }
  var hasMoreMoviesToLoad: Bool { get }
}

final class HomeViewModel: HomeViewModelProtocol, HomeViewModelInputs, HomeViewModelOutputs {
  var inputs: HomeViewModelInputs { return self }
  var outputs: HomeViewModelOutputs { return self }

  private let movieService: MovieService
  private var loadMoviesSubscription: Disposable?
  private var totalPage = 0
  private var loadedPage = 0

  init(movieService: MovieService) {
    self.movieService = movieService
  }

  deinit {
    loadMoviesSubscription = nil
  }

  private func loadMovies() {
    loadMoviesSubscription = movieService.loadMovies(lessThanOrEqual: Date(), page: loadedPage + 1)
      .subscribe(onSuccess: { [unowned self] response in
        self.totalPage = response.totalPages
        self.loadedPage = response.page
        self.moviesVariable.value.append(contentsOf: response.movies)
      }, onError: {
        print($0)
      })
  }

  private func resetMoviesVariable() {
    totalPage = 0
    loadedPage = 0
    moviesVariable.value = []
  }

  // MARK: - Inputs

  func viewDidLoad() {
    resetMoviesVariable()
    loadMovies()
  }

  func pullToRefresh() {
    resetMoviesVariable()
    loadMovies()
  }

  func willDisplayLoadingCell() {
    loadMovies()
  }

  // MAKR: - Outputs
  private let moviesVariable = Variable<[Movie]>([])
  var moviesStream: Observable<[Movie]> {
    return moviesVariable.asObservable()
  }
  var movies: [Movie] {
    return moviesVariable.value
  }

  var hasMoreMoviesToLoad: Bool {
    return loadedPage < totalPage
  }

  func getDetailViewModel(index: Int) -> DetailViewModel? {
    return DetailViewModel(movieId: movies[index].id, movieService: movieService)
  }

}

extension Movie: MovieListCellInfo {
  var posterURL: URL? {
    guard let posterPath = posterPath else { return nil }
    return URL(string: "http://image.tmdb.org/t/p/w185" + posterPath)
  }

  var popularityString: String? {
    guard let popularity = popularity else { return nil }
    return String(popularity)
  }
}

extension MovieList {
  var hasMoreMoviesToLoad: Bool {
    return page < totalPages
  }
}
