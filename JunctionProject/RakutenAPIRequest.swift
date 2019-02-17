//
//  RakutenAPIRequest.swift
//  JunctionProject
//
//  Created by 塗木冴 on 2019/02/16.
//  Copyright © 2019 GeekSalon. All rights reserved.
//

import Foundation

import Alamofire
import ObjectMapper
import AlamofireObjectMapper

struct RakutenAPIRequest {

    static let mainAPIHost: String = "https://fizplaces-fiz-places-v1.p.rapidapi.com"

    static func getPlaces(radius: Int, lat: Double, lon: Double, success: @escaping (WrapperMarker) -> Void) {
        var urlRequest = URLRequest(url: URL(string: mainAPIHost + "/content/api/v2/places/?radius=" + String(describing: radius) + "&lat=" + String(describing: lat) + "&lon=" + String(describing: lon))!)
        urlRequest.httpMethod = "GET"
        let headers: HTTPHeaders = [
            "X-RapidAPI-Key": "4df2a12698msh06386f2ae163a21p183824jsn1fd301f5b90b",
            "FIZAPIKEY": "19120b85-e5f7-4a4b-934c-1ba01d8bedc9"
        ]
        headers.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        Alamofire.request(urlRequest).responseJSON() { response in
            switch response.result {
            case .success(let json):
                let map = Map(mappingType: .fromJSON, JSON: json as? [String : Any] ?? [:])
                guard let result = WrapperMarker(map: map) else { return }
                success(result)
                print(result.count)
            case .failure(let error):
                print("error===========================")
                print(error)
            }
        }
    }
}
