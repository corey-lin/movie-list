//
//  DefaultMovieService.swift
//  MovieList
//
//  Created by coreylin on 8/18/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultMovieService: MovieService {

  private let tmdbHTTPClient = TMDbHTTPClient()

  private let releaseDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    return dateFormatter
  }()

  func loadMovies(lessThanOrEqual releaseDate: Date, page: Int) -> Single<MovieList> {
    let releaseDateLessThanOrEqual = releaseDateFormatter.string(from: releaseDate)
    return tmdbHTTPClient.getMovies(releaseDateLessThanOrEqual: releaseDateLessThanOrEqual, page: page)
  }

  func loadMovieDetail(id: Int) -> Single<MovieDetail> {
    return tmdbHTTPClient.getMovieDetail(id: id)
  }

}
