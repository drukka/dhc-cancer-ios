//
//  LogTableViewCell.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit

class LogTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: LogTableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.borderColor = UIColor(named: "Roman")?.cgColor
        contentView.layer.borderWidth = 1
    }
}
