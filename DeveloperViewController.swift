//
//  DeveloperViewController.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/11/1.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class DeveloperViewController: UIViewController {
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.frame = CGRectMake(100, 200, 240, 50)
        label.text = "BY - PengJiLi"
        label.textAlignment = .Center
        label.center = self.view.center
        label.font = UIFont.boldSystemFontOfSize(30)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        addGradientLayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func addGradientLayer(){
        let gradientLayer = CAGradientLayer()
        
        var colors = [UIColor]()
        
        var locations = [CGFloat]()
        
        let toValue = NSMutableArray()
        
        for i in 0...19{
            let color = UIColor(red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: 1)
            
            colors.append(color)
            
            locations.append(CGFloat(i)/CGFloat(19))
            
            toValue.addObject(color.CGColor)
        }
        
        gradientLayer.locations = locations
        
        gradientLayer.colors = colors
        
        gradientLayer.startPoint = CGPointMake(0, 0)
        gradientLayer.endPoint = CGPointMake(1, 1)
        
        gradientLayer.type = kCAGradientLayerAxial
        
        gradientLayer.bounds = self.view.bounds
        gradientLayer.position = self.view.center
    
        gradientLayer.mask = label.layer
        
        let animation = CABasicAnimation(keyPath: "colors")
        
        animation.duration = 2
        
        animation.repeatCount = MAXFLOAT
        
        animation.toValue = toValue
        
        gradientLayer.addAnimation(animation, forKey: "gradientLayer")
        
        self.view.layer.addSublayer(gradientLayer)
    }
}
