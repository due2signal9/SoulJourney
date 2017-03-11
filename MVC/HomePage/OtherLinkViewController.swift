//
//  OtherLinkViewController.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/20.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit

class OtherLinkViewController: UIViewController {
    
    var webView = UIWebView()
    
    var url:String? = nil{
        didSet{
            print(url)
            //直接加载请求
            if url != nil{
                let ocStr = url?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                if let urlPath = NSURL(string: ocStr!) {
                    self.webView.loadRequest(NSURLRequest(URL: urlPath))
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        webView.frame = self.view.bounds
        self.view.addSubview(webView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        ToolManager.memoryClean()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //ToolManager.memoryClean()
    }
    
}
