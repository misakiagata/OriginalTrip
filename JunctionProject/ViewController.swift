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
    let destinationLat = [37.443077,37.340513,37.45770303986311,37.339446,37.402469]
    let destinationLon = [-122.154619,-122.068843,-122.1636354224854,-121.892531,-122.147960]
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
        
        navigationController?.navigationBar.topItem?.title = "HOME"
        navigationController?.navigationBar.tintColor = UIColor.white
        
        var myLocation = locateMyPosition()
        
        for i in 0..<5 {
            print(destinationLat[i])
            print(destinationLon[i])
            requestFizPlaces(radius: 1000, lat: destinationLat[i], lon: destinationLon[i])
            showMarker(position: CLLocationCoordinate2D.init(latitude: destinationLat[i], longitude: destinationLon[i]), placeName: "", address: "")
        }
        
//
//        for latitude in latitudeList {
//            for longitude in longitudeList {
//                showMarker(position: CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude), placeName: "", address: "")
//            }
//        }
//
        
        //        let latitude = locationManager.location?.coordinate.latitude
        //        let longitude = locationManager.location?.coordinate.longitude
        //        var currentLocation = CGPoint(x: longitude!, y: latitude!)
 }
    
    override func viewWillAppear(_ animated: Bool) {
        let greenColor = UIColor(red: 115/255, green: 222/255, blue: 188/255, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = greenColor
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "HOME"
        self.navigationController?.navigationBar.tintColor = UIColor.white
       
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
        let destinationLocation = CLLocationCoordinate2DMake(37.3874, -122.0575)
        let dummyLocation = CLLocationCoordinate2DMake(35.690167, 139.700359)
        //表示する時の中心となる場所を指定する（nilに注意）
        if let unwrappedLatitude = latitude {
            //位置情報の使用を許可されてる時（現在地を中心に表示）
            guard let unwrappedLongtitude = longitude else { return dummyLocation }
            let camera = GMSCameraPosition.camera(withLatitude: destinationLocation.latitude, longitude: destinationLocation.longitude, zoom: 10.0)
            mapView.camera = camera
            return destinationLocation
            //return locationManager.location?.coordinate ?? dummyLocation
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
            //print(self.fezMarkers.first?.latitude)
            for fez in self.fezMarkers {
                self.showMarker(position: CLLocationCoordinate2D.init(latitude: fez.latitude, longitude: fez.longitude), placeName: fez.name, address: "")
            }
        })
    }
}
