//
//  CategoryViewController.swift
//  Todoey
//
//  Created by wiz on 4/4/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    var categoryArray = [Category]()
    
    //let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 60.0
        tableView.separatorStyle = .none
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name

        cell.backgroundColor = UIColor(hexString: category.color ?? "#FF11CC" )
        //UIColor.randomFlat()
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen when user clicks add button
            
        let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            self.categoryArray.append(newCategory)
            self.saveCategory()
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new Item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
        
    
    //MARK: - TableVIew Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation methods
    
    func saveCategory(with tableRoload: Bool = true){
        
        do {
            try context.save()
        }catch{
            print("error saving context \(error.localizedDescription)")
        }
        
        if tableRoload {
           self.tableView.reloadData()
        }
        
        
    }
    
    func loadCategories(){
            
           let request : NSFetchRequest<Category> = Category.fetchRequest()
            do{
                categoryArray = try context.fetch(request)
            }catch{
                print("Error Fetching data from context \(error.localizedDescription)")
            }
            tableView.reloadData()
        }
    
    //MARK: - Delete data from Swipe
    override func updateModel(at indexPath: IndexPath) {
            
        self.context.delete(self.categoryArray[indexPath.row])
        self.categoryArray.remove(at: indexPath.row)
        self.saveCategory(with: false)
    }
    

}

