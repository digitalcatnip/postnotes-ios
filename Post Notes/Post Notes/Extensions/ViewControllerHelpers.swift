//
//  ViewControllerHelpers.swift
//  Post Notes
//
//  Created by James McCarthy on 1/9/17.
//  Copyright © 2017 Digital Catnip. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title : String, message: String, sourceVC: UIViewController) {
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
        sourceVC.present(alert, animated: true, completion: nil)
    }
}
