//
//  MovieDetailViewController.swift
//  TOG-Test
//
//  Created by Yudha on 17/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher
import YouTubePlayer

class MovieDetailViewController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    var disposeBag = DisposeBag()
    
    var viewModel: MovieDetailViewModelType!

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var userReviewButton: UIButton! {
        didSet { userReviewButton.addTarget(self, action: #selector(userDetailTapped), for: .touchUpInside)}
    }
    @IBOutlet weak var youtubeFrame: YouTubePlayerView!
    
    var movieId = 0
    var videoId = "" {
        didSet {
            youtubeFrame.loadVideoID(videoId)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.getMovieDetail(movieId: movieId)
        viewModel.getMovieVideos(movieId: movieId)
        setupRx()
    }
    
    func setupRx() {
        viewModel.movieObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { item in
                self.setupView(item: item)
            })
            .disposed(by: disposeBag)
        
        viewModel.videoObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { item in
                let videoData = item.results.first
                self.videoId = videoData?.key ?? ""
            })
            .disposed(by: disposeBag)
        
        viewModel.errorObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                print(error)
                
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                
                self.navigationController?.present(alert, animated: true, completion: nil)

            })
            .disposed(by: disposeBag)
    }
    
    func setupView(item: MovieDetail) {
        let imagePath = URLs.imageBaseURL + URLs.PosterSizes.w154 + "\(item.posterPath ?? "")"
        
        posterImage.kf.setImage(with: URL(string: imagePath))
        
        titleLabel.text = item.title
        taglineLabel.text = item.tagline
        statusLabel.text = item.status
        releaseDateLabel.text = item.releaseDate
        overviewLabel.text = item.overview
        
        self.title = item.title
    }
    
    @objc func userDetailTapped() {
        coordinator?.goToUserReview(movieId: movieId)
    }
}
