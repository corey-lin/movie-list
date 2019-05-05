//
//  Movie+Helpers.swift
//  MovieListTests
//
//  Created by coreylin on 8/19/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

@testable import MovieList
import Freddy

extension Movie {
  init(id: Int, title: String, popularity: Double, posterPath: String? = nil) {
    var dict: [String: JSON] = [
      "id": .int(id),
      "title": .string(title),
      "popularity": .double(popularity)
    ]
    if let posterPath = posterPath {
      dict["poster_path"] = .string(posterPath)
    }
    try! self.init(json: JSON.dictionary(dict))
  }
}

extension Movie: JSONEncodable {
  public func toJSON() -> JSON {
    var dict: [String: JSON] = [
      "id": .int(id)
    ]
    if let title = title {
      dict["title"] = .string(title)
    }
    if let popularity = popularity {
      dict["popularity"] = .double(popularity)
    }
    if let posterPath = posterPath {
      dict["poster_path"] = .string(posterPath)
    }
    return JSON.dictionary(dict)
  }
}

extension Movie: Equatable {
  public static func == (lhs: Movie, rhs: Movie) -> Bool {
    if lhs.id == rhs.id,
      lhs.popularity == rhs.popularity,
      lhs.title == rhs.title,
      lhs.posterPath == rhs.posterPath {
      return true
    }
    return false
  }
}
