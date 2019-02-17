//
//  DetailViewController.swift
//  JunctionProject
//
//  Created by 縣美早 on 2019/02/16.
//  Copyright © 2019年 GeekSalon. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class DetailViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet var phoneCallButton: UIButton!
    @IBOutlet var reserveButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tagLabel: UILabel!
    @IBOutlet var organizerNameLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var organizerImageView: UIImageView!
    @IBOutlet var mapImageView: UIImageView!
    
    var locationManager = CLLocationManager()
    
    let latitudeList = [35.690167, 35.710063, 35.714765, 35.710063]
    let longitudeList = [139.700359, 139.8107, 139.796655, 139.8107]
    
    fileprivate lazy var mapView: GMSMapView = {
        let viewsize = UIScreen.main.bounds.size
        
        let view = GMSMapView(frame: CGRect(x: 0, y: 0, width: viewsize.width, height: viewsize.height/1.3))
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneCallButton.layer.cornerRadius = phoneCallButton.bounds.height/2
        let orangeColor = UIColor(red: 255/255, green: 154/255, blue: 1/255, alpha: 1.0)
        phoneCallButton.layer.borderColor = orangeColor.cgColor
        phoneCallButton.layer.borderWidth = 2
        phoneCallButton.layer.masksToBounds = true
        
        reserveButton.layer.cornerRadius = reserveButton.bounds.height/2
        reserveButton.layer.masksToBounds = true
        
        mapImageView.image = UIImage(named: "tour.png")

        organizerImageView.layer.cornerRadius = organizerImageView.bounds.height/2
        organizerImageView.layer.masksToBounds = true
        
        navigationController?.navigationBar.topItem?.title = "Trip Details"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
        
        //view.addSubview(mapView)
        
        for latitude in latitudeList {
            for longitude in longitudeList {
                showMarker(position: CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude), placeName: "", address: "")
            }
        }
        let mylocation = locateMyPosition()
        let camera = GMSCameraPosition.camera(withLatitude: mylocation.latitude, longitude: mylocation.longitude, zoom: 15.0)
        mapView.camera = camera
    }
    
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        self.performSegue(withIdentifier: "toPlanDetail", sender: nil)
//        return true
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        let greenColor = UIColor(red: 115/255, green: 222/255, blue: 188/255, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = greenColor
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = "Trip Details"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
    }
    
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
        //let markerImage = UIImage(named: "icon2.png")
       //marker.iconView = UIImageView(image: markerImage)
        marker.position = position
        marker.title = placeName
        marker.snippet = address
        
        marker.map = self.mapView
        
    }
    
    @IBAction func showAlert() {
        let alertController = UIAlertController(title: "Reservation", message: "Do you confirm the reservation?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let alert = UIAlertController(title: "Success!", message: "Your reservation has been confirmed.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            alertController.dismiss(animated: true, completion: nil)
    
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (UIAlertAction) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func didTapButton() {
        self.performSegue(withIdentifier: "toPlanDetail", sender: nil)
    }


}
