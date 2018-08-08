//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Akuoma Cyril-Obi on 29/07/2018.
//  Copyright © 2018 Akuoma Cyril-Obi. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    var categories : Results<Category>?
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()                
        
        loadCategories()
        
    }
    
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1                // Nil Coalescing Operator
    }
    
    //Note: the code above means "if the value of 'categories' is not nil, return its count, ie. the number of 'categories' we have; but if its value is nil, return only 1"
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    // Note: the code above means, "If the value of 'categories' is not nil, then we get the item at the indexPath.row, taking its 'name' property, and displaying it; but if it is nil, then the text should be set to the default string value above"
    
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // what will happen once the user clicks the Add button on our UIAlert
            
            if textField.text == "" {
                DispatchQueue.main.async {
                    textField.resignFirstResponder()
                }
            } else {
                let newCategory = Category()
                
                newCategory.name = textField.text!
                
                self.save(category: newCategory)
            }
        }
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    // MARK: - Delete Data From Swipe Gesture
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryToDelete = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryToDelete.items)            //deleting it's child items first
                    realm.delete(categoryToDelete)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    //Note: the above overrides the updateModel function in our SwipeTableViewController superclass, thereby taking care of deleting our data from Realm when the user presses the delete button after swiping.
    
}













