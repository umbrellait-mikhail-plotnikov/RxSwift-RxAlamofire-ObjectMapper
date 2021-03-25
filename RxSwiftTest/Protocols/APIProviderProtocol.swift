//
//  APIProviderProtocol.swift
//  RxSwiftTest
//
//  Created by Mikhail Plotnikov on 25.03.2021.
//

import Foundation
import RxSwift

protocol APIProviderProtocol {
    func getRepositories(_ gitHubID: String) -> Observable<[RepostoryModel]>
}
