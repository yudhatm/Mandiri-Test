//
//  MainViewController.swift
//  TOG-Test
//
//  Created by Yudha on 16/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MainViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    
    var disposeBag = DisposeBag()
    
    var viewModel: HomeViewModelType!
    
    var genreList: [Genre] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.estimatedRowHeight = 300
            tableView.rowHeight = UITableView.automaticDimension
            
            tableView.tableFooterView = UIView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "The Movie DB"
        setupRx()
    }
    
    func setupRx() {
        viewModel.genresObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { item in
                self.genreList = item.genres
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
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let genreData = genreList[indexPath.row]
        
        cell.textLabel?.text = genreData.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let data = genreList[indexPath.row]
        
        coordinator?.goToGenreMovieList(genreName: data.name, genreId: data.id)
    }
}
