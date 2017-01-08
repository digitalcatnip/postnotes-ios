//
//  RealmManager.swift
//  Post Notes
//
//  Created by James McCarthy on 1/8/17.
//  Copyright © 2017 Digital Catnip. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

import RealmSwift

class BaseObject: Object {
    dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class RealmManager {
    static let sharedInstance = RealmManager()
    var realm = try! Realm()
    var mainUser: User? = nil
    
    func saveModel(model: Object) {
        try! realm.write {
            self.realm.add(model, update: true)
        }
    }
    
    func saveModels(models: [Object]) {
        try! realm.write {
            for model in models {
                self.realm.add(model, update: true)
            }
        }
    }
    
    func deleteModels(models: [Object]) {
        try! realm.write {
            for object in models {
                self.realm.delete(object)
            }
        }
    }
    
    func query<T>(type: T.Type, queryString: NSPredicate?) -> Results<T> {
        if queryString != nil {
            return realm.objects(type).filter(queryString!)
        } else {
            return realm.objects(type)
        }
    }
    
    func initialize() {
        initializeUser()
    }
    
    func initializeUser() {
        let users = RealmManager.sharedInstance.query(type: User.self, queryString: nil)
        NSLog("Found %d users", users.count)
        if(users.count > 0) {
            mainUser = users[0];
        }
    }
    
    func getMainUser() -> User? {
        return mainUser;
    }
    
    func hasMainUser() -> Bool {
        if let _ = mainUser {
            return true;
        }
        return false;
    }
}

