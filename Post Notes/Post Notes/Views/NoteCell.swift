//
//  NoteCell.swift
//  Post Notes
//
//  Created by James McCarthy on 1/10/17.
//  Copyright © 2017 Digital Catnip. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    @IBOutlet weak var noteText: UILabel!
    
    var note: Note?
    
    func configure() {
        if let n = note {
            noteText.text = n.note
        }
    }
}
