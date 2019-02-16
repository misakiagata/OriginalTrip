//
//  Marker.swift
//  JunctionProject
//
//  Created by 縣美早 on 2019/02/16.
//  Copyright © 2019年 GeekSalon. All rights reserved.
//

import UIKit

class Marker: NSObject {
    
    var id: Int!
    var name: String!
    var tags: String!
    var latitude: Double!
    var longitude: Double!
    var phoneNumber: Int!

    init(id: Int, name: String, latitude: Double, longitude: Double, tags: String, phoneNumber: Int) {
        self.id = id
        self.name = name
        self.tags = tags
        self.latitude = latitude
        self.longitude = longitude
        self.phoneNumber = phoneNumber
    }
}
