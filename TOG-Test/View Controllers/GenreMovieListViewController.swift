//
//  GenreMovieListViewController.swift
//  TOG-Test
//
//  Created by Yudha on 17/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher
import ESPullToRefresh

class GenreMovieListViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    var disposeBag = DisposeBag()
    
    var viewModel: MovieListViewModelType!
    
    var movieList: [Movie] = [] {
        didSet { tableView.reloadData() }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.estimatedRowHeight = 300
            tableView.rowHeight = UITableView.automaticDimension
            
            tableView.tableFooterView = UIView()
            
            let movieCell = UINib(nibName: "MovieCell", bundle: nil)
            tableView.register(movieCell, forCellReuseIdentifier: "movieCell")
        }
    }
    
    var genreName = ""
    var genreId = 0
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = genreName
        
        setupRx()
        
        viewModel.getMoviesFromGenre(genre: genreId, page: currentPage)
        
        tableView.es.addInfiniteScrolling {
            self.getNextPage()
        }
    }
    
    func getNextPage() {
        viewModel.getMoviesFromGenre(genre: genreId, page: currentPage)
    }
    
    func setupRx() {
        viewModel.moviesObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { item in
                if item.results.count == 0 {
                    self.tableView.es.stopLoadingMore()
                    self.tableView.es.noticeNoMoreData()
                }
                else {
                    self.movieList.append(contentsOf: item.results)
                    self.currentPage = self.currentPage + 1
                    self.tableView.es.stopLoadingMore()
                }
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

                self.tableView.es.stopLoadingMore()
                self.tableView.es.noticeNoMoreData()
            })
            .disposed(by: disposeBag)
    }
}

extension GenreMovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        let data = movieList[indexPath.row]
        
        let imagePath = URLs.imageBaseURL + URLs.PosterSizes.w92 + "\(data.posterPath ?? "")"
        
        var date = ""
        
        if data.releaseDate == "" {
            date = "Data not available"
        }
        else {
            date = data.releaseDate
        }
        
        cell.posterImage.kf.setImage(with: URL(string: imagePath))
        cell.titleLabel.text = data.title
        cell.releaseDateLabel.text = date
        cell.overviewLabel.text = data.overview
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = movieList[indexPath.row]
        let movieId = data.id
        
        coordinator?.goToMovieDetail(movieId: movieId)
    }
}
