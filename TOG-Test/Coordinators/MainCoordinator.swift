//
//  MainCoordinator.swift
//  TOG-Test
//
//  Created by Yudha on 16/03/21.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = MainViewController.instantiate(storyboardName: .main)
        let viewModel = HomeViewModel()
        vc.viewModel = viewModel
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToGenreMovieList(genreName: String, genreId: Int) {
        let vc = GenreMovieListViewController.instantiate(storyboardName: .main)
        let viewModel = MovieListViewModel()
        vc.coordinator = self
        vc.viewModel = viewModel
        vc.genreName = genreName
        vc.genreId = genreId
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToMovieDetail(movieId: Int) {
        let vc = MovieDetailViewController.instantiate(storyboardName: .main)
        let viewModel = MovieDetailViewModel()
        vc.coordinator = self
        vc.viewModel = viewModel
        vc.movieId = movieId
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToUserReview(movieId: Int) {
        let vc = UserReviewViewController.instantiate(storyboardName: .main)
        let viewModel = MovieDetailViewModel()
        vc.coordinator = self
        vc.viewModel = viewModel
        vc.movieId = movieId
        navigationController.pushViewController(vc, animated: true)
    }
}
