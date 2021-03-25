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
    let api = APIProviderAlamofire()
    let disposeBag = DisposeBag()
    
    private func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter user"
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        tableView.tableHeaderView?.isHidden = false
    }
    
    private func getTextForTitle(count: Int) -> String {
        if count == 0 {
            if self.searchBar.text!.isEmpty {
                return "Enter user!"
            }
            return "The user doesn't exist"
        }
        return "Found repos: \(count)"
    }
    
    private func bindingUI(viewModel: RepositoryViewModel, tableView: UITableView, searchController: UISearchController) {
        viewModel.data.drive(tableView.rx.items(cellIdentifier: "Cell")) {_, repository, cell in
            cell.textLabel?.text = repository.name
            cell.detailTextLabel?.text = repository.url
        }
        .disposed(by: disposeBag)
        
        viewModel.data.drive(onNext: {
            let count = $0.count
            
            let titleString = self.getTextForTitle(count: count)
            
            self.navigationItem.title = titleString
        })
        .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text
            .orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: {
                print("tap on \($0)")
            })
            .disposed(by: disposeBag)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        
        repositoryViewModel = RepositoryViewModel(APIProvider: api)
        
        if let viewModel = repositoryViewModel {
            bindingUI(viewModel: viewModel, tableView: tableView, searchController: searchController)
        }
        
    }
    
}
