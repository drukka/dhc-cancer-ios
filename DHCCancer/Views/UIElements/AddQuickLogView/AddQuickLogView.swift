//
//  AddQuickLogView.swift
//  DHCCancer
//
//  Created by Németh Barna on 2019. 10. 20..
//  Copyright © 2019. Drukka Digitals. All rights reserved.
//

import UIKit

class AddQuickLogView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var logDataButton: UIButton!
    
    var entryType: EntryType = .temperature {
        didSet {
            switch self.entryType {
            case .temperature:
                self.valueLabel.text = "\(stepper.value) °C"
            case .weight:
                self.valueLabel.text = "\(stepper.value) kg"
            default:
                break
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 37.0
        self.clipsToBounds = true
    }
    
    @IBAction private func stepperChanged(_ sender: UIStepper) {
        switch self.entryType {
        case .temperature:
            self.valueLabel.text = "\(stepper.value) °C"
        case .weight:
            self.valueLabel.text = "\(stepper.value) kg"
        default:
            break
        }
    }

}
