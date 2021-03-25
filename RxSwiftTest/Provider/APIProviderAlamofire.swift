//
//  APIProviderAlamofire.swift
//  RxSwiftTest
//
//  Created by Mikhail Plotnikov on 25.03.2021.
//

import Foundation
import RxSwift
import RxAlamofire
import ObjectMapper

class APIProviderAlamofire: APIProviderProtocol {
    
    let disposeBag = DisposeBag()
    
    func getRepositories(_ gitHubID: String) -> Observable<[RepostoryModel]> {
        
        if gitHubID.isEmpty { return Observable.just([]) }
        
        guard let url = URL(string: "https://api.github.com/users/\(gitHubID)/repos") else { return Observable.just([]) }
        
        return request(.get, url)
            .validate(contentType: ["application/json"])
            .retry(5)
            .responseJSON()
            .observeOn(MainScheduler.instance)
            .do(onError: {
                print("Error \($0)")
            }, onCompleted: {
                print("Completed")
            })
            .map {
                guard let mappedResponse = Mapper<RepostoryModel>().mapArray(JSONObject: $0.value) else { return [] }
                
                return mappedResponse
            }
    }
}
