//
//  ViewController.swift
//  ToDoey
//
//  Created by Don Gordon on 12/18/17.
//  Copyright © 2017 DGsolutions. All rights reserved.
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
    
    // Get USERS File Data Path for .plist
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    // Get USERS file for CoreData
    let coreDataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(coreDataFilePath)

        
//        let newItem = Item()
//        newItem.title = "Wash Car"
//        newItem.done = true
//        itemArray.append(newItem)
//
//        let newItem1 = Item()
//        newItem1.title = "Dry Car"
//        itemArray.append(newItem1)
//        
//        let newItem2 = Item()
//        newItem2.title = "Wax Car"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Drive Car"
//        itemArray.append(newItem3)
   
    }

    // MARK: Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // replacing terniarly operator in place of 'if' statement
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    // MARK: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You tapped cell number \(itemArray[indexPath.row]).")
        
        // set the opposite of the current .done using the "!, not" instead of using if statement
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
       saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: Add Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when the user clicks the Add Item Button on the UIAlert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItem()

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter New Item..."
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItem() {
    
    do {
        try context.save()
    } catch {
        print("Error saving context, \(error)")
    }
    
    self.tableView.reloadData()

    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPrediate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPrediate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
}

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let request : NSFetchRequest<Item> = Item.fetchRequest()

        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with: request, predicate: predicate)
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadItems()
            searchBar.resignFirstResponder()
        } else {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request, predicate: predicate)
        }
    }

}

