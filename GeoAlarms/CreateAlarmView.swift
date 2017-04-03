//
//  AlarmMarkerWindow.swift
//  TrainNapper
//
//  Created by Robert Deans on 3/31/17.
//  Copyright © 2017 Robert Deans. All rights reserved.
//

import Foundation
import UIKit

class CreateAlarmView: UIView {
    

    
    var nameTextField: UITextField!
    var notesTextField: UITextField!
//    var proximityRadius: 
//    var iconStyle:
    var addOrSaveAlarmButton: UIButton!
    var cancelButton: UIButton!
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init(frame: CGRect) { super.init(frame: frame) }
    
    convenience init() {
        let width = UIScreen.main.bounds.width / 1.2
        let height = width
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        configure()
        constrain()
    }
    

    


    
    func configure() {
        backgroundColor = UIColor.cyan
        
        layer.cornerRadius = 5
        nameTextField = UITextField()
        nameTextField.text = "NAME"
        nameTextField.backgroundColor = UIColor.lightGray
        
        notesTextField = UITextField()
        notesTextField.text = "NOTES"
        notesTextField.backgroundColor = UIColor.lightGray
        
        addOrSaveAlarmButton = UIButton()
        addOrSaveAlarmButton.backgroundColor = UIColor.purple
        addOrSaveAlarmButton.setTitle("Update", for: .normal)
        
        cancelButton = UIButton()
        cancelButton.backgroundColor = UIColor.blue
        cancelButton.setTitle("X", for: .normal)

    }
    
    func constrain() {
        
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
        }
        
        addSubview(nameTextField)
        nameTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.top.equalToSuperview().offset(50)
        }
        
        addSubview(notesTextField)
        notesTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.top.equalTo(nameTextField.snp.bottom).offset(5)
        }
        
        addSubview(addOrSaveAlarmButton)
        addOrSaveAlarmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
        

    }
    
}
