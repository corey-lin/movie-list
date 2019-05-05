//
//  DetailViewModelTests.swift
//  MovieListTests
//
//  Created by coreylin on 8/19/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import MovieList

final class DetailViewModelTests: QuickSpec {
  fileprivate var disposeBag: DisposeBag!
  fileprivate let movieId = 11
  fileprivate var movieService: FakeMovieService!
  fileprivate var detailViewModel: DetailViewModel!
  fileprivate var backdropURLEvents: [URL?]!
  fileprivate var titleEvents: [String?]!
  fileprivate var popularityEvents: [String?]!
  fileprivate var synopsisEvents: [String?]!
  fileprivate var genresEvents: [String?]!
  fileprivate var languageEvents: [String?]!
  fileprivate var durationEvents: [String?]!

  override func spec() {
    super.spec()

    beforeEach {
      self.initialSetup()
    }

    describe("detail screen, load the movie detail") {
      let sampleMovieDetail = MovieDetail(id: movieId,
                                          title: "title",
                                          popularity: 0.3,
                                          backdropPath: "/backdropPath",
                                          overview: "overview",
                                          genres: ["g1", "g2"],
                                          spokenLanguages: ["English"],
                                          runtime: 100)
      beforeEach {
        self.stubMovieDetail(sampleMovieDetail)
        self.enterDetailScreen()
      }
      it("should see movie detail") {
        expect(self.titleEvents.last) == sampleMovieDetail.title
        expect(self.popularityEvents.last) == String(sampleMovieDetail.popularity!)
        expect(self.synopsisEvents.last) == sampleMovieDetail.overview
        expect(self.genresEvents.last) == sampleMovieDetail.genres.joined(separator: ", ")
        expect(self.languageEvents.last) == sampleMovieDetail.spokenLanguages.joined(separator: ", ")
      }
    }
  }

}

private extension DetailViewModelTests {
  func initialSetup() {
    disposeBag = DisposeBag()
    backdropURLEvents = []
    titleEvents = []
    popularityEvents = []
    synopsisEvents = []
    genresEvents = []
    languageEvents = []
    durationEvents = []

    movieService = FakeMovieService()
    detailViewModel = DetailViewModel(movieId: movieId, movieService: movieService)
    detailViewModel.outputs.backdropURLStream.subscribe(onNext: { [unowned self] backdropURL in
      self.backdropURLEvents.append(backdropURL)
    }).disposed(by: disposeBag)
    detailViewModel.outputs.titleStream.subscribe(onNext: { [unowned self] title in
      self.titleEvents.append(title)
    }).disposed(by: disposeBag)
    detailViewModel.outputs.popularityStream.subscribe(onNext: { [unowned self] popularity in
      self.popularityEvents.append(popularity)
    }).disposed(by: disposeBag)
    detailViewModel.outputs.synopsisStream.subscribe(onNext: { [unowned self] synopsis in
      self.synopsisEvents.append(synopsis)
    }).disposed(by: disposeBag)
    detailViewModel.outputs.genresStream.subscribe(onNext: { [unowned self] genres in
      self.genresEvents.append(genres)
    }).disposed(by: disposeBag)
    detailViewModel.outputs.languageStream.subscribe(onNext: { [unowned self] language in
      self.languageEvents.append(language)
    }).disposed(by: disposeBag)
    detailViewModel.outputs.durationStream.subscribe(onNext: { [unowned self] duration in
      self.durationEvents.append(duration)
    }).disposed(by: disposeBag)
  }

  func stubMovieDetail(_ movieDetail: MovieDetail) {
    movieService.stubMovieDetail(movieDetail, forId: movieDetail.id)
  }

  func enterDetailScreen() {
    detailViewModel.inputs.viewDidLoad()
  }
}
