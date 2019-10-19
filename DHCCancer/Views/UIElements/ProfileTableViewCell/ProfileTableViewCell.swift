//
//  ProfileTableViewCell.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: ProfileTableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textLabel?.textColor = .white
    }
}
