//
//  NoteEntryController.swift
//  Post Notes
//
//  Created by James McCarthy on 1/10/17.
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

protocol NoteEntryDelegate {
    func addNote(noteText: String)
    func dismissMe()
}

class NoteEntryController: UIViewController {
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var delegate: NoteEntryDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        submitButton.isHidden = true
        submitButton.alpha = 0.0
        label.isHidden = false
        label.alpha = 1.0
    }
    
    @IBAction func submitNote(sender: UIButton) {
        textView.resignFirstResponder()
        if let d = delegate {
            let nsString = textView.text as NSString
            let text = nsString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            d.addNote(noteText: text)
            d.dismissMe()
        }
    }
    
    func animateLabelOut() {
        submitButton.alpha = 1.0
        label.alpha = 0.0
    }
}

//MARK: UITextViewDelegate functions
extension NoteEntryController: UITextViewDelegate {    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if submitButton.isHidden {
            submitButton.isHidden = false
            submitButton.alpha = 0.0
            label.alpha = 1.0
            UIView.animate(withDuration: 0.5, animations: self.animateLabelOut) { (complete) in
                self.label.isHidden = true
            }
        }
    }
}
