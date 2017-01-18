//
//  User.swift
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

import Foundation
import FirebaseAuth

class User: BaseObject {
    dynamic var authID: String = ""
    dynamic var email: String = ""
    dynamic var pictureURL: String = ""
    dynamic var authToken: String = ""
    
    static func initFromFirebase(firUser: FIRUser) -> User {
        let u = User()
        u.id = 1
        u.authID = firUser.uid
        if let em = firUser.email {
            u.email = em
        }
        if let pic = firUser.photoURL {
            u.pictureURL = pic.absoluteString
        }
        RealmManager.sharedInstance.saveModel(model: u)
        firUser.getTokenWithCompletion() { (token, error) in
            if let t = token {
                try! RealmManager.sharedInstance.realm.write {
                    u.authToken = t
                    NSLog("Token set to \(t)")
                }
            } else {
                NSLog("Unable to get firebase token: \(error!.localizedDescription)")
            }
        }
        
        return u
    }
}
