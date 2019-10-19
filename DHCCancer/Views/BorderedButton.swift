//
//  BorderedButton.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 10. 19..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit

final class BorderedButton: UIButton {

    // MARK: - IBInspectable properties

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }

    @IBInspectable var fillColor: UIColor? = nil {
        didSet {
            self.backgroundColor = self.fillColor
        }
    }

    @IBInspectable var borderColor: UIColor? = nil {
        didSet {
            self.layer.borderColor = self.borderColor?.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
}
