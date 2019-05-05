//
//  MovieService.swift
//  MovieList
//
//  Created by coreylin on 8/18/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

import Foundation
import RxSwift

protocol MovieService {
  func loadMovies(lessThanOrEqual releaseDate: Date, page: Int) -> Single<MovieList>
  func loadMovieDetail(id: Int) -> Single<MovieDetail>
}
