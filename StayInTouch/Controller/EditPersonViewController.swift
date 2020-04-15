//
//  EditPersonViewController.swift
//  StayInTouch
//
//  Created by Jennifer Liang on 2020-04-14.
//  Copyright © 2020 Jennifer Liang. All rights reserved.
//

import UIKit
import CoreData
class EditPersonViewController: UIViewController {

    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var person: Person?
    
    var identity: String = "Create"
    
    var callback : ((Person)->())?
    
    @IBOutlet weak var fnameTextField: UITextField!
    @IBOutlet weak var lnameTextField: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timeStepper: UIStepper!
    @IBOutlet weak var waitTimeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if it is coming from the edit field
        if let p = person, identity == "Edit" {
            fnameTextField.text = p.firstName
            lnameTextField.text = p.lastName
            waitTimeLabel.text = String(p.waitTime)
            timeStepper.value = Double(p.waitTime)
            datePicker.date = p.lastMet!
            
        } else {
            timeStepper.value = 30.0
            waitTimeLabel.text = "30"
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        waitTimeLabel.text = "\(Int(sender.value))"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addPerson(){
        //Create new person
        let newPerson = Person(context: context)
        newPerson.firstName = fnameTextField.text!
        newPerson.lastName = lnameTextField.text!
        newPerson.waitTime = Int16(timeStepper.value)
        newPerson.lastMet = datePicker.date
        newPerson.secondsUntilNextMeeting = 0.0 // it might not be necessary since it is reloaded every time in the tableview Double(Double(newPerson.waitTime) * 86400.0)
        
        
    }
    
    func editPerson(){
        person!.firstName = fnameTextField.text!
        person!.lastName = lnameTextField.text!
        person!.waitTime = Int16(timeStepper.value)
        person!.lastMet = datePicker.date
        
    }
    @IBAction func donePressed(_ sender: Any) {
        if identity == "Create" {
            addPerson()
        } else {
            editPerson()
            //callback?(person!)
        }
        do {
            try context.save()
            let alert = UIAlertController(title: "Person Added", message: "New profile successfully saved!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            self.present(alert, animated: true)
        } catch {
            print("error saving in edit person")
        }
    }
}
