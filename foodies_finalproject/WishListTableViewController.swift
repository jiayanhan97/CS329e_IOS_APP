//
//  WishListTableViewController.swift
//  foodies_finalproject
//
//  Created by 应芮 on 2019/5/3.
//  Copyright © 2019 Rui Ying. All rights reserved.
//

import UIKit
import CoreData

class WishListTableViewCell: UITableViewCell{
    


    @IBOutlet weak var pic: UIImageView!
    
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var name: UITextView!
}

class WishListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"WishList")
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = managedContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            NSLog("Unable to fetch \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        if let results = fetchedResults {
            wishlists = results
        }
        self.tableView.reloadData()
    // MARK: - Table view data source
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wishlists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "WishListTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WishListTableViewCell
        
        let wishlist = wishlists[indexPath.row]
        cell.name.text = wishlist.value(forKey: "name") as? String
        cell.pic.image = UIImage(data: ((wishlist.value(forKey: "image") as! NSData) as Data))
        let Address = wishlist.value(forKey: "address") as! String
        cell.address.text = "Address: " + Address
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.managedObjectContext
        
        if editingStyle == .delete{
            do{
                managedContext.delete(wishlists[indexPath.row])
                wishlists.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                try managedContext.save()
                tableView.reloadData()
            }
            catch{
                let nserror = error as NSError
                NSLog("Unable to fetch \(nserror),\(nserror.userInfo)")
                abort()
            }
        }
    }
}
