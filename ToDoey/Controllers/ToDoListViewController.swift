//
//  ViewController.swift
//  ToDoey
//
//  Created by Don Gordon on 12/18/17.
//  Copyright © 2017 DGsolutions. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()

    // Get USERS File Data Path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        print(dataFilePath)
        
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
        
        loadItems()
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
            
            let newItem = Item()
            newItem.title = textField.text!
            
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
    
    // set new Array to my plist persistance
    let encoder = PropertyListEncoder()
    
    do {
        let data = try encoder.encode(itemArray)
        try data.write(to: dataFilePath!)
    } catch {
        print("Error encoding items array, \(error)")
    }
    
    self.tableView.reloadData()

    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
}

