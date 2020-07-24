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
    
    @IBOutlet weak var profilePic: UIImageView!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadValues(with: person)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detailsToEdit",
            let destinationVC = segue.destination as? EditPersonViewController
        {
            destinationVC.person = person
            destinationVC.identity = "Edit"
            destinationVC.callback = { updatedPerson in
                print(updatedPerson)
                self.person = updatedPerson
                //self.loadValues(with: updatedPerson)
            }
        }
    }
    
    
    @IBAction func justMet(_ sender: UIButton) {
        person.lastMet = Date()
        loadValues(with: person)
    }
    
    //MARK: Edit Profile
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "detailsToEdit", sender: self)
        
    }
    
    //MARK: Load values
    func loadValues(with person: Person){
        fnameLabel.text = person.firstName!
        lnameLabel.text = person.lastName!
        lastMeetingLabel.text = dateFormatterPrint.string(from: person.lastMet!)
        

        let nextMeeting = person.lastMet!.addingTimeInterval(Double(person.waitTime) * 86400.0)
        let daysToWait = Int16(nextMeeting.timeIntervalSinceNow / 86400.0)
        daysUntilMeetupLabel.text = String(daysToWait)
        
        waitingTimeLabel.text = String(person.waitTime)
        
        if let img = person.profilePic  {
            self.profilePic.image = UIImage(data: img)
        }
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
