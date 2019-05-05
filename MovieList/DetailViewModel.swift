//
//  DetailViewModel.swift
//  MovieList
//
//  Created by coreylin on 8/18/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

import RxSwift

protocol DetailViewModelProtocol {
  var inputs: DetailViewModelInputs { get }
  var outputs: DetailViewModelOutputs { get }
}

protocol DetailViewModelInputs {
  func viewDidLoad()
}

protocol DetailViewModelOutputs {
  var backdropURLStream: Observable<URL?> { get }
  var titleStream: Observable<String?> { get }
  var popularityStream: Observable<String?> { get }
  var synopsisStream: Observable<String?> { get }
  var genresStream: Observable<String?> { get }
  var languageStream: Observable<String?> { get }
  var durationStream: Observable<String?> { get }
}

final class DetailViewModel: DetailViewModelProtocol, DetailViewModelInputs, DetailViewModelOutputs {
  var inputs: DetailViewModelInputs { return self }
  var outputs: DetailViewModelOutputs { return self }

  private let movieService: MovieService
  private let movieId: Int
  private var loadMovieDetailSubscription: Disposable?

  init(movieId: Int, movieService: MovieService) {
    self.movieId = movieId
    self.movieService = movieService
  }

  deinit {
    loadMovieDetailSubscription = nil
  }

  private func publishMovieDetail(_ movieDetail: MovieDetail) {
    titlePublish.onNext(movieDetail.title)
    popularityPublish.onNext(String(movieDetail.popularity ?? 0))
    synopsisPublish.onNext(movieDetail.overview)
    genresPublish.onNext(movieDetail.genres.joined(separator: ", "))
    languagePublish.onNext(movieDetail.spokenLanguages.joined(separator: ", "))
    durationPublish.onNext(String(movieDetail.runtime ?? 0))
    if let backdropPath = movieDetail.backdropPath {
      backdropURLPublish.onNext(URL(string: "http://image.tmdb.org/t/p/w185" + backdropPath))
    } else {
      backdropURLPublish.onNext(nil)
    }
  }

  // MARK: - Inputs

  func viewDidLoad() {
    loadMovieDetailSubscription = movieService.loadMovieDetail(id: movieId)
      .subscribe(onSuccess: { [unowned self ] movieDetail in
        self.publishMovieDetail(movieDetail)
      })
  }

  // MARK: - Outputs

  private let backdropURLPublish = PublishSubject<URL?>()
  var backdropURLStream: Observable<URL?> {
    return backdropURLPublish
  }

  private let titlePublish = PublishSubject<String?>()
  var titleStream: Observable<String?> {
    return titlePublish
  }

  private let popularityPublish = PublishSubject<String?>()
  var popularityStream: Observable<String?> {
    return popularityPublish
  }

  private let synopsisPublish = PublishSubject<String?>()
  var synopsisStream: Observable<String?> {
    return synopsisPublish
  }

  private let genresPublish = PublishSubject<String?>()
  var genresStream: Observable<String?> {
    return genresPublish
  }

  private let languagePublish = PublishSubject<String?>()
  var languageStream: Observable<String?> {
    return languagePublish
  }

  private let durationPublish = PublishSubject<String?>()
  var durationStream: Observable<String?> {
    return durationPublish
  }

}
