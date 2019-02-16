//
//  Marker.swift
//  JunctionProject
//
//  Created by 縣美早 on 2019/02/16.
//  Copyright © 2019年 GeekSalon. All rights reserved.
//

import UIKit
import ObjectMapper

class Marker: Mappable {
    
    var id: Int = 0
    var name: String = ""
    var tags: [String] = []
    var latitude: Double = 0
    var longitude: Double = 0
    var phoneNumber: String = ""

    required init() {

    }

    required convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        tags <- map["tags"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        phoneNumber <- map["phoneNumber"]
    }
}
