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
            .validate(statusCode: 200...300)
            .validate(contentType: ["application/json"])
            .responseJSON()
            .observeOn(MainScheduler.instance)
            .map {
                guard let mappedResponse = Mapper<RepostoryModel>().mapArray(JSONObject: $0.value) else { return [] }
                
                return mappedResponse
                    
            }
            
    }
}
