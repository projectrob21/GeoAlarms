//
//  AlarmWindowViewController.swift
//  GeoAlarms
//
//  Created by Robert Deans on 4/3/17.
//  Copyright © 2017 Robert Deans. All rights reserved.
//

import UIKit
import CoreLocation

class NewAlarmViewController: UIViewController {
    
    var parentVC: HomeViewController?
    var user: User?
    var coordinates: CLLocationCoordinate2D?
    let alarmWindowView = AlarmWindowView()
    let store = DataStore.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        view.addSubview(alarmWindowView)
        alarmWindowView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        
    }
    
    func configure() {
        user = store.user
        
        alarmWindowView.cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        alarmWindowView.addOrSaveAlarmButton.addTarget(self, action: #selector(addOrSaveAlarm), for: .touchUpInside)
    }
    
    
    func addOrSaveAlarm() {

        let newAlarm = Alarm()
        newAlarm.id = "\(UUID())"
        newAlarm.name = alarmWindowView.nameTextField.text
        newAlarm.notes = alarmWindowView.notesTextField.text
        
        if let coordinates = coordinates {
            newAlarm.location = Location(clLocation2d: coordinates)
        } else {
            print("no coordinates assigned to newAlarm")
        }
        
        try! store.realm.write {
            user?.alarms.append(newAlarm)
            print("alarm has ID \(newAlarm.id)")
            print("user has \(user?.alarms.count) alarms")
        }
        
        dismissView()
    }
    
    func dismissView() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
        parentVC?.dismissAlarmWindowVC()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
