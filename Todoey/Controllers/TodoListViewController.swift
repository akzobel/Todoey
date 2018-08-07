//
//  ViewController.swift
//  Todoey
//
//  Created by Akuoma Cyril-Obi on 08/07/2018.
//  Copyright © 2018 Akuoma Cyril-Obi. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()                
        
    }

    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done == true ? .checkmark : .none
            
        } else {
            
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    /***************************************
    
    A ternary operator is a shorter way of condensing code. See ternary operator guide code below, as used in the cellForRowAt indexPath method above.
     
     value = condition ? valueIfTrue : valueIfFalse
     
     if item.done == true {
     cell.accessoryType = .checkmark
     } else {
     cell.accessoryType = .none
     }
     
     BECOMES SHORTENED AS
     
    cell.accessoryType = item.done == true ? .checkmark : .none
     
   *****************************************/
    
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(todoItems[indexPath.row])
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            if textField.text == "" {
                DispatchQueue.main.async {
                    textField.resignFirstResponder()
                }
            } else {
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            
                            newItem.title = textField.text!
                            
                            newItem.dateCreated = Date()
                            
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving new items, \(error)")
                    }
                }
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "Create new item"            
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Model Manipulation Methods
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }

}


// MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        if searchBar.text == "" || searchBar.text == nil {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        }
        tableView.reloadData()
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}









//[cd] in NSPredicate code in searchBar means case and diacritic insensitive. Refer to NSPredicate cheat sheet.
