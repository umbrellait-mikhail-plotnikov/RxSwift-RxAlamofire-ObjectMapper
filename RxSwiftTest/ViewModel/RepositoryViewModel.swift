//
//  ViewModel.swift
//  RxSwiftTest
//
//  Created by Mikhail Plotnikov on 24.03.2021.
//

import Foundation
import RxSwift
import RxCocoa

struct RepositoryViewModel {
    
    let searchText = BehaviorRelay(value: "")
    let disposeBag = DisposeBag()
    
    let APIProvider: APIProvider
    var data: Driver<[RepostoryModel]>
    
    init(APIProvider: APIProvider) {
        self.APIProvider = APIProvider
         
        data = self.searchText.asObservable()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest {
                APIProvider.getRepositories($0)
            }
            .asDriver(onErrorJustReturn: [])
    }
}
