//
//  NoteCell.swift
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

class NoteCell: UITableViewCell {
    @IBOutlet weak var noteText: UILabel!
    
    var note: Note?
    
    func configure() {
        if let n = note {
            noteText.text = n.note
        }
    }
}
