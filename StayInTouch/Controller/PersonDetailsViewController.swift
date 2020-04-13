//
//  PersonDetailsViewController.swift
//  StayInTouch
//
//  Created by Jennifer Liang on 2020-04-13.
//  Copyright © 2020 Jennifer Liang. All rights reserved.
//

import UIKit
import CoreData
class PersonDetailsViewController: UIViewController {

    
    var person: Person!
    
    let dateFormatterPrint = DateFormatter()
    
    @IBOutlet weak var fnameLabel: UILabel!
    @IBOutlet weak var lnameLabel: UILabel!
    @IBOutlet weak var lastMeetingLabel: UILabel!
    @IBOutlet weak var daysUntilMeetupLabel: UILabel!
    @IBOutlet weak var waitingTimeLabel: UILabel!
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"

        loadValues()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Just Met Pressed
    @IBAction func justMetPressed(_ sender: UIButton) {
        person.lastMet = Date().addingTimeInterval(100000.0)
        print(person.lastMet!)
        saveItems()
        loadValues()
    }
    
    
    //MARK: Edit Profile
    @IBAction func editPressed(_ sender: UIButton) {
        
    }
    
    //MARK: Done Pressed
    @IBAction func donePressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Load values
    func loadValues(){
        
        fnameLabel.text = person.firstName!
        lnameLabel.text = person.lastName!
        lastMeetingLabel.text = dateFormatterPrint.string(from: person.lastMet!)
        
    }
    

    //MARK: Model Manupulation Methods
    func saveItems() {
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        
    }
    
    
}
