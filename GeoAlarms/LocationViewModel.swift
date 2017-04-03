//
//  LocationViewModel.swift
//  TrainNapper
//
//  Created by Robert Deans on 2/3/17.
//  Copyright © 2017 Robert Deans. All rights reserved.
//

//import GoogleMaps

// Presents VC requesting to change settings
protocol RequestLocationAlertDelegate: class {
    func presentLocationRequestAlert()
}
protocol GetDistanceDelegate: class {
    func distanceToStation(distance: Double)    
}

final class LocationViewModel: NSObject {
    
    var locationManager: CLLocationManager!
    var user: User!
    
    let proximityRadius = 800.0
    var distanceToStation = 0.0
    
    weak var distanceDelegate: GetDistanceDelegate?
    var requestLocationAlertDelegate: RequestLocationAlertDelegate?

    convenience init(napper: User) {
        self.init()
        self.user = napper
        setupLocationManager()
    }
    
}


// MARK: Location Management
extension LocationViewModel: CLLocationManagerDelegate {
    
    func setupLocationManager() {
        //General setup
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //Energy efficiency
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.activityType = .otherNavigation
        locationManager.pausesLocationUpdatesAutomatically = true
        
        locationManager.startUpdatingLocation()
        
    }
    
    func requestLocationAuthorization() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            print("authorization for location is NOT set permitted; hashValue: \(CLLocationManager.authorizationStatus().hashValue)")
            requestLocationAlertDelegate?.presentLocationRequestAlert()
            
        } else {
            locationManager.requestLocation()
            print("authorized for location")
        }
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            // *** what if they selected a station, and then authorized use...? The destination array should be updated
            locationManager.requestLocation()
            print("napper re-initialized with location coordinate")
            
        } else {
            requestLocationAlertDelegate?.presentLocationRequestAlert()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let currentLocation = locations.last {
            user.coordinate = Location(clLocation: currentLocation)
        }
        
        // *** alarms must sort by proximity...
        if user.alarms.count > 0 {
            
            let distanceToAlarm = 0.0
            
            distanceDelegate?.distanceToStation(distance: distanceToAlarm)
            print("Napper is currently \(distanceToAlarm) meters from their next destination")
            
            if distanceToAlarm < proximityRadius {
                
                print("SENDING NOTIFICATION")
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("DID ENTER THE REGION!!!!!!")
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("Location Manager PAUSED updates")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("Location Manager RESUMED updates")
    }
    
}

extension LocationViewModel: RegionsToMonitorDelegate {
    
    func addRegionToMonitor(region: CLCircularRegion) {
        locationManager.startMonitoring(for: region)

        print("MONITORED REGIONS = \(locationManager.monitoredRegions)")
    }

    func removeRegionToMonitor(region: CLCircularRegion) {
        locationManager.stopMonitoring(for: region)
        

        print("MONITORED REGIONS = \(locationManager.monitoredRegions)")
    }

    
}

protocol RegionsToMonitorDelegate {
    
    func addRegionToMonitor(region: CLCircularRegion)
    
    func removeRegionToMonitor(region: CLCircularRegion)

    
}

