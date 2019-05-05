//
//  MovieList+Helpers.swift
//  MovieListTests
//
//  Created by coreylin on 8/19/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

@testable import MovieList
import Freddy

extension MovieList {
  init(page: Int, totalPages: Int, movies: [Movie]) {
    let json = JSON.dictionary([
      "page": .int(page),
      "total_pages": .int(totalPages),
      "results": .array(movies.map { $0.toJSON() })
    ])
    try! self.init(json: json)
  }
}
