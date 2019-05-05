//
//  TMDbAPIService.swift
//  MovieList
//
//  Created by coreylin on 8/18/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

import Moya

enum TMDbAPIService {
  static let apiKey = "328c283cd27bd1877d9080ccb1604c91"

  case getMovies(releaseDateLessThanOrEqual: String, page: Int)
  case getMovieDetail(id: Int)
}

extension TMDbAPIService: TargetType {
  var headers: [String: String]? {
    return nil
  }

  var baseURL: URL {
    return URL(string: "http://api.themoviedb.org/3")!
  }

  var path: String {
    switch self {
    case .getMovies:
      return "/discover/movie"
    case .getMovieDetail(let id):
      return "/movie/\(id)"
    }
  }

  var method: Method {
    return .get
  }

  var sampleData: Data {
    return Data()
  }

  var task: Task {
    switch self {
    case .getMovies(let releaseDateLessThanOrEqual, let page):
      var parameters: [String: Any] = ["api_key": TMDbAPIService.apiKey]
      parameters["primary_release_date.lte"] = releaseDateLessThanOrEqual
      parameters["sort_by"] = "release_date.desc"
      parameters["page"] = page
      return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    case .getMovieDetail:
      return .requestPlain
    }
  }

}
