//
//  TMDbHTTPClient.swift
//  MovieList
//
//  Created by coreylin on 8/18/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

import Moya
import RxSwift
import Freddy

final class TMDbHTTPClient {
  private let provider = MoyaProvider<TMDbAPIService>(plugins: [NetworkLoggerPlugin(verbose: true)])

  // MARK: - Requests

  func getMovies(releaseDateLessThanOrEqual: String, page: Int) -> Single<MovieList> {
    return provider
      .rx
      .request(.getMovies(releaseDateLessThanOrEqual: releaseDateLessThanOrEqual, page: page))
      .map { return try MovieList(json: JSON(data: $0.data)) }
  }

  func getMovieDetail(id: Int) -> Single<MovieDetail> {
    return provider
      .rx
      .request(.getMovieDetail(id: id))
      .map { return try MovieDetail(json: JSON(data: $0.data)) }
  }
}
