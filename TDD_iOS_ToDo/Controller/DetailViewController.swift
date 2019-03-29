//
//  DetailViewController.swift
//  TDD_iOS_ToDo
//
//  Created by venD-vijay on 24/03/2019.
//  Copyright © 2019 venD-vijay. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    var itemInfo : (ItemManager, Int)?
    let dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let itemDetail = itemInfo else { return }
        let item = itemDetail.0.item(at: itemDetail.1)
        self.titleLabel.text = item.title
        self.descriptionLabel.text = item.itemDescription
        self.locationLabel.text = item.location?.name
        
        if let timeStamp = item.timeStamp {
            let date = Date(timeIntervalSince1970: timeStamp)
            self.dateLabel.text = dateFormatter.string(from: date)
        }
        
        if let coordinates = item.location?.coordinates {
            let region = MKCoordinateRegionMakeWithDistance(coordinates, 100, 100)
            mapView.region = region
        }
    }
    
    func checkItem() {
        if let itemDetail = itemInfo {
           _ = itemDetail.0.checkItem(at: itemDetail.1)
        }
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
