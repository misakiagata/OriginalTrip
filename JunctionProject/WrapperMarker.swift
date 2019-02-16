//
//  WrapperMarker.swift
//  JunctionProject
//
//  Created by 塗木冴 on 2019/02/16.
//  Copyright © 2019 GeekSalon. All rights reserved.
//

import Foundation
import ObjectMapper

class WrapperMarker: Mappable {
    var count: Int = 0
    var results: [Marker] = []

    required init() {
    }

    required convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }

    func mapping(map: Map) {
        var resultDictionary: [[String: Any]] = [[:]]
        count <- map["count"]
        resultDictionary <- map["results"]

        results = resultDictionary.compactMap { result in
            Marker(map: Map(mappingType: .fromJSON, JSON: result))
        }
    }
}
