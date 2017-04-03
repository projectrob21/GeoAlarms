//
//  AlarmWindowViewController.swift
//  GeoAlarms
//
//  Created by Robert Deans on 4/3/17.
//  Copyright © 2017 Robert Deans. All rights reserved.
//

import UIKit

class AlarmWindowViewController: UIViewController {

    var parentVC: HomeViewController?
    var user: User?
    var alarm: Alarm?
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
        // create a new alarm and add to the user in datastore
        print("add or save alarm tapped")
        if alarm?.id == "" {
            alarm?.id = "\(UUID())"
            alarm?.name = alarmWindowView.nameTextField.text
            
            try! store.realm.write {
                user?.alarms.append(alarm)
            }
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
