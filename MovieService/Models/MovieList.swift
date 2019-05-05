//
//  MovieList.swift
//  MovieList
//
//  Created by coreylin on 8/18/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

import Freddy

struct MovieList: JSONDecodable {
  let page: Int
  let totalPages: Int
  let movies: [Movie]

  init(json: JSON) throws {
    page = try json.getInt(at: "page")
    totalPages = try json.getInt(at: "total_pages")
    movies = (try? json.decodedArray(at: "results")) ?? []
  }
}

struct Movie: JSONDecodable {
  let id: Int
  let title: String?
  let popularity: Double?
  let posterPath: String?

  init(json: JSON) throws {
    id = try json.getInt(at: "id")
    title = try? json.getString(at: "title")
    popularity = try? json.getDouble(at: "popularity")
    posterPath = try? json.getString(at: "poster_path")
  }

}
