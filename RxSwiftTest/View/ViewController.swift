//
//  ViewController.swift
//  RxSwiftTest
//
//  Created by Mikhail Plotnikov on 23.03.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar {
        return searchController.searchBar
    }
    var repositoryViewModel: RepositoryViewModel?
    let api = APIProvider()
    let disposeBag = DisposeBag()
    
    private func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = true
        searchBar.text = "text"
        searchBar.placeholder = "Enter user"
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        
        repositoryViewModel = RepositoryViewModel(APIProvider: api)
        
        if let viewModel = repositoryViewModel {
            viewModel.data.drive(tableView.rx.items(cellIdentifier: "Cell")) {_, repository, cell in
                cell.textLabel?.text = repository.name
                cell.detailTextLabel?.text = repository.url
            }
            .disposed(by: disposeBag)
            
            searchBar.rx.text
                .orEmpty
                .bind(to: viewModel.searchText)
                .disposed(by: disposeBag)
            
            searchBar.rx.cancelButtonClicked
                .map { "" }
                .bind(to: viewModel.searchText)
                .disposed(by: disposeBag)
            
            
            tableView.rx.itemSelected
                .subscribe(onNext: {
                    print("tap on \($0)")
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    self.searchBar.layoutIfNeeded()
                })
                .disposed(by: disposeBag)
            
        }
        
    }
    
}
