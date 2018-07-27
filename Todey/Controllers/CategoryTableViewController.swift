//
//  CategoryTableViewController.swift
//  Todey
//
//  Created by Prince Bharti on 27/07/18.
//  Copyright © 2018 Prince Bharti. All rights reserved.
//

import UIKit
import CoreData



class CategoryTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryArray = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            let category = Category(context: self.context)
            category.name = textField?.text!
            self.categoryArray.append(category)
            self.saveCategory()
     
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
   
    
    //MARK: - Data source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name!
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    
    
    //MARK: - Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "goToItems", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
        
    }
    
    
    
    
    
    //MARK: - Data Manupulation methods
    
    func saveCategory(){
        
        do {
            try  context.save()
        } catch {
           
            print("error found while saving category using context \(error)")
        }
        
        tableView.reloadData()
  }
    
    func loadCategory(){
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("error while fetching the request \(error)")
        }
    
    }

    
}
