//
//  MyInformationTableViewCell.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit

class MyInformationTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: MyInformationTableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textLabel?.textColor = .white
        detailTextLabel?.textColor = .white
    }
}
