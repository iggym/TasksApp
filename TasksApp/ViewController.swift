//
//  ViewController.swift
//  TasksApp
//
//  Created by Iggy Mwangi on 2/22/17.
//  Copyright © 2017 iggy. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = taskList[indexPath.row]
        
        cell.textLabel!.text = item.detail
        cell.detailTextLabel!.text = "\(item.status)"
        
        return cell    }
    
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = taskList[indexPath.row]
        try! self.realm.write({
            if (item.status == 0){
                item.status = 1
            }else{
                item.status = 0
            }
        })
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete){
            let item = taskList[indexPath.row]
            try! self.realm.write({
                self.realm.delete(item)
            })
            
            tableView.deleteRows(at:[indexPath], with: .automatic)
            
        }
        
    }
    
    // MARK IBAction for add New
    @IBAction func addNew(_ sender: Any) {
        let alertController : UIAlertController = UIAlertController(title: "New Task", message: "What do you plan to do?", preferredStyle: .alert)
        
        alertController.addTextField { (UITextField) in
            
        }
        
        let action_cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (UIAlertAction) -> Void in
            
        }
        alertController.addAction(action_cancel)
        
        let action_add = UIAlertAction.init(title: "Add", style: .default) { (UIAlertAction) -> Void in
            let textField_todo = (alertController.textFields?.first)! as UITextField
            print("You entered \(textField_todo.text)")
            let todoItem = TaskItem()
            todoItem.detail = textField_todo.text!
            todoItem.status = 0
            
            try! self.realm.write({ // [2]
                self.realm.add(todoItem)
                self.tableView.insertRows(at: [IndexPath.init(row: self.taskList.count-1, section: 0)], with: .automatic)
            })
        }
        alertController.addAction(action_add)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Realm
    let realm = try! Realm()
    var taskList: Results<TaskItem> {
        get {
            return realm.objects(TaskItem.self)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

