//
//  ItemCell.swift
//  TDD_iOS_ToDo
//
//  Created by venD-vijay on 18/03/2019.
//  Copyright © 2019 venD-vijay. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    lazy var dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configCell(with item: ToDoItem, checked: Bool = false) {
        if checked {
            let attributedString = NSAttributedString(string: item.title, attributes: [NSAttributedStringKey.strikethroughStyle : NSUnderlineStyle.styleSingle.rawValue])
            
            titleLabel.attributedText = attributedString
            dateLabel.text = nil
            locationLabel.text = nil
        } else {
            titleLabel.text = item.title
            locationLabel.text = item.location?.name ?? ""
            if let timeStamp = item.timeStamp {
            let date = Date(timeIntervalSince1970: timeStamp)
            dateLabel.text = dateFormatter.string(from: date)
            }
        }
    }
}
