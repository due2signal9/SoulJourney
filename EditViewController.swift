//
//  EditViewController.swift
//  MyNotes
//
//  Created by PengJiLi on 16/9/17.
//  Copyright © 2016年 PengJiLi. All rights reserved.
//

import UIKit
let titleName = "title"
let summaryName = "summary"
class EditViewController: UIViewController {
    //通过时间字符串，来判断是修改还是新增
    var myDate:String?
    
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置导航条
        setNaviItems()
        //设置文本视图的代理
        summaryTextView.delegate = self
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if DetailModel != nil{
            summaryTextView.text = DetailModel?.summary
            titleTextField.text = DetailModel?.title
            myDate = DetailModel?.time
        }
    }
    
    //设置导航条item
    func setNaviItems(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style:.Done, target: self, action: "rightBtnAction")
    }
    //右边完成按钮点击事件
    func rightBtnAction(){
        if summaryTextView.text != "" {
            //当前时间
            //将时间戳转换成时间
            let formart = NSDateFormatter()
            //将字符串转换成时间
            //y-年,M-月,d-日，h/H-时，m-分,s-秒,S-毫秒,E-周
            formart.dateStyle = .LongStyle
            formart.timeStyle = .LongStyle
            formart.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var currentDate = formart.stringFromDate(NSDate())
            if myDate != nil{
                currentDate = myDate!
            }
            var titleData = titleTextField.text?.dataUsingEncoding(NSUTF8StringEncoding)
            if titleTextField.text == ""{
                titleData = ("无标题笔记").dataUsingEncoding(NSUTF8StringEncoding)
            }
            let summaryData = summaryTextView.text.dataUsingEncoding(NSUTF8StringEncoding)
            NSFileManager.defaultManager().createFileAtPath(NotesPath+"/\(currentDate)title.text", contents: titleData, attributes: nil)
            NSFileManager.defaultManager().createFileAtPath(NotesPath+"/\(currentDate)summary.text", contents: summaryData, attributes: nil)
            
            
            
            let fileNameArray = NSData.init(contentsOfFile: NotesPath+"/fileName.text")
            if fileNameArray != nil
            {
                
                let handle = NSFileHandle.init(forReadingAtPath: NotesPath+"/fileName.text")
                handle?.seekToFileOffset(0)
                let data = handle?.readDataToEndOfFile()
                var str = String.init(data: data!, encoding: NSUTF8StringEncoding)
                for i in 0..<str!.characters.count/19{
                    let timeStr = (str! as NSString).substringWithRange(NSMakeRange(i*19,19))
                    if currentDate == timeStr{
                        return
                    }
                }
                str =  str! + currentDate
                str?.dataUsingEncoding(NSUTF8StringEncoding)?.writeToFile( NotesPath+"/fileName.text", atomically: true)
                
            }else
            {
                NSFileManager.defaultManager().createFileAtPath(NotesPath+"/fileName.text", contents: currentDate.dataUsingEncoding(NSUTF8StringEncoding), attributes: nil)
            }
            KVNProgress.showSuccessWithStatus("保存成功")
        }else{
            print("请输入笔记内容")
        }
    }
   
    
}
extension EditViewController:UITextViewDelegate{
    func textViewDidBeginEditing(textView: UITextView) {
        UIView.animateWithDuration(0.5) { () -> Void in
            let height = self.summaryTextView.frame.size.height - 250
            let x = self.summaryTextView.frame.origin.x
            let y = self.summaryTextView.frame.origin.y
            let width = self.summaryTextView.frame.size.width
            self.summaryTextView.frame = CGRectMake(x,y, width, height)
            
        }
    }
}