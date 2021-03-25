//
//  Repository.swift
//  RxSwiftTest
//
//  Created by Mikhail Plotnikov on 24.03.2021.
//

import Foundation
import ObjectMapper

struct RepostoryModel: Mappable {
    init?(map: Map) {
        name = ""
        url = ""
    }
    
    init(name: String?, url: String?) {
        self.name = name
        self.url = url
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        url  <- map["url"]
    }
    
    var name: String?
    var url: String?
}
