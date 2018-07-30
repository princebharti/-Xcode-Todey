//
//  ViewController.swift
//  Todey
//
//  Created by Prince Bharti on 24/07/18.
//  Copyright © 2018 Prince Bharti. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeCellTableViewController {
    
    let realm = try! Realm()
    
    var itemResults : Results<Item>?
    var selectedCategory : Category? {
       didSet{
            loadItems()
        }
    }
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .singleLine
        searchBar.delegate = self
        tableView.rowHeight = 65.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name // to change the title in the navbar
        guard let colorHex = selectedCategory?.cellColor else {fatalError()}

        updateNavBar(withHexCode: colorHex)
        
   }
    
    override func viewWillDisappear(_ animated: Bool) {
            updateNavBar(withHexCode: "1D9BF6")
        
    }
    
    func updateNavBar(withHexCode colorHex : String){
        
        guard let navigationBar = navigationController?.navigationBar else {fatalError()}
        guard let tintColor = UIColor(hexString: (colorHex)) else {fatalError()}
        navigationBar.barTintColor = tintColor
        navigationBar.tintColor = ContrastColorOf(tintColor , returnFlat: true)
        searchBar.barTintColor = tintColor

        navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(tintColor , returnFlat: true)] // to change the title color
        
    }
    
    
    
    
    //MARK: - Table View DataSource Methds
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
       if let item = itemResults?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        
            guard let categoryCellColorHex = selectedCategory?.cellColor  else {fatalError()}
            let backgroundColor = UIColor(hexString: categoryCellColorHex)?.darken(byPercentage:CGFloat(Float(indexPath.row)/Float((itemResults?.count)!)))
            cell.backgroundColor = backgroundColor
            cell.textLabel?.textColor = ContrastColorOf(backgroundColor!, returnFlat: true)
        
        
        } else {
            cell.textLabel?.text = "No Items added"
        }
        
        return cell
   
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemResults?.count ?? 1
    }
    
    //MARK: Table view Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        do {
           try realm.write {
                itemResults?[indexPath.row].done = !(itemResults?[indexPath.row].done)!
            }
            
        } catch {
            print("there is some error while updating the realm \(error)")
        }
        tableView.reloadData()
        
//         to deslect the selected row
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

            if let currentCategory = self.selectedCategory {
               do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = text
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("error while saving new category \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
 }
    
    
    func loadItems(){
  
        itemResults = selectedCategory?.items.sorted(byKeyPath:"title", ascending: true)
        tableView.reloadData()

        }
    
    
    override func performDeletionForSwipe(indexPath: IndexPath) {
        
        if let itemForDeletion = itemResults?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                print("there is some error while deleting \(error)")
            }
       }
    }

}

//MARK: serachbar deligate methods
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    itemResults = selectedCategory?.items.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadItems()
        }
        else {
            itemResults = selectedCategory?.items.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
}


}

   


