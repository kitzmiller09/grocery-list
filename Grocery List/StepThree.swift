//
//  StepThree.swift
//  Grocery List
//
//  Created by Kitzmiller, Andrew L (Marketing Department) on 12/4/15.
//  Copyright © 2015 Kitzmiller, Andrew L (Marketing Department). All rights reserved.
//

import UIKit

class StepThree: UIViewController {

    @IBAction func showHome(sender: AnyObject) {
        //perform Segue
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Home")
        self.navigationController?.pushViewController(secondViewController!, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
