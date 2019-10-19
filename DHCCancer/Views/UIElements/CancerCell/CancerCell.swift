//
//  CancerCell.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit

final class CancerCell: UITableViewCell {

    var cancer: String? {
        didSet {
            self.textLabel?.text = self.cancer
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        self.accessoryType = selected ? .checkmark : .none
    }

}
