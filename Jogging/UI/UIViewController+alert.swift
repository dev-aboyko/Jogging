//
//  UIViewController+alert.swift
//  Jogging
//
//  Created by Alexey Boyko on 15/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(message: String?, okHandler: ((UIAlertAction) -> Void)? = nil) {
        if self.view.window == nil {
            return
        }
        let message = message ?? "Error"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: okHandler)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
