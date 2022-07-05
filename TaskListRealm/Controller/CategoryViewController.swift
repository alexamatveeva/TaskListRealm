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
            
            cell.textLabel?.text = "Категорий дел пока нет"
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
    
    //MARK: - Create New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Добавить новую категорию задачек", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Добавить категорию", style: .default) { action in
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
