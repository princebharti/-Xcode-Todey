//
//  ViewController.swift
//  Todey
//
//  Created by Prince Bharti on 24/07/18.
//  Copyright © 2018 Prince Bharti. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .singleLine

        let item1 = Item()
        item1.title = "item1"
        let item2 = Item()
        item2.title = "item2"
        let item3 = Item()
        item3.title = "item3"
        let item4 = Item()
        item4.title = "item4"
        itemArray.append(item1)
        itemArray.append(item2)
        itemArray.append(item3)
        itemArray.append(item4)
        
        
        if let array = defaults.object(forKey: "itemArray") as? [Item] {
                        itemArray = array
                    }

    }
    
    //MARK: - Table View DataSource Methds
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
  
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: Table view Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        // to deslect the selected row
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // action to be performed by the user when add item button is pressed
            let text = textField.text!
            
            let item = Item()
            item.title = text
            self.itemArray.append(item)
            self.defaults.set(self.itemArray, forKey: "itemArray")
            self.tableView.reloadData()
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
   
}

