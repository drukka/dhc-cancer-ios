//
//  ProfileHeaderView.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit

final class ProfileHeaderView: UIView {
    @IBOutlet weak var welcomingLabel: UILabel!
    
    static let height: CGFloat = 158
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            
            self.welcomingLabel.text = "Hello, \(user.username ?? "")!"
        }
    }
}
