//
//  ViewController.swift
//  GeoAlarms
//
//  Created by Robert Deans on 4/1/17.
//  Copyright © 2017 Robert Deans. All rights reserved.
//

import UIKit
import GoogleMaps
import SnapKit

class HomeViewController: UIViewController {

    let store = DataStore.shared
    let locationViewModel = LocationViewModel()
    let notificationViewModel = NotificationViewModel()
    
    var camera: GMSCameraPosition!
    var googleMapView: GMSMapView!
    var markerArray = [GMSMarker]()
    
    var createAlarmViewController: CreateAlarmViewController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        constrain()
    }
    
    // MARK: View Configuration
    func configure() {
        
        // Sets up map
        camera = GMSCameraPosition.camera(withLatitude: 40.7485, longitude: -73.9854, zoom: 8)
        googleMapView = GMSMapView.map(withFrame: .zero, camera: camera)
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
        googleMapView.delegate = self
        
        locationViewModel.requestLocationAlertDelegate = self
    }
    
    // MARK: View Constraints
    func constrain() {
        
        view.addSubview(googleMapView)
        googleMapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    func centerMap(on coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude as CLLocationDegrees, longitude: coordinate.longitude as CLLocationDegrees, zoom:         googleMapView.camera.zoom)

        googleMapView.animate(to: camera)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
}

extension HomeViewController: GMSMapViewDelegate {
    

    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print("LONG TOUCH AT COORDINATE \(coordinate)")
        centerMap(on: coordinate)
        
        presentNewAlarmWindowVC(with: coordinate)
//        Vibrates once

//        CREATE MARKER
        let newMarker = GMSMarker(position: coordinate)
        newMarker.map = mapView

    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        presentExistingAlarmWindowVC()
        // TRUE if this delegate handled the tap event, which prevents the map from performing its default selection behavior, and FALSE if the map should continue with its default selection behavior.
        return true
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {

        // CUSTOM INFO WINDOW / VIEWCONTROLLER?
        
        return nil
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        // EITHER EDITS ALARM OR PRESENTS SAME INFORMATION
        
    }
    
}

extension HomeViewController: RequestLocationAlertDelegate {

    func presentLocationRequestAlert() {
        print("present alert delegate called")
        
        let alertController = UIAlertController(
            title: "Background Location Access Disabled",
            message: "In order to be notified about adorable kittens near you, please open this app's settings and set location access to 'Always'.",
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func presentNewAlarmWindowVC(with coordinates: CLLocationCoordinate2D) {
        createAlarmViewController = CreateAlarmViewController()
        createAlarmViewController.parentVC = self
        
        createAlarmViewController.coordinates = coordinates
        
        view.addSubview(createAlarmViewController.view)
        createAlarmViewController.view.snp.makeConstraints {
            $0.height.width.equalToSuperview().multipliedBy(0.7)
            $0.centerX.centerY.equalToSuperview()
        }
        createAlarmViewController.didMove(toParentViewController: nil)
        view.layoutIfNeeded()

    }
    
    func presentExistingAlarmWindowVC() {

        
        
    }

    func dismissAlarmWindowVC() {
        
        willMove(toParentViewController: nil)
        createAlarmViewController.view.removeFromSuperview()
        createAlarmViewController = nil
        
        
        
    }
    
}
