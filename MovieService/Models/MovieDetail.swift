//
//  MovieDetail.swift
//  MovieList
//
//  Created by coreylin on 8/19/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

import Freddy

struct MovieDetail: JSONDecodable {
  let id: Int
  let title: String?
  let popularity: Double?
  let backdropPath: String?
  let overview: String?
  let genres: [String]
  let spokenLanguages: [String]
  let runtime: Int? // in minutes

  init(json: JSON) throws {
    id = try json.getInt(at: "id")
    title = try? json.getString(at: "title")
    popularity = try? json.getDouble(at: "popularity")
    backdropPath = try? json.getString(at: "backdrop_path")
    overview = try? json.getString(at: "overview")
    genres = (try? json.getArray(at: "genres").map { try $0.getString(at: "name") }) ?? []
    spokenLanguages = (try? json.getArray(at: "spoken_languages").map { try $0.getString(at: "name")}) ?? []
    runtime = try? json.getInt(at: "runtime")
  }

  init(id: Int,
       title: String?,
       popularity: Double?,
       backdropPath: String?,
       overview: String?,
       genres: [String],
       spokenLanguages: [String],
       runtime: Int?) {
    self.id = id
    self.title = title
    self.popularity = popularity
    self.backdropPath = backdropPath
    self.overview = overview
    self.genres = genres
    self.spokenLanguages = spokenLanguages
    self.runtime = runtime
  }
}
