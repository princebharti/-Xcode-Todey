//
//  CategoryTableViewController.swift
//  Todey
//
//  Created by Prince Bharti on 27/07/18.
//  Copyright © 2018 Prince Bharti. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift




class CategoryTableViewController: SwipeCellTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 65.0
        loadCategory()
        
        
  }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField : UITextField?
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        alert.addTextField { (textFieldPassed ) in
            textField = textFieldPassed
      }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //action to be performed by the addButton
            let category = Category()
            category.name = (textField?.text)!
            self.saveCategory(category: category)
     
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
   
    
    //MARK: - Data source Methods
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Category is added"
        
        return cell
}
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    
    //MARK: - Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "goToItems", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
 
    //MARK: - Data Manupulation methods
    
    func saveCategory(category : Category){
        // writing to the realim database
        
        do {
            try  realm.write {
                realm.add(category)
            }
        } catch {
           print("error found while saving category using realm \(error)")
        }
        
        tableView.reloadData()
  }
    
    func loadCategory(){
        // reading from the realm database
        categoryArray = realm.objects(Category.self)
    }

    
    override func performDeletionForSwipe(indexPath: IndexPath) {
        //action to be performed for deletion

        do {
            try self.realm.write {
                if let category = self.categoryArray?[indexPath.row] {
                    self.realm.delete(category.items)
                    self.realm.delete(category)
                }
            }

        } catch {
            print("there is some error while deleting the cell using realm \(error)")
        }
    }
    
}












