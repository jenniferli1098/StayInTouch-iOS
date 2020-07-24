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
    
    
    var imagePicker: ImagePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up keyboard delegate
        fnameTextField.delegate = self
        lnameTextField.delegate = self
        //set up image picker and imageui clickable
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditPersonViewController.imageTapped(gesture:)))

        // add it to the image view;
        profilePic.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        profilePic.isUserInteractionEnabled = true
        
        
        //if it is coming from the edit field
        if let p = person, identity == "Edit" {
            fnameTextField.text = p.firstName
            lnameTextField.text = p.lastName
            waitTimeLabel.text = String(p.waitTime)
            timeStepper.value = Double(p.waitTime)
            datePicker.date = p.lastMet!
            if let img = p.profilePic  {
                profilePic.image = UIImage(data: img)
            }
            //profilePic.image = p.
            
        } else {
            timeStepper.value = 30.0
            waitTimeLabel.text = "30"
            profilePic.image = UIImage(named: "profile")
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            self.imagePicker.present(from: profilePic)
            //Here you can initiate your new ViewController

        }
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
        if let imageData = self.profilePic.image?.pngData() {
            print("imageData")
            newPerson.profilePic = imageData
        }
        
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
            var alert : UIAlertController?
            if(fnameTextField.text! == "" || lnameTextField.text! == "") {
                alert = UIAlertController(title: "Error", message: "Please enter their name", preferredStyle: .alert)
                return
            } else {
                try context.save()
                alert = UIAlertController(title: "Success", message: "Profile successfully saved!", preferredStyle: .alert)
            }
            
            alert!.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            self.present(alert!, animated: true)
        } catch {
            print("error saving in edit person")
        }
    }
}


//MARK: UITextFieldDelegate
extension EditPersonViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //when return key is pressed
        print(textField.text!)
        textField.endEditing(true)

        return true
    }
   
    func textFieldDidEndEditing(_ textField: UITextField, reason:   UITextField.DidEndEditingReason) {
        resignFirstResponder()
    }
    
}

//MARK: ImagePickerDelegate
extension EditPersonViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.profilePic.image = image
        
        
    }
}
