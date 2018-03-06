//
//  LoginViewController.swift
//  Jogging
//
//  Created by Alexey Boyko on 06/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Keyboard notifications
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let kbSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.setBottomConstraint(kbSize.height)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.setBottomConstraint(0)
    }
    
    private func setBottomConstraint(_ constant: CGFloat) {
        NSLog("Bottom constant: \(constant)")
        bottom.constant = constant
        UIView.animate(withDuration: 0.3) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
}
