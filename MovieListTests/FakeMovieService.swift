//
//  FakeMovieService.swift
//  MovieListTests
//
//  Created by coreylin on 8/19/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

@testable import MovieList
import RxSwift

final class FakeMovieService {

  fileprivate var movieListsDict = [Int: MovieList]()
  func stubMovieList(_ movieList: MovieList, forPage page: Int) {
    movieListsDict[page] = movieList
  }

  fileprivate var movieDetailsDict = [Int: MovieDetail]()
  func stubMovieDetail(_ movieDetail: MovieDetail, forId id: Int) {
    movieDetailsDict[id] = movieDetail
  }
}

extension FakeMovieService: MovieService {
  func loadMovies(lessThanOrEqual releaseDate: Date, page: Int) -> Single<MovieList> {
    if let movieList = movieListsDict[page] {
      return Single.just(movieList)
    }
    return Single.never()
  }

  func loadMovieDetail(id: Int) -> Single<MovieDetail> {
    if let movieDetail = movieDetailsDict[id] {
      return Single.just(movieDetail)
    }
    return Single.never()
  }
}
