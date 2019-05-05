//
//  HomeViewModelTests.swift
//  MovieListTests
//
//  Created by coreylin on 8/19/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

import Quick
import Nimble
@testable import MovieList

final class HomeViewModelTests: QuickSpec {
  fileprivate var movieService: FakeMovieService!
  fileprivate var homeViewModel: HomeViewModel!

  override func spec() {
    super.spec()

    beforeEach {
      self.initialSetup()
    }

    describe("home screen, load the movies") {
      context("initial loading and has more movies to load") {
        let sampleMovies = buildSampleMovies(numOfMovies: 10)
        let movieList = MovieList(page: 1, totalPages: 10, movies: sampleMovies)
        beforeEach {
          self.stubMovieList(movieList: movieList)
          self.enterHomeScreen()
        }
        it("should have movies ready for viewing and more movies to load") {
          expect(self.homeViewModel.outputs.hasMoreMoviesToLoad) == true
          expect(self.homeViewModel.outputs.movies) == sampleMovies
        }

        context("load more movies") {
          let sampleMoreMovies = buildSampleMovies(numOfMovies: 10)
          let moreMovieList = MovieList(page: 2, totalPages: 10, movies: sampleMoreMovies)
          beforeEach {
            self.stubMovieList(movieList: moreMovieList)
            self.scrollToBottom()
          }
          it("should load more movies, and still have more movies to load") {
            expect(self.homeViewModel.outputs.hasMoreMoviesToLoad) == true
            expect(self.homeViewModel.outputs.movies) == sampleMovies + sampleMoreMovies
          }
        }

        context("pull to refreshh movies") {
          beforeEach {
            self.pullToRefresh()
          }
          it("should have movies ready for viewing and more movies to load") {
            expect(self.homeViewModel.outputs.hasMoreMoviesToLoad) == true
            expect(self.homeViewModel.outputs.movies) == sampleMovies
          }
        }
      }

      context("initial loading and only has one page of movies") {
        let sampleMovies = buildSampleMovies(numOfMovies: 10)
        let movieList = MovieList(page: 1, totalPages: 1, movies: sampleMovies)
        beforeEach {
          self.stubMovieList(movieList: movieList)
          self.enterHomeScreen()
        }
        it("should have movies ready for viewing, no more movies to load") {
          expect(self.homeViewModel.outputs.hasMoreMoviesToLoad) == false
          expect(self.homeViewModel.outputs.movies) == sampleMovies
        }
      }
    }
  }

}

private extension HomeViewModelTests {
  func initialSetup() {
    movieService = FakeMovieService()
    homeViewModel = HomeViewModel(movieService: movieService)
  }

  func enterHomeScreen() {
    homeViewModel.inputs.viewDidLoad()
  }

  func scrollToBottom() {
    homeViewModel.inputs.willDisplayLoadingCell()
  }

  func pullToRefresh() {
    homeViewModel.inputs.pullToRefresh()
  }

  func stubMovieList(movieList: MovieList) {
    movieService.stubMovieList(movieList, forPage: movieList.page)
  }

  func buildSampleMovies(numOfMovies: Int) -> [Movie] {
    var result = [Movie]()
    for i in 0..<numOfMovies {
      result.append(Movie(id: i, title: "title_\(i)", popularity: 0.3, posterPath: "poster_path_\(i)"))
    }
    return result
  }
}
