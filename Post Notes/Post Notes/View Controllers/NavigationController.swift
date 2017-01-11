//
//  NavigationController.swift
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
import UIKit

class NavigationController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get the main storyboard so we can load the root view controller
        if let board = self.storyboard {
            
            //If the user had logged in, we will have loaded them from Realm
            if !RealmManager.sharedInstance.hasMainUser() {
                let authVC = board.instantiateViewController(withIdentifier: "authViewController")
                self.pushViewController(authVC, animated: false)
            } else {
                let noteVC = board.instantiateViewController(withIdentifier: "notesViewController")
                self.pushViewController(noteVC, animated: false)
            }
        }
    }
    
    //MARK: Authentication functions
    func logUserOut() {
        if let board = self.storyboard {
            let authVC = board.instantiateViewController(withIdentifier: "authViewController")
            self.setViewControllers([authVC], animated: true)
        } else {
            showAlert(title: "Logout Failed", message: "Unable to log out.  Please try again later.", sourceVC: self)
            NSLog("Unable to load AuthViewController from storyboard and reset view controller stack.")
        }
        
        RealmManager.sharedInstance.logoutMainUser()
    }
    
    func logUserIn() {
        //Get the main storyboard so we can load the root view controller
        if let board = self.storyboard {
            
            //If the user had logged in, we will have loaded them from Realm
            if RealmManager.sharedInstance.hasMainUser() {
                let noteVC = board.instantiateViewController(withIdentifier: "notesViewController")
                self.setViewControllers([noteVC], animated: true)
            }
        }
    }
}
