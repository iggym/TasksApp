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

class TodayViewController: UIViewController, UITableViewDataSource, NCWidgetProviding {
    var realm : Realm!
    var todoList: Results<TaskItem> {
        get {
            return realm.objects(TaskItem.self)
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = todoList[indexPath.row]
        
        cell.textLabel!.text = item.detail
        cell.detailTextLabel!.text = "\(item.status)"
        
        return cell
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
