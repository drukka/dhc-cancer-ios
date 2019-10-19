//
//  UIViewController+handleError(_error).swift
//  Servee
//
//  Created by Levente Dimény on 2019. 05. 28..
//  Copyright © 2019. Drukka digitals. All rights reserved.
//

import UIKit

extension UIViewController {
    func handleError(_ error: NetworkingError) {
        self.issueAlert(withTitle: NSLocalizedString("Error", comment: ""), message: error.localizedDescription)
    }
    
    func handleError(_ error: Error) {
        self.issueAlert(withTitle: NSLocalizedString("Error", comment: ""), message: error.localizedDescription)
    }
}
