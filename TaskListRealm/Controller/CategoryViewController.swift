//
//  CategoryViewController.swift
//  TaskListRealm
//
//  Created by Alexandra on 30.06.2022.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    lazy var realm = try! Realm()
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories?.count == 0 {
            return 1
        } else {
            return categories!.count
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        if categories?.count != 0 {
            
            cell.textLabel?.text = categories?[indexPath.row].name
            cell.textLabel?.textColor = UIColor(.primary)
            tableView.separatorStyle = .singleLine
            
            return cell
        } else {
            
            cell.textLabel?.text = "Нет дел? Добавь"
            cell.textLabel?.textColor = UIColor(.gray)
            tableView.separatorStyle = .none
            
            return cell
        }
        
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categories?.count != 0 {
            performSegue(withIdentifier: "goToTasks", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TaskListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Удалить") { contextualAction, view, boolValue in
            if let categoryForDeletion = self.categories?[indexPath.row] {
                do {
                    try self.realm.write({
                        self.realm.delete(categoryForDeletion.tasks)
                        self.realm.delete(categoryForDeletion)
                    })
                } catch {
                    print("Error deleting task, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        let edit = UIContextualAction(style: .normal, title: "Изменить") { contextualAction, view, boolValue in
            var textField = UITextField()
            textField.text = self.categories?[indexPath.row].name
            
            let alert = UIAlertController(title: "Измение название категории", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Изменить", style: .default) { action in
                if textField.text != "" {
                    
                    do {
                        try self.realm.write({
                            self.categories?[indexPath.row].name = textField.text!
                        })
                    } catch {
                        print("Error editing category \(error)")
                    }
                    self.tableView.reloadData()
                    
                }
            }
            
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "Название категории"
                alertTextField.text = textField.text
                textField = alertTextField
            }
            
            alert.addAction(action)
            self.present(alert, animated: true)
        }
        edit.backgroundColor = UIColor.blue
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])
        
        return swipeActions
    }
    
    
    //MARK: - Create New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Новая категория задачек", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Добавить", style: .default) { action in
            if textField.text != "" {
                
                do {
                    try self.realm.write({
                        let newCategory = Category()
                        newCategory.name = textField.text!
                        newCategory.dateCreated = Date()
                        self.realm.add(newCategory)
                    })
                } catch {
                    print("Error saving context \(error)")
                }
                self.tableView.reloadData()
                
            }
        }
        
        
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Название категории"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
    
    //MARK: - Manipulation Data
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    

}
