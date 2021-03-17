//
//  HomeViewModel.swift
//  TOG-Test
//
//  Created by Yudha on 16/03/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelType {
    var genresObservable: Observable<GenreModel> { get }
    var errorObservable: Observable<Error> { get }
}

final class HomeViewModel: HomeViewModelType {
    
    init() {
       getGenres()
    }
    
    var disposeBag = DisposeBag()
    
    var genresSubject = PublishSubject<GenreModel>()
    var errorSubject = PublishSubject<Error>()
    
    lazy var genresObservable = self.genresSubject.asObservable()
    lazy var errorObservable: Observable<Error> = self.errorSubject.asObservable()
    
    func getGenres() {
        let url = URLs.baseURL + URLs.EndPoint.genreList
        
        let param: [String: Any] = [
            "api_key": API_KEY.apiKey,
            "language": "en-US"
        ]
        
        let observable: Observable<GenreModel> = NetworkManager.shared.getRequest(url, parameters: param)
        
        observable.subscribe(onNext: { genre in
            print("genre model --- ")
            print(genre)
            
            self.genresSubject.onNext(genre)
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
