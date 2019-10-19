//
//  LogTableViewCell.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit

class LogTableViewCell: UITableViewCell {
    @IBOutlet weak var entryPhotoImageView: UIImageView!
    @IBOutlet weak var entryNameLabel: UILabel!
    @IBOutlet weak var entryUnitTypeLabel: UILabel!
    @IBOutlet weak var entryDateLabel: UILabel!
    
    static let reuseIdentifier = String(describing: LogTableViewCell.self)
    
    var entry: Entry? {
        didSet {
            guard let entry = entry else { return }
            
            entryPhotoImageView.image = UIImage(named: entry.type.rawValue)
            entryNameLabel.text = entry.type.rawValue
            entryDateLabel.text = DateFormatter.sharedDateFormatter.string(from: entry.time ?? Date())
            
            
            if entry.type == .temperature {
                entryUnitTypeLabel.text = "\(entry.temperature ?? 0) °C"
            } else if entry.type == .weight {
                entryUnitTypeLabel.text = "\(entry.weight ?? 0) kg"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.borderColor = UIColor(named: "Roman")?.cgColor
        contentView.layer.borderWidth = 1
    }
}

extension DateFormatter {

    static var sharedDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        // Add your formatter configuration here
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
}
