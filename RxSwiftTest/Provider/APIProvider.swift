//
//  APIProvider.swift
//  RxSwiftTest
//
//  Created by Mikhail Plotnikov on 24.03.2021.
//

import Foundation
import RxSwift

class APIProvider: APIProviderProtocol {
    
    func getRepositories(_ gitHubID: String) -> Observable<[RepostoryModel]> {
        	
        guard !gitHubID.isEmpty,
              let url = URL(string: "https://api.github.com/users/\(gitHubID)/repos") else { return Observable.just([]) }
        
        return URLSession.shared
            .rx.json(url: url)
            .map {
                var repositories = [RepostoryModel]()
                
                if let items = $0 as? [[String: AnyObject]] {
                    items.forEach {
                        guard let name = $0["name"] as? String,
                        let url = $0["html_url"] as? String else { return }
                        repositories.append(RepostoryModel(name: name, url: url))
                    }
                }
                
                return repositories
            }
    }
}
