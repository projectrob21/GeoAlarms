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
    
    var camera: GMSCameraPosition!
    var googleMapView: GMSMapView!
    var markerArray = [GMSMarker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        constrain()
    }
    
    // MARK: View Configuration
    func configure() {
        
        camera = GMSCameraPosition.camera(withLatitude: 40.7485, longitude: -73.9854, zoom: 8)
        googleMapView = GMSMapView.map(withFrame: .zero, camera: camera)
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
//        stationsMap.mapType = .
        googleMapView.delegate = self
        
        
    }
    
    // MARK: View Constraints
    func constrain() {
        
        view.addSubview(googleMapView)
        googleMapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
}

extension HomeViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        //        markerWindowView = MarkerWindowView()
        //        markerWindowView.stationLabel.text = "PLEASE MAKE THIS WINDOW NICER"
        //        return markerWindowView
        return nil
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print("LONG TOUCH AT COORDINATE \(coordinate)")
        // Vibrates once
        
        let newMarker = GMSMarker(position: coordinate)
        newMarker.map = mapView
        
        let newAlarm = Alarm()
        
        newAlarm.id = "\(UUID())"
        
        try! store.realm.write {
            store.user.alarms.append(newAlarm)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        /*
         guard let station = store.stationsDictionary[marker.snippet!] else { print("mapview - trouble unwrapping station"); return }
         
         
         if marker.icon != UIImage.alarmClock {
         napperAlarmsDelegate?.addAlarm(station: station)
         marker.icon = UIImage.alarmClock
         } else {
         napperAlarmsDelegate?.removeAlarm(station: station)
         
         switch station.branch {
         case .LIRR: marker.icon = UIImage.lirrIcon
         case .MetroNorth: marker.icon = UIImage.metroNorthIcon
         case .NJTransit: marker.icon = UIImage.njTransitIcon
         default: break
         }
         }
         */
    }
    

    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        
        // TRUE if this delegate handled the tap event, which prevents the map from performing its default selection behavior, and FALSE if the map should continue with its default selection behavior.
        return true
    }
    
}

extension HomeViewController {
//    
//    func presentAddUserController() {
//        alarmWindowViewController = AlarmWindowViewController()
//        alarmWindowViewController.parentVC = self
//        view.addSubview(addUserViewController.view)
//        alarmWindowViewController.view.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        alarmWindowViewController.didMove(toParentViewController: nil)
//        view.layoutIfNeeded()
//        
//        print("PARENT = \(alarmWindowViewController.parent)")
//        
//        navigationItem.rightBarButtonItem?.title = "Dismiss"
//        navigationItem.rightBarButtonItem?.action = #selector(dismissViewAddUSerController)
//    }
//    
//    func dismissViewAddUSerController() {
//        APIClient.getSpotifyUsersData(branch: "people", not: false, nameOrID: nil) { (jsonData) in
//            self.users = []
//            for response in jsonData {
//                let newUser = User(herokuJSON: response)
//                self.users.append(newUser)
//            }
//            OperationQueue.main.addOperation {
//                print("number of users is \(self.users.count)")
//                self.users = self.users.sorted(by: {
//                    $0.0.id < $0.1.id
//                })
//                self.tableView.reloadData()
//            }
//        }
//        
//        navigationItem.rightBarButtonItem?.title = "Add User"
//        navigationItem.rightBarButtonItem?.action = #selector(presentAddUserController)
//        
//        willMove(toParentViewController: nil)
//        alarmWindowViewController.view.removeFromSuperview()
//        alarmWindowViewController = nil
//        
//        
//        
//    }
    
}
