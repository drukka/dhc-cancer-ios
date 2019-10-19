//
//  UIViewController+IssueAlert.swift
//  DHCCancer
//
//  Created by Levente Dimény on 2019. 05. 29..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import UIKit

extension UIViewController {
    func issueAlert(withTitle title: String?, message: String?, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "Shark")
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: completion))
        self.present(alert, animated: true)
    }
    
    func issueGenericErrorAlert(completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("An error has occurred. Please try again.", comment: ""), preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "Shark")
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: completion))
        self.present(alert, animated: true)
    }
    
}
