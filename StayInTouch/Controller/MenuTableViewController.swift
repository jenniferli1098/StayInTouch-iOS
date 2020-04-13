//
//  MenuTableViewController.swift
//  StayInTouch
//
//  Created by Jennifer Liang on 2020-04-12.
//  Copyright © 2020 Jennifer Liang. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class MenuTableViewController: UITableViewController {

    
    var itemArray = [Person]()
       

    let dateFormatterPrint = DateFormatter()
       
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()

        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        //customize style of table view
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
           
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendReuseCell", for: indexPath)
        let row = indexPath.row
        let person = itemArray[row]
        
        
        cell.textLabel?.text = "\(person.firstName!) \(person.lastName!)"
        cell.detailTextLabel?.text = dateFormatterPrint.string(from: person.lastMet!)
        
        
        //cell.backgroundColor = UIColor(hexString: person.uiColor!)
        if let bgColor = FlatMint().darken(byPercentage: CGFloat(0.5 * Float(row)/Float(itemArray.count))){

            cell.backgroundColor = bgColor
            cell.textLabel?.textColor = ContrastColorOf(bgColor, returnFlat: true)
            cell.detailTextLabel?.textColor = ContrastColorOf(bgColor, returnFlat: true)
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuToDetails",
            let destinationVC = segue.destination as? PersonDetailsViewController,
            let rowIndex = tableView.indexPathForSelectedRow?.row
        {
            let person = itemArray[rowIndex]
            destinationVC.person = person
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    
     //MARK: - TableView Delegate Methods
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            //create a segue

            saveItems()
            
            //tableView.deselectRow(at: indexPath, animated: true)
            self.performSegue(withIdentifier: "menuToDetails", sender: self)
            
        }
        
        //MARK: - Add New Items
        
        @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            
            var fnameTextfield = UITextField()
            var lnameTextfield = UITextField()
            
            let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                //what will happen once the user clicks the Add Item button on our UIAlert
                
                
                let newPerson = Person(context: self.context)
                newPerson.firstName = fnameTextfield.text!
                newPerson.lastName = lnameTextfield.text!
                newPerson.waitTime = 30
                newPerson.lastMet = Date()
                newPerson.uiColor = UIColor.randomFlat().hexValue()
                newPerson.secondsUntilNextMeeting = Double(Double(newPerson.waitTime) * 86400.0)
                self.itemArray.append(newPerson)
                /* update thing
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                */
                
                self.saveItems()
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "First name"
                fnameTextfield = alertTextField
            }
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Last name"
                lnameTextfield = alertTextField
            }
            
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
        }
    
    //MARK: Model Manupulation Methods
    
    func saveItems() {
        
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadItems() {
        /*
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        */
        
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }

}
