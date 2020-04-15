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
    
    var rowSelected = 0
       

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Appeared")
        loadItems()
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
    

    //MARK: Adding swipe actions
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        rowSelected = indexPath.row
        
        let meet = UIContextualAction(style: .normal, title: "Just Met") { (action, view, nil) in
            print("Met up with friend")
            let person = self.itemArray[indexPath.row]
            person.lastMet = Date()
            self.updateItemArray()
        }
        meet.backgroundColor = UIColor.flatLime()
        
        let config = UISwipeActionsConfiguration(actions: [meet])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        rowSelected = indexPath.row
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            print("Deleted friend")
            let row = indexPath.row
            self.context.delete(self.itemArray[row])
            self.itemArray.remove(at: row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveItems()
            
        }
        delete.backgroundColor = UIColor.flatRed()
        let view = UIContextualAction(style: .normal, title: "View") { (action, view, nil) in
            print("View friend")
            self.performSegue(withIdentifier: "menuToDetails", sender: self)
            
        }
        //edit.backgroundColor = UIColor.flatLime()
        let config = UISwipeActionsConfiguration(actions: [delete, view])
        config.performsFirstActionWithFullSwipe = false
        
        return config
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
            itemArray.remove(at: indexPath.row)
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
            let destinationVC = segue.destination as? PersonDetailsViewController
        {
            let rowIndex = tableView.indexPathForSelectedRow?.row ?? rowSelected
            let person = itemArray[rowIndex]
            destinationVC.person = person
                // do something with the result
            
        }
        else if segue.identifier == "menuToCreate",
            let destinationVC = segue.destination as? EditPersonViewController
        {
            destinationVC.callback = { result in
                 print(result)
            }
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    
     //MARK: - TableView Delegate Methods
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //self.performSegue(withIdentifier: "menuToDetails", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
        
        //MARK: - Add New Items
        /*
        @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            
            var fnameTextfield = UITextField()
            var lnameTextfield = UITextField()
            
            let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                //what will happen once the user clicks the Add Item button on our UIAlert
                
                
                //Create new person
                let newPerson = Person(context: self.context)
                newPerson.firstName = fnameTextfield.text!
                newPerson.lastName = lnameTextfield.text!
                newPerson.waitTime = 30
                newPerson.lastMet = Date()
                newPerson.secondsUntilNextMeeting = Double(Double(newPerson.waitTime) * 86400.0)
                self.itemArray.append(newPerson)
                
                
                self.updateItemArray()
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
    */
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
        
        let sort = NSSortDescriptor(key: "secondsUntilNextMeeting", ascending: true)
        request.sortDescriptors = [sort]
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        updateItemArray()
        
        tableView.reloadData()
        
    }
    
    //MARK: Item Array Manipulation
    
    
    func updateItemArray () {
        
        for k in itemArray {
            //next meeting is last met + wait time
            let nextMeeting = k.lastMet!.addingTimeInterval(Double(k.waitTime) * 86400.0)
            let secondsToWait = nextMeeting.timeIntervalSinceNow
            k.secondsUntilNextMeeting = secondsToWait
        }
        //we are marking by when they will meet next
        itemArray.sort(by: { $0.secondsUntilNextMeeting < $1.secondsUntilNextMeeting })
        
        saveItems()
    }

}
