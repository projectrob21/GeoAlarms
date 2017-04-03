//
//  JSONSerializer.swift
//  TrainNapper
//
//  Created by Robert Deans on 12/24/16.
//  Copyright © 2016 Robert Deans. All rights reserved.
//

import Foundation
import RealmSwift


final class DataStore {
    
    static let shared = DataStore()
    
    let realm = try! Realm()
    
    var user: User! = User()
    
    func addUserToRealm() {
        try! realm.write {
            realm.add(user)
        }
    }

    
    


}
