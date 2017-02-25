//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Iggy Mwangi on 2/24/17.
//  Copyright © 2017 iggy. All rights reserved.
//

import UIKit
import NotificationCenter
import RealmSwift

class TodayViewController: UIViewController, NCWidgetProviding {
    var realm : Realm!
    var todoList: Results<TaskItem> {
        get {
            return realm.objects(TaskItem.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: K_GROUP_ID)!
        
        let fileURL = directory.appendingPathComponent(K_DB_NAME)
        realm = try! Realm(fileURL: fileURL)
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
