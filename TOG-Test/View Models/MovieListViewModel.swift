//
//  MovieListViewModel.swift
//  TOG-Test
//
//  Created by Yudha on 17/03/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieListViewModelType {
    var moviesObservable: Observable<MovieModel> { get }
    var errorObservable: Observable<Error> { get }
    func getMoviesFromGenre(genre: Int, page: Int)
}

final class MovieListViewModel: MovieListViewModelType {    
    var disposeBag = DisposeBag()
    
    var moviesSubject = PublishSubject<MovieModel>()
    var errorSubject = PublishSubject<Error>()
    
    lazy var moviesObservable = self.moviesSubject.asObservable()
    lazy var errorObservable: Observable<Error> = self.errorSubject.asObservable()
    
    func getMoviesFromGenre(genre: Int, page: Int) {
        let url = URLs.baseURL + URLs.EndPoint.discoverMovie
        
        let param: [String: Any] = [
            "api_key": API_KEY.apiKey,
            "language": "en-US",
            "page": "\(page)",
            "with_genres": "\(genre)"
        ]
        
        let observable: Observable<MovieModel> = NetworkManager.shared.getRequest(url, parameters: param)
        
        observable.subscribe(onNext: { movie in
            print("movie model --- ")
            print(movie)
            
            self.moviesSubject.onNext(movie)
        },
        onError: { error in
            print(error)
            self.errorSubject.onNext(error)
        },
        onCompleted: {
            print("completed")
        })
        .disposed(by: disposeBag)
    }
}
