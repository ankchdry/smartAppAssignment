//
//  MovieListViewModel.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

enum MovieListType: String { case topRatedList, nowPlayingList
    func navigationTitle() -> String {
        switch self {
        case .nowPlayingList:
            return "Now Playing"
        case .topRatedList:
            return "Top Rated List"
        }
    }
}
class MovieListViewModel:ViewModelType {
    
    // Determine type of movie list. Default is .nowPlayingList
    var movieListType: MovieListType = .nowPlayingList
    
    // Observaable data sources.
    var data = BehaviorRelay<[MovieListSectionModel]>.init(value: [])
    
    // Dispose bag to dispose off sequence.
    var disposeBag = DisposeBag.init()
    
    // Add movie list items to data 'observable' data which further kickoff changes in collection view.
    func updateItems(for movies: [MovieBrief]) {
        var sectionModels: [MovieListSectionModel] = []
        var items : [MovieListItemSource] = []
        
        for movie in movies {
            let item = MovieListItemSource.init(identity: movie)
            items.append(item)
        }
        
        let movieSection = MovieListSectionModel.init(model: MovieListSection.init(identity: 0), items: items)
        sectionModels.append(movieSection)
        data.accept(sectionModels)
    }
    
    // API Request on basis of
    func fetchMovieList() {
        let movieListRequest = (movieListType == .topRatedList) ? ApiClient.fetchTopRatedMovies() : ApiClient.fetchNowPlayingMovies()
        movieListRequest
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (response) in
                self.updateItems(for: response.results)
            }, onError: { (error) in
                switch error {
                case ApiError.conflict:
                    print("Conflict error")
                case ApiError.forbidden:
                    print("Forbidden error")
                case ApiError.notFound:
                    print("Not found error")
                default:
                    print("Unknown error:", error)
                }
            }).disposed(by: disposeBag)
    }
}


// Section models of RxDataSources.
typealias MovieListSectionModel = AnimatableSectionModel<MovieListSection, MovieListItemSource>

struct MovieListSection:IdentifiableType {
    var identity: Int
}

struct MovieListItemSource:IdentifiableType, Equatable {
    var identity: MovieBrief
    static func == (lhs: MovieListItemSource, rhs: MovieListItemSource) -> Bool {
        return lhs.identity == rhs.identity
    }
}
