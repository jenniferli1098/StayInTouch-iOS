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
    
    var callback : ((Person)->())?
    @IBOutlet weak var fnameTextField: UITextField!
    @IBOutlet weak var lnameTextField: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timeStepper: UIStepper!
    @IBOutlet weak var waitTimeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func addPerson(){
        //Create new person
        let newPerson = Person(context: context)
        newPerson.firstName = fnameTextField.text!
        newPerson.lastName = lnameTextField.text!
        newPerson.waitTime = 30
        newPerson.lastMet = Date()
        newPerson.secondsUntilNextMeeting = Double(Double(newPerson.waitTime) * 86400.0)
        do {
            try context.save()
            let alert = UIAlertController(title: "Person Added", message: "New profile successfully saved!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            self.present(alert, animated: true)
        } catch {
            print("error saving in edit person")
        }
        
    }

    @IBAction func donePressed(_ sender: Any) {
        addPerson()
    }
}
