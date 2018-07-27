//
//  ViewController.swift
//  Todey
//
//  Created by Prince Bharti on 24/07/18.
//  Copyright © 2018 Prince Bharti. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
       didSet{
            loadItems()
        }
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .singleLine
        searchBar.delegate = self
        
        
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
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
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
            
            let item = Item(context: self.context)
            item.title = text
            item.done = false
            item.parentCategory = self.selectedCategory
            self.itemArray.append(item)
            
            self.saveItems()

      }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveItems(){
        
        do{
          try  context.save()
        }catch {
            print("Error wile saving into the context: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
        request.predicate = predicate
        
        if let requestedPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [requestedPredicate,categoryPredicate])
            
        } else {
            
            request.predicate = categoryPredicate
        }
        
     
        do{
                itemArray = try context.fetch(request)
                
            } catch {
                print("error while fetching from the context",error)
            }
        tableView.reloadData()
        
        }
    
}

//MARK: serachbar deligate methods
extension ToDoListViewController: UISearchBarDelegate {
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadItems()
        }
        else {
            
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadItems(with: request, predicate: predicate)

        }
 
    }
    
   
}
    
   


