//
//  RegisterViewController.swift
//  MovieFansDemo1
//
//  Created by 千锋1 on 16/10/8.
//  Copyright © 2016年 琼极无限. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    //MARK: - 属性
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord1: UITextField!
    @IBOutlet weak var passWord2: UITextField!
    //闭包反向传值
    var sendValue:((String) -> Void)? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        creatUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension RegisterViewController{
    
    @IBAction func registerAction(sender: UIButton) {
        if userName.text != "" && passWord1.text != "" && passWord2.text == passWord1.text && email.text != ""{
            KVNProgress.showWithStatus("正在注册...")
            
            ToolManager.BmobUserRegister(userName.text!, passWord: passWord1.text!,email: email.text! ,result: { (bool, str) -> Void in
                if bool{
                    KVNProgress.showSuccessWithStatus(str)
                    self.sendValue!(self.userName.text!)
                    self.navigationController?.popViewControllerAnimated(true)
                    print(str)
                }else{
                    KVNProgress.showErrorWithStatus(str)
                }
                
            })
        }else{
            KVNProgress.showErrorWithStatus("账号或密码为空")
        }
    }
}
//MARK: - 界面相关
extension RegisterViewController{
    func creatUI() {
        let imageView1 = UIImageView(frame: CGRectMake(0, 0, 40, 40))
        
        imageView1.image = UIImage(named: "user")
        
        let imageView2 = UIImageView(frame: CGRectMake(0, 0, 40, 40))
        
        imageView2.image = UIImage(named: "pass")
        
        let imageView3 = UIImageView(frame: CGRectMake(0, 0, 40, 40))
        
        imageView3.image = UIImage(named: "pass")
        
        userName.leftView = imageView1
        userName.leftViewMode = .Always
        
        passWord1.leftView = imageView2
        passWord1.leftViewMode = .Always
        
        passWord2.leftView = imageView3
        passWord2.leftViewMode = .Always
        
        
    }
}