//
//  ImportViewController.swift
//  Grocery List
//
//  Created by Kitzmiller, Andrew L (Marketing Department) on 11/13/15.
//  Copyright © 2015 Andrew Kitzmiller. All rights reserved.
//

import UIKit
import CoreData

class ImportViewController: UIViewController {
    
    @IBOutlet weak var submitBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var pasteField: UITextView!
    @IBOutlet weak var importSubmit: UIButton!
    //@IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func submitList(sender: AnyObject) {
        
        importSubmit.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        UIView.animateWithDuration(2.0 ,
            delay: 0,
            usingSpringWithDamping: 0.25,
            initialSpringVelocity:  6.00,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                self.importSubmit.transform = CGAffineTransformIdentity
            }, completion: nil)
            

        if !pasteField.text.isEmpty{
            let listText = pasteField.text
            let newlineChars = NSCharacterSet.newlineCharacterSet()
            let lines = listText.utf16.split { newlineChars.characterIsMember($0) }.flatMap(String.init)
            
            //Loops through each line of text entered into the textview and saves it into Core Data
            for line in lines{
                saveName(line)
            }
            
            pasteField.text = ""    //Clears the text from the textview
            
        } else{
            //errorLabel.text = "Please enter a list of items, one per line"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dismiss Keyboard when background tapped
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        
        pasteField.becomeFirstResponder()
    }
    
    func handleKeyboardNotification(notification: NSNotification){
        let userInfo = notification.userInfo!
        
        let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.submitBottomLayoutConstraint.constant = keyboardFrame.size.height + 10
            })
    }
    
    func handleKeyboardHideNotification(notification: NSNotification){
        let userInfo = notification.userInfo!
        
        let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.submitBottomLayoutConstraint.constant = 120
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** This function saves each item into core data */
    func saveName(name: String) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Item", inManagedObjectContext: managedContext)
        
        let groceryItem = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //3
        groceryItem.setValue(name, forKey: "name")
        groceryItem.setValue(false, forKey: "complete")
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
