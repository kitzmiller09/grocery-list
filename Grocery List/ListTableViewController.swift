//
//  ListTableViewController.swift
//  Grocery List
//
//  Created by Kitzmiller, Andrew L (Marketing Department) on 11/24/15.
//  Copyright © 2015 Kitzmiller, Andrew L (Marketing Department). All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBAction func clearButtonPressed(sender: AnyObject) {
        if groceryItems.count > 0{
            let alertController = UIAlertController(title: "Clear List", message: "Are you sure you would like to clear your list?", preferredStyle: .Alert)
            //Alert or .ActionSheet
            
            // Create the actions
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
                UIAlertAction in
            }
            
            let clearAction = UIAlertAction(title: "Clear", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.deleteAllItems()
                
                self.viewWillAppear(true)    //Reload the table view data
            }
            
            // Add the actions
            alertController.addAction(clearAction)
            alertController.addAction(cancelAction)
            
            // Present the controller
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let errorController = UIAlertController(title: "Cannot Clear List", message: "There are no items to delete", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                
            }
            errorController.addAction(okAction)
            self.presentViewController(errorController, animated: true, completion: nil)
        }
    }
    var groceryItems = [NSManagedObject]()
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        var finalList = "";
        for(var i = 0; i < groceryItems.count; i++){
            let groceryItem = groceryItems[i]
            finalList += "\(groceryItem.valueForKey("name") as! String)\n";
        }
        
        UIPasteboard.generalPasteboard().string = finalList //Copies the list to the users clipboard
        
        let alertController = UIAlertController(title: "Copied To Clipboard", message: "Your grocery list has been copied to your clipboard.", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
        }
        
        // Add the actions
        alertController.addAction(okAction)
        
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil) //Removes Text From Back Button
        
        let myActivity = NSUserActivity(activityType: "Andrew.Grocery-List")
        myActivity.title = "Handful"
        myActivity.keywords = Set(arrayLiteral: "Handful", "Groceries", "Grocery List", "List")
        self.userActivity = myActivity
        myActivity.eligibleForHandoff = false
        myActivity.becomeCurrent()
        
        
//        addButton.configureButtonWithHightlightedShadowAndZoom(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Item")
        let othersortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptors = NSSortDescriptor(key: "complete", ascending: true)

        
        fetchRequest.sortDescriptors = [sortDescriptors, othersortDescriptors]
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            groceryItems = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        animateTable()
        //tableView.reloadData()
    }
    
    //ANIMATE TABLE CELLS
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groceryItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groceryItem", forIndexPath: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let groceryItem = groceryItems[indexPath.row]
        
        cell.tintColor = UIColor.whiteColor()   //Used to set the color of accesories
        
        let font = UIFont(name: "OpenSans", size: 17.0)
            for FontName in UIFont.fontNamesForFamilyName("OpenSans"){
                print(FontName)
                print("-")
            }
        
        //cell.textLabel!.font = UIFont(name: "Boysen-Regular", size: 17.0)   //Set text font-family
        cell.textLabel!.font = font
        cell.textLabel!.text = groceryItem.valueForKey("name") as? String
        
        //Set color and accesory type of cells based on "complete"
        if (groceryItem.valueForKey("complete") as! Bool){
            cell.accessoryType = .Checkmark
            
            let blueColor = UIColor(red: 84/255, green: 150/255, blue: 146/255, alpha: 1.0)
            cell.backgroundColor = blueColor
            cell.textLabel?.backgroundColor = blueColor
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.contentView.backgroundColor = blueColor
            
        } else {
            cell.accessoryType = .None; //Removes accessory
            let bgColor = UIColor.clearColor()
            
            cell.backgroundColor = bgColor
            cell.textLabel?.backgroundColor = bgColor
            cell.textLabel?.textColor = UIColor(red: 37/255, green: 62/255, blue: 109/255, alpha: 1.0)
            cell.contentView.backgroundColor = bgColor
        }
        
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context: NSManagedObjectContext = appDel.managedObjectContext
            context.deleteObject(groceryItems[indexPath.row])
            groceryItems.removeAtIndex(indexPath.row);
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    
    //CELL Tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            //Checks if the item is marked as complete
            if cell.accessoryType == .Checkmark{
                let tableCellText = cell.textLabel!.text!   //Retrieves the table cells text value
                
                
                //Mark Item INCOMPLETE
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                let managedContext = appDelegate.managedObjectContext
                
                let fetchRequest = NSFetchRequest(entityName: "Item")
                fetchRequest.predicate = NSPredicate(format: "name = %@", tableCellText)
                var item: [NSManagedObject] = [];
                do {
                    let results =
                    try managedContext.executeFetchRequest(fetchRequest)
                    item = results as! [NSManagedObject]
                    item[0].setValue(false, forKey: "complete")     //Item's "complete" core data attribute changed to false
                    cell.accessoryType = .None; //Removes accessory
                    
                    let bgColor = UIColor.clearColor()
                    
                    cell.backgroundColor = bgColor
                    cell.contentView.backgroundColor = bgColor
                    cell.textLabel?.textColor = UIColor(red: 37/255, green: 62/255, blue: 109/255, alpha: 1.0)
                } catch let error as NSError {
                    print("Could not fetch \(error), \(error.userInfo)")
                }
                
                /* BEGINNING OF MOVE SELECTED ITEM TO FRONT */
                tableView.beginUpdates()
                
                tableView.moveRowAtIndexPath(indexPath, toIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                groceryItems.insert(groceryItems.removeAtIndex(indexPath.row), atIndex: 0)
                
                tableView.endUpdates()
                /* END OF MOVE SELECTED ITEM TO FRONT */
            } else {
                cell.accessoryType = .Checkmark;
                let tableCellText = cell.textLabel!.text!   //Used to search through core data
                
                //Mark Item COMPLETE
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                let managedContext = appDelegate.managedObjectContext
                
                let fetchRequest = NSFetchRequest(entityName: "Item")
                
                fetchRequest.predicate = NSPredicate(format: "name = %@", tableCellText)    //Searches for "Item " entity similar to selected cell
                
                var item: [NSManagedObject] = [];
                do {
                    let results =
                    try managedContext.executeFetchRequest(fetchRequest)
                    item = results as! [NSManagedObject]
                    item[0].setValue(true, forKey: "complete")  //Item's "complete" core data attribute set to true
                    cell.accessoryType = .Checkmark;    //Adds checkmark accessory
                    //change color to blue
                    let blueColor = UIColor(red: 84/255, green: 150/255, blue: 146/255, alpha: 1.0)
                    cell.backgroundColor = blueColor
                    cell.textLabel?.backgroundColor = blueColor
                    cell.contentView.backgroundColor = blueColor
                    cell.textLabel?.textColor = UIColor.whiteColor()
                    
                } catch let error as NSError {
                    print("Could not fetch \(error), \(error.userInfo)")
                }

                /* BEGINNING OF MOVE SELECTED ITEM TO BACK */
                let lastIndex = groceryItems.count - 1;
                
                tableView.beginUpdates()
                
                tableView.moveRowAtIndexPath(indexPath, toIndexPath: NSIndexPath(forRow: lastIndex, inSection: 0))
                groceryItems.insert(groceryItems.removeAtIndex(indexPath.row), atIndex: lastIndex)
                
                tableView.endUpdates()
                /* END OF MOVE SELECTED ITEM TO BACK */
            }
        }
    }
    
    /**
     *  This function removes all items from core data.
     */
    func deleteAllItems(){
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "Item")
        request.includesPropertyValues = false
        
        do {
            let items = try context.executeFetchRequest(request)
            
            if items.count > 0 {
                
                for result: AnyObject in items{
                    //Deletes all objects
                    context.deleteObject(result as! NSManagedObject)
                    
                }
                try context.save() } } catch {}
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}