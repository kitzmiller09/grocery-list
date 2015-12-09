//
//  OnboardingPageViewController.swift
//  Grocery List
//
//  Created by Kitzmiller, Andrew L (Marketing Department) on 12/4/15.
//  Copyright © 2015 Kitzmiller, Andrew L (Marketing Department). All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers([getStepZero()], direction: .Forward, animated: false, completion: nil)
        
        dataSource = self
        
        view.backgroundColor = .darkGrayColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getStepZero() -> StepZero {
        return storyboard!.instantiateViewControllerWithIdentifier("StepZero") as! StepZero
    }
    
    func getStepOne() -> StepOne {
        return storyboard!.instantiateViewControllerWithIdentifier("StepOne") as! StepOne
    }
    
    func getStepTwo() -> StepTwo {
        return storyboard!.instantiateViewControllerWithIdentifier("StepTwo") as! StepTwo
    }
    
    func getStepThree() -> StepThree {
        return storyboard!.instantiateViewControllerWithIdentifier("StepThree") as! StepThree
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if viewController.isKindOfClass(StepThree) {
            // 3 -> 2
            return getStepTwo()
        } else if viewController.isKindOfClass(StepTwo) {
            // 2 -> 1
            return getStepOne()
        } else if viewController.isKindOfClass(StepOne) {
            // 1 -> 0
            return getStepZero()
        } else {
            // 0 -> end of the road
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if viewController.isKindOfClass(StepZero) {
            // 0 -> 1
            return getStepOne()
        } else if viewController.isKindOfClass(StepOne) {
            // 1 -> 2
            return getStepTwo()
        } else if viewController.isKindOfClass(StepTwo){
            // 2-> 3
            return getStepThree()
        } else {
            // 3 -> end of the road
            return nil
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 4
    }
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
