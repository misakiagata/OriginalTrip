//
//  ViewController.swift
//  JunctionProject
//
//  Created by 縣美早 on 2019/02/16.
//  Copyright © 2019年 GeekSalon. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate  {
    
    var locationManager = CLLocationManager()
    
    fileprivate lazy var mapView: GMSMapView = {
        let viewsize = UIScreen.main.bounds.size
    
        let view = GMSMapView(frame: CGRect(x: 0, y: 0, width: viewsize.width, height: viewsize.height))
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        view.addSubview(mapView)
        mapView.updateConstraintsIfNeeded()
        mapView.isMyLocationEnabled = true
        
        mapView.delegate = self
        
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        var currentLocation = CGPoint(x: longitude!, y: latitude!)
        
        locateMyPosition()
        showMarker(position: CLLocationCoordinate2D.init(latitude: latitude!, longitude: longitude!), placeName: "", address: "")
        
    }


    
}

extension ViewController {
    func locateMyPosition() {
        // 現在地の緯度経度
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        print(latitude)
        print(longitude)
        //表示する時の中心となる場所を指定する（nilに注意）
        if let unwrappedLatitude = latitude {
            //位置情報の使用を許可されてる時（現在地を中心に表示）
            let camera = GMSCameraPosition.camera(withLatitude: unwrappedLatitude, longitude: longitude!, zoom: 15.0)
            mapView.camera = camera
        } else {
            //位置情報を許可しない場合＆初回（新宿駅を中心に表示する）
            let camera = GMSCameraPosition.camera(withLatitude: 35.690167, longitude: 139.700359, zoom: 15.0)
            mapView.camera = camera

        }

    }
    func showMarker(position: CLLocationCoordinate2D, placeName: String, address: String) {
        let marker = GMSMarker()
        marker.position = position
        marker.title = placeName
        marker.snippet = address

        //マーカーをmapviewに表示
        marker.map = self.mapView

    }
}
