//
//  UserReviewViewController.swift
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

class UserReviewViewController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.estimatedRowHeight = 300
            tableView.rowHeight = UITableView.automaticDimension
            
            tableView.tableFooterView = UIView()
            
            let reviewCell = UINib(nibName: "UserReviewCell", bundle: nil)
            tableView.register(reviewCell, forCellReuseIdentifier: "reviewCell")
        }
    }
    
    var viewModel: MovieDetailViewModelType!
    
    var reviewList: [UserReview] = [] {
        didSet { tableView.reloadData() }
    }
    
    var movieId = 0
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "User Reviews"
        viewModel.getMovieUserReview(movieId: movieId, page: currentPage)
        setupRx()
        
        tableView.es.addInfiniteScrolling {
            self.getNextPage()
        }
    }
    
    func getNextPage() {
        viewModel.getMovieUserReview(movieId: movieId, page: currentPage)
    }
    
    func setupRx() {
        viewModel.userReviewObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { item in
                if item.results.count == 0 {
                    self.tableView.es.stopLoadingMore()
                    self.tableView.es.noticeNoMoreData()
                }
                else {
                    self.reviewList.append(contentsOf: item.results)
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
    
    func convertDate(_ dateString: String) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = df.date(from: dateString)
        df.dateFormat = "MMMM dd, yyyy, HH:mm"
        
        let dateString = df.string(from: date ?? Date())
        return dateString
    }
}

extension UserReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! UserReviewCell
        
        let data = reviewList[indexPath.row]
        
        var imagePath = ""
        
        if let avatarPath = data.authorDetail.avatar_path, avatarPath.contains("gravatar") {
            var path = avatarPath
            path.removeFirst()
            imagePath = path
            print(path)
        }
        else {
            imagePath = URLs.imageBaseURL + URLs.PosterSizes.w92 + "\(data.authorDetail.avatar_path ?? "")"
        }
        
        cell.avatarImage.kf.setImage(with: URL(string: imagePath))
        cell.avatarImage.layer.cornerRadius = cell.avatarImage.frame.width / 2
        
        cell.authorNameLabel.text = data.author
        cell.contentTextView.text = data.content
        cell.dateLabel.text = self.convertDate(data.updatedAt)
        
        return cell
    }
}
