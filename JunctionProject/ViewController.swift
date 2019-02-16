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
    let latitudeList = [35.690167, 35.710063, 35.714765]
    let longitudeList = [139.700359, 139.8107, 139.796655]
    var fezMarkers: [Marker] = []

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
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
        for latitude in latitudeList {
            for longitude in longitudeList {
                showMarker(position: CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude), placeName: "", address: "")
            }
        }
 
        //        let latitude = locationManager.location?.coordinate.latitude
        //        let longitude = locationManager.location?.coordinate.longitude
        //        var currentLocation = CGPoint(x: longitude!, y: latitude!)

        let myLocation = locateMyPosition()


//        let direction = Direction(from:"35.6775602107869,139.692658446729",to: "35.707848364433,139.701456092298",mode: .walking)
//        direction.directionCompletion(handler: { (route) in
//
//            for route in route.routes {
//                self.mapView.addDirection(path: (route?.overview_polyline?.points)!)
//            }
//
//        }) { (error) in
//            print (error)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let greenColor = UIColor(red: 115/255, green: 222/255, blue: 188/255, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = greenColor
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = false
        requestFizPlaces(radius: 1000, lat: 51.507784, lon: -0.12994229)
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        return true
    }
}

extension ViewController {
    func locateMyPosition() -> CLLocationCoordinate2D {
        // 現在地の緯度経度
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude

        let dummyLocation = CLLocationCoordinate2DMake(35.690167, 139.700359)
        //表示する時の中心となる場所を指定する（nilに注意）
        if let unwrappedLatitude = latitude {
            //位置情報の使用を許可されてる時（現在地を中心に表示）
            guard let unwrappedLongtitude = longitude else { return dummyLocation }
            let camera = GMSCameraPosition.camera(withLatitude: unwrappedLatitude, longitude: unwrappedLongtitude, zoom: 15.0)
            mapView.camera = camera
            return locationManager.location?.coordinate ?? dummyLocation
        } else {
            //位置情報を許可しない場合＆初回（新宿駅を中心に表示する）
            let camera = GMSCameraPosition.camera(withLatitude: 35.690167, longitude: 139.700359, zoom: 15.0)
            mapView.camera = camera
            return dummyLocation
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

    func requestFizPlaces(radius: Int, lat: Double, lon: Double) {
        RakutenAPIRequest.getPlaces(radius: radius, lat: lat, lon: lon, success: { wrapperMarker in
            self.fezMarkers = wrapperMarker.results
        })
    }
}
