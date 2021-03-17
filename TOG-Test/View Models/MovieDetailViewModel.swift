//
//  MovieDetailViewModel.swift
//  TOG-Test
//
//  Created by Yudha on 17/03/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieDetailViewModelType {
    var movieObservable: Observable<MovieDetail> { get }
    var userReviewObservable: Observable<UserReviewModel> { get }
    var videoObservable: Observable<VideoModel> { get }
    var errorObservable: Observable<Error> { get }
    func getMovieDetail(movieId: Int)
    func getMovieUserReview(movieId: Int, page: Int)
    func getMovieVideos(movieId: Int)
}

final class MovieDetailViewModel: MovieDetailViewModelType {
    var disposeBag = DisposeBag()
    
    var movieSubject = PublishSubject<MovieDetail>()
    var userReviewSubject = PublishSubject<UserReviewModel>()
    var videoSubject = PublishSubject<VideoModel>()
    var errorSubject = PublishSubject<Error>()
    
    lazy var movieObservable = self.movieSubject.asObservable()
    lazy var userReviewObservable = self.userReviewSubject.asObservable()
    lazy var videoObservable = self.videoSubject.asObservable()
    lazy var errorObservable: Observable<Error> = self.errorSubject.asObservable()
    
    func getMovieDetail(movieId: Int) {
        let url = URLs.baseURL + URLs.EndPoint.movie + "\(movieId)"
        
        let param: [String: Any] = [
            "api_key": API_KEY.apiKey,
            "language": "en-US",
        ]
        
        let observable: Observable<MovieDetail> = NetworkManager.shared.getRequest(url, parameters: param)
        
        observable.subscribe(onNext: { movie in
            print("movie detail model --- ")
            print(movie)
            
            self.movieSubject.onNext(movie)
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
    
    func getMovieUserReview(movieId: Int, page: Int) {
        let url = URLs.baseURL + URLs.EndPoint.movie + "\(movieId)" + "/reviews"
        
        let param: [String: Any] = [
            "api_key": API_KEY.apiKey,
            "language": "en-US",
            "page": "\(page)"
        ]
        
        let observable: Observable<UserReviewModel> = NetworkManager.shared.getRequest(url, parameters: param)
        
        observable.subscribe(onNext: { review in
            print("user review model --- ")
            print(review)
            
            self.userReviewSubject.onNext(review)
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
    
    func getMovieVideos(movieId: Int) {
        let url = URLs.baseURL + URLs.EndPoint.movie + "\(movieId)" + "/videos"
        
        let param: [String: Any] = [
            "api_key": API_KEY.apiKey,
            "language": "en-US",
        ]
        
        let observable: Observable<VideoModel> = NetworkManager.shared.getRequest(url, parameters: param)
        
        observable.subscribe(onNext: { video in
            print("movie videos model --- ")
            print(video)
            
            self.videoSubject.onNext(video)
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
