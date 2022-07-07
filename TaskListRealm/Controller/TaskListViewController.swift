//
//  TaskListViewController.swift
//  TaskListRealm
//
//  Created by Alexandra on 30.06.2022.
//

import UIKit
import RealmSwift

class TaskListViewController: UITableViewController {
    
    let realm = try! Realm()
    var taskList: Results<Task>?
    
    var selectedCategory: Category? {
        didSet {
            loadTasks()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if taskList?.count != 0 {
            return taskList!.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        if taskList?.count != 0 {
            cell.textLabel?.text = taskList![indexPath.row].title
            cell.textLabel?.textColor = UIColor(.primary)
            cell.accessoryType = taskList?[indexPath.row].done == true ? .checkmark : .none
            tableView.separatorStyle = .singleLine
            return cell
        } else {
            cell.textLabel?.text = "Задач нет"
            cell.textLabel?.textColor = UIColor(.gray)
            cell.accessoryType = .none
            tableView.separatorStyle = .none
            return cell
        }
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if taskList?.count != 0 {
            if taskList?[indexPath.row].done == true {
                do {
                    try realm.write {
                        taskList?[indexPath.row].done = false
                    }
                } catch {
                    print("Error saving done status, \(error)")
                }
                
            } else {
                do {
                    try realm.write {
                        taskList?[indexPath.row].done = true
                    }
                } catch {
                    print("Error saving done status, \(error)")
                }
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Удалить") { contextualAction, view, boolValue in
            if let taskForDeletion = self.taskList?[indexPath.row] {
                do {
                    try self.realm.write({
                        self.realm.delete(taskForDeletion)
                    })
                } catch {
                    print("Error deleting task, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        let edit = UIContextualAction(style: .normal, title: "Изменить") { contextualAction, view, boolValue in
            var textField = UITextField()
            textField.text = self.taskList?[indexPath.row].title
            
            let alert = UIAlertController(title: "Изменить название задачи", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Изменить задачу", style: .default) { action in
                if textField.text != "" {
                    
                    do {
                        try self.realm.write({
                            self.taskList?[indexPath.row].title = textField.text!
                        })
                    } catch {
                        print("Error editing task \(error)")
                    }
                    self.tableView.reloadData()
                    
                }
            }
            
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "Название задачи"
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

    //MARK: - Add New Task
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Добавить новую задачу", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Добавить задачу", style: .default) { action in
            if textField.text != "" {
                
                if let currentCategory = self.selectedCategory {
                    
                    do {
                        try self.realm.write({
                            let newTask = Task()
                            newTask.title = textField.text!
                            newTask.done = false
                            newTask.dateCreated = Date()
                            currentCategory.tasks.append(newTask)
                            self.realm.add(newTask)
                        })
                    } catch {
                        print("Error saving new task \(error)")
                    }
                    
                    self.tableView.reloadData()
                }
            }
                
        }
        
        
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Название задачи"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func loadTasks() {
        taskList = selectedCategory?.tasks.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
}
