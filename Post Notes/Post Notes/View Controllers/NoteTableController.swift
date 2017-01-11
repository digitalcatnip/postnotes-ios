//
//  NoteTableController.swift
//  Post Notes
//
//  Created by James McCarthy on 1/9/17.
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

class NoteTableController: UITableViewController {
    
    var notes: [Note] = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //1. Load notes from Realm
        
        //2. Refresh from API
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteCell
        noteCell.note = notes[indexPath.row]
        noteCell.configure()
        
        return noteCell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "entrySegue" {
            let vc = segue.destination as! NoteEntryController
            vc.delegate = self
        }
    }
    
    //TODO: Fill this in
    func reloadFromAPI() {
        //This is a 2 step process -
        //1. Call the API to refresh Realm
        //2. When the API is done, then reload from Realm
        //3. Pay attention to what thread you are located on!
    }
    
    //TODO: Fill this in
    func loadFromRealm() {
        //A call to RealmManager is probably appropriate here
        //What variable stores the notes for the table?
    }
}

extension NoteTableController: NoteEntryDelegate {
    func addNote(noteText: String) {
        let note = Note()
        note.note = noteText
        notes.append(note)
    }
    
    func dismissMe() {
        self.dismiss(animated: true) { () in
            self.tableView.reloadData()
        }
    }
}
