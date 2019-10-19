//
//  ProfileHeaderView.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit

final class ProfileHeaderView: UIView {
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet private weak var welcomingLabel: UILabel!
    
    static let height: CGFloat = 158
    
    override func draw(_ rect: CGRect) {
        profilePhotoImageView.layer.cornerRadius = 118 / 2
        profilePhotoImageView.layer.masksToBounds = true
    }
}
