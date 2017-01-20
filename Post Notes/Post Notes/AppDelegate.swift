//
//  AppDelegate.swift
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

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Configure Firebase
        FIRApp.configure()
        //Configure Google Sign-in
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        //Initialize our realm manager
        RealmManager.sharedInstance.initialize()
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            //Deep link for Google signin screen
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                        annotation: [:])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //Deep link for Google signin screen
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }
}

extension AppDelegate: GIDSignInDelegate {
    //Utility function to show an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "authViewController")
        vc.present(alert, animated: true, completion: nil)
    }

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        //Google Signin Finished - let's hand it off to Firebase.
        if let error = error {
            DispatchQueue.main.async {
                self.showAlert(title: "Login Failed", message: error.localizedDescription)
            }
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        //Signin to firebase using the Google token
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            //If the firebase signin succeeded, we'll have a user, otherwise we'll have an error
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Login Failed", message: error.localizedDescription)
                }
                return
            } else if let uzer = user {
                //Create our realm user from Firebase user, then save it to the database and
                //show the list of notes
                let u = User.initFromFirebase(firUser: uzer)
                RealmManager.sharedInstance.mainUser = u
                let vc = self.window?.rootViewController as! NavigationController
                vc.logUserIn()
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
                withError error: Error!) {
        //This is mostly untested - not clear to me when didDisconnectWith gets called
//        try! FIRAuth.auth()?.signOut()
//        let vc = self.window?.rootViewController as! NavigationController
//        vc.logUserOut()
    }
}
