//
//  NoteViewController.swift
//  SoulJourney
//
//  Created by 前锋1 on 16/10/31.
//  Copyright © 2016年 qiongjiwuxian. All rights reserved.
//

import UIKit



//文件缓存目录
let NotesPath = NSHomeDirectory() + "/Documents/Notes"
//详情里面的数据
var DetailModel:DataModel?

class NoteViewController: UIViewController {
        
        lazy var dataArray:[DataModel] = {
            return self.getData()
        }()
        
        
        
        @IBOutlet weak var MyTableView: UITableView!
        override func viewDidLoad() {
            super.viewDidLoad()
            //创建存备忘录的文件夹
            do{
                try NSFileManager.defaultManager().createDirectoryAtPath(NotesPath, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print("已经创建")
            }
            
            print(NotesPath)
            
            
            self.automaticallyAdjustsScrollViewInsets = false
            //设置标题
            self.title = "记事本"
            
            
            //print(String(NSDate()).characters.count)
            MyTableView.frame = CGRectMake(0, 0, screenW, screenH-64)
            
            
            //设置代理
            MyTableView.delegate = self
            MyTableView.dataSource = self
            
            //注册Cell
            MyTableView.registerNib(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
            MyTableView.rowHeight = 100
            //设置
            //            self.navigationController?.navigationBar.barTintColor = UIColor(red: 75/255, green: 131/255, blue: 241/255, alpha: 0.8)
            //            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
            
        }
        
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            
            dataArray = self.getData()
            
            MyTableView.reloadData()
        }
        
    }
    extension NoteViewController:UITableViewDataSource,UITableViewDelegate{
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataArray.count
        }
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
            let model = dataArray[indexPath.row]
            
            
            cell.timeLabel.text = model.time
            
            cell.titleLabel.text = model.title
            
            cell.summaryLabel.text = model.summary
            
            
            return cell
        }
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            DetailModel = dataArray[indexPath.row]
            let detail = UIStoryboard.init(name: "Edit", bundle: nil)
            let view = detail.instantiateInitialViewController()
            self.navigationController?.pushViewController(view!, animated: true)
            
        }
        func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
            return .Delete
        }
        func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            deleData(indexPath.row)
            
            dataArray.removeAtIndex(indexPath.row)
            
            self.MyTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        
    }
    extension NoteViewController{
        
        @IBAction func addAction(sender: UIButton) {
            let editView = UIStoryboard.init(name:"Edit", bundle: nil)
            let viewController = editView.instantiateInitialViewController()
            DetailModel = nil
            
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
    }
    extension NoteViewController{
        ///获取数据
        func getData() -> [DataModel] {
            var tempArray = [DataModel]()
            var str = ""
            let handle = NSFileHandle.init(forReadingAtPath: NotesPath+"/fileName.text")
            if handle != nil{
                handle?.seekToFileOffset(0)
                let data = handle?.readDataToEndOfFile()
                str = String.init(data: data!, encoding: NSUTF8StringEncoding)!
            }else{
                return tempArray
            }
            
            for i in 0..<str.characters.count/19{
                let timeStr = (str as NSString).substringWithRange(NSMakeRange(i*19,19))
                
                let handle0 = NSFileHandle.init(forReadingAtPath: NotesPath+"/"+timeStr+"title.text")
                let handle1 = NSFileHandle.init(forReadingAtPath: NotesPath+"/"+timeStr+"summary.text")
                
                handle0?.seekToFileOffset(0)
                let titleStr = String.init(data: (handle0?.readDataToEndOfFile())!, encoding: NSUTF8StringEncoding)
                
                handle1?.seekToFileOffset(0)
                let summaryStr = String.init(data: (handle1?.readDataToEndOfFile())!, encoding: NSUTF8StringEncoding)
                let model = DataModel(title: titleStr, summary: summaryStr, time: timeStr)
                tempArray.append(model)
            }
            return tempArray
        }
        ///删除数据
        func deleData(index:Int) {
            let fileNameArray = NSData.init(contentsOfFile: NotesPath+"/fileName.text")
            if fileNameArray != nil
            {
                
                let handle = NSFileHandle.init(forReadingAtPath: NotesPath+"/fileName.text")
                handle?.seekToFileOffset(0)
                let data = handle?.readDataToEndOfFile()
                //var str = String.init(data: data!, encoding: NSUTF8StringEncoding)! as NSString
                let str = NSMutableString(data: data!, encoding: NSUTF8StringEncoding)
                
                let timeStr = str!.substringWithRange(NSMakeRange(index*19,19))
                
                let path = NotesPath + "/" + timeStr + "title.text"
                if NSFileManager.defaultManager().fileExistsAtPath(path){
                    do{
                        try NSFileManager.defaultManager().removeItemAtPath(path)
                    }catch{
                        
                    }
                }
                
                let path1 = NotesPath + "/" + timeStr + "summary.text"
                if NSFileManager.defaultManager().fileExistsAtPath(path1){
                    do{
                        try NSFileManager.defaultManager().removeItemAtPath(path1)
                    }catch{
                        
                    }
                }
                
                
                
                str?.deleteCharactersInRange(NSMakeRange(index*19, 19))
                str!.dataUsingEncoding(NSUTF8StringEncoding)?.writeToFile( NotesPath+"/fileName.text", atomically: true)
            }
        }
    }



