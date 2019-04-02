//
//  InputViewController.swift
//  TDD_iOS_ToDo
//
//  Created by venD-vijay on 25/03/2019.
//  Copyright © 2019 venD-vijay. All rights reserved.
//

import UIKit
import CoreLocation

class InputViewController: UIViewController {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    lazy var geocoder = CLGeocoder()
    var itemManager: ItemManager?
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save() {
        guard let titleString = titleTextField.text, titleString.count > 0 else { return }
        
        let date: Date?
        if let dateString = dateTextField.text, dateString.count > 0 {
            date = dateFormatter.date(from: dateString)
        } else { date = nil }
        
        let descriptionString = descriptionTextField.text
        
        if let locationName = locationTextField.text, locationName.count > 0 {
            if let address = addressTextField.text, address.count > 0 {
                geocoder.geocodeAddressString(address) {[unowned self] (places, error) in
                    let placemark = places?.first
                    
                    let item = ToDoItem(title: titleString, itemDescription: descriptionString, timeStamp: date?.timeIntervalSince1970, location: Location(name: locationName, coordinates: placemark?.location?.coordinate))
                    
                    self.itemManager?.add(item)
                }
            }
        } else {
            let item = ToDoItem(title: titleString, itemDescription: descriptionString, timeStamp: date?.timeIntervalSince1970, location: nil)
            self.itemManager?.add(item)
        }
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
