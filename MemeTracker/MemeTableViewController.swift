//
//  MemeTableViewController.swift
//  MemeTracker
//
//  Created by Trevor Murphy on 8/11/17.
//  Copyright © 2017 Trevor Murphy. All rights reserved.
//

import UIKit
import os.log

class MemeTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var memes = [Meme]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load any saved memes, otherwise load sample data.
        if let savedMemes = loadMemes() {
            memes += savedMemes
        } else {
            // Load the sample data.
            loadSampleMemes()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MemeTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MemeTableViewCell else {
            fatalError("The dequeued cell is not an instance of MemeTableViewCell.")
        }
        
        // Fetches the appropriate meme for the data source layout.
        let meme = memes[indexPath.row]

        cell.nameLabel.text = meme.name
        cell.photoImageView.image = meme.photo
        cell.ratingControl.rating = meme.rating

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            memes.remove(at: indexPath.row)
            saveMemes()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meme.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let memeDetailViewController = segue.destination as? MemeViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedMemeCell = sender as? MemeTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedMemeCell) else {
                fatalError("The selected cell is not being displayed by the table!")
            }
            let selectedMeme = memes[indexPath.row]
            memeDetailViewController.meme = selectedMeme
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: Actions
    
    @IBAction func unwindToMemeList(sender: UIStoryboardSegue) {
        if let source = sender.source as? MemeViewController, let meme = source.meme {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meme.
                memes[selectedIndexPath.row] = meme
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new meme
                let newIndexPath = IndexPath(row: memes.count, section: 0)
                memes.append(meme)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
            
            // Save the memes.
            saveMemes()
        }
    }
    
    // MARK: Private Methods
    
    private func loadSampleMemes() {
        let photo1 = UIImage(named: "meme1")
        let photo2 = UIImage(named: "meme2")
        let photo3 = UIImage(named: "meme3")
        
        guard let meme1 = Meme(name: "Wut", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meme1")
        }
        guard let meme2 = Meme(name: "Why", photo: photo2, rating: 3) else {
            fatalError("Unable to instantiate meme2")
        }
        guard let meme3 = Meme(name: "One Does Not Simply", photo: photo3, rating: 5) else {
            fatalError("Unable to instantiate meme3")
        }
        
        memes += [meme1, meme2, meme3]
    }
    
    private func saveMemes() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(memes, toFile: Meme.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Memes successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save memes...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMemes() -> [Meme]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meme.ArchiveURL.path) as? [Meme]
    }
}
