//
//  ListTableViewController.swift
//  Grocery List
//
//  Created by Andrew Kitzmiller on 11/12/15.
//  Copyright © 2015 Andrew Kitzmiller. All rights reserved.
//

import UIKit

let ANIMATION_DURATION = 0.2


var zShadow:Bool?
var zZoom:Bool?
var zKeepHighlighted:Bool?

public extension UIButton  {
    
    
    // MARK : Helpers
    
    func configureButtonWithHightlightedShadowAndZoom(zShadowAndZoom:Bool){
        zShadow = zShadowAndZoom
        zZoom = zShadowAndZoom
        configureToSelected(false)
    }
    
    // MARK : Button states
    
    override var highlighted: Bool {
        didSet {
            
            configureToSelected(highlighted)
            
        }
    }
    
    func configureToSelected( selected: Bool){
        
        if(zKeepHighlighted == true || selected == true) {
            alpha = 1.0
            if(zShadow == true){
                UIView.animateWithDuration(ANIMATION_DURATION, animations: { () -> Void in
                    self.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    if(zShadow == true){
                        self.layer.shadowOpacity = 1
                    }
                })
            }
            
            if(zShadow == true){
                //layer.shadowColor = UIColor.blackColor()
                layer.shadowOffset = CGSizeMake(1.0, 1.0)
                layer.shadowOpacity = 1
                layer.shadowRadius = 3
            }
        } else {
            if(zZoom == true){
                UIView.animateWithDuration(ANIMATION_DURATION, animations: { () -> Void in
                    self.transform=CGAffineTransformMakeScale(0.85 , 0.85)
                })
            }
            if(zShadow == true){
                layer.shadowOpacity = 0
            }
        }
        
    }
}
