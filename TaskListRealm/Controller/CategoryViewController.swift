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
        
        tableView.separatorStyle = .none
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
        
        
        if categories?.count == 0 {
            
            cell.textLabel?.text = "Категорий дел пока нет"
            cell.textLabel?.textColor = UIColor(.gray)
            
            return cell
        } else {
            
            cell.textLabel?.text = categories?[indexPath.row].name
            
            return cell
        }
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Добавить новую категорию задачек", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Добавить категорию", style: .default) { action in
            if textField.text != nil {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.dateCreated = Date()
                
                self.save(category: newCategory)
            }
        }
        
        
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Название категории"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(category: Category) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    

}
