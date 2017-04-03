//
//  DestinationViewModel.swift
//  TrainNapper
//
//  Created by Robert Deans on 1/22/17.
//  Copyright © 2017 Robert Deans. All rights reserved.
//

import GoogleMaps
import UserNotifications


protocol NapperAlarmsDelegate: class {
    func addAlarm(_ alarm: Alarm)
    func removeAlarm(_ alarm: Alarm)
}

final class NotificationViewModel: NSObject {
    
    let store = DataStore.shared
    
    var user: User!
    let center = UNUserNotificationCenter.current()


    let proximityRadius = 800.0
    var distanceToStation = 0.0
    
//    weak var distanceDelegate: GetDistanceDelegate?

    var regionsToMonitorDelegate: RegionsToMonitorDelegate?
    
    
    convenience init(napper: User) {
        self.init()
        self.user = napper

        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("UNUserNotification request granted")
            } else {
                print("UNUserNotification request NOT granted")
            }
        }
    }
    
}


// MARK: Alarms Delegate
extension NotificationViewModel: NapperAlarmsDelegate, UNUserNotificationCenterDelegate {
    
    func addAlarm(_ alarm: Alarm) {

        alarm.isActive = true
        user.alarms.append(alarm)

        // Create Region
        guard let coordinate2D = alarm.location?.clLocation.coordinate else { print("trouble unwrapping 2d coordinate"); return }
        
        let region = CLCircularRegion(center: coordinate2D, radius: proximityRadius, identifier: alarm.id)
        region.notifyOnExit = false
        region.notifyOnEntry = true
        
        // Send Region to Monitor Location
        regionsToMonitorDelegate?.addRegionToMonitor(region: region)
        
        let triggerRegion = UNLocationNotificationTrigger(region: region, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Time to wake up!", arguments: nil)
        content.body = "You are now arriving at \(alarm.name)"
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: alarm.id, content: content, trigger: triggerRegion)
        center.add(request)
        
        
        // Print Notification Center Requests
        center.getPendingNotificationRequests { (requests) in
            print("added- there are now \(requests.count) requests in pending notifications")
 
        }
        
    }

    
    func removeAlarm(_ alarm: Alarm) {
        alarm.isActive = false
        for (index, destination) in user.alarms.enumerated() {
            if destination.name == alarm.name {
                user.alarms.remove(objectAtIndex: index)
            }
        }
        
        guard let coordinate2D = alarm.location?.clLocation.coordinate else { print("trouble unwrapping 2d coordinate"); return }
        
        let region = CLCircularRegion(center: coordinate2D, radius: proximityRadius, identifier: alarm.id)
        
        regionsToMonitorDelegate?.removeRegionToMonitor(region: region)
        
        center.removePendingNotificationRequests(withIdentifiers: [alarm.id])
        center.getPendingNotificationRequests { (requests) in
            print("removed- there are now \(requests.count) requests in pending notifications")
        }
    }
    
    // Used to present notifications while app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        center.getDeliveredNotifications { (requests) in
            print("get delivered called in willPResent")
            for request in requests {
//                let stationName = request.request.identifier
//                print("presented notification for \(stationName)")
//                guard let station = self.store.stationsDictionary[stationName] else { print("no such station in willPresent"); return }
//                self.removeAlarm(station: station)
            }
        }
        
        completionHandler([.alert, .sound])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        center.getDeliveredNotifications { (requests) in
            print("get delivered called in didReceive")

            for request in requests {
//                let stationName = request.request.identifier
//                guard let station = self.store.stationsDictionary[stationName] else { print("no such station in willPresent"); return }
//                self.removeAlarm(station: station)
            }
        }
        completionHandler()
    }

}

