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
    var realm : Realm!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: K_GROUP_ID)!
        
        let fileURL = directory.appendingPathComponent(K_DB_NAME)
        realm = try! Realm(fileURL: fileURL)
        
        // Extras if you wonder where your files is saved
        print("file url \(realm.configuration.fileURL)")
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomButtonView = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomButtonView
        
        let item = taskList[indexPath.row]
        //cell.textLabel!.text = item.detail
        cell.itemLabel.text = item.detail
        //cell.detailTextLabel!.text = "\(item.status)"
        cell.tickButton.addTarget(self, action:#selector(ViewController.tickClicked(_:)), for: .touchUpInside)
        if(item.status == 0)
        {
            cell.tickButton.setBackgroundImage(UIImage(named:"Diselect.png"), for: UIControlState())

        } else {
            cell.tickButton.setBackgroundImage(UIImage(named:"Select.png"), for: UIControlState())

        }
        
        
        return cell
    }
    
  
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
    
    //MARK Button stuff
    func tickClicked(_ sender: UIButton!)
    {
        //self.tableView.indexPathForSelectedRow
        tableView.selectRow(at: tableView.indexPathForSelectedRow, animated: true, scrollPosition: .none)
      
        tableView.reloadData()
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->CGFloat
//        {
//            return 60.0
//        }


    
    
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
    //let realm = try! Realm()
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

