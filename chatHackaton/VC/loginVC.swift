//
//  loginVC.swift
//  chatHackaton
//
//  Created by Damian on 23.03.2018.
//  Copyright © 2018 Damian. All rights reserved.
//

import UIKit
import Firebase

class loginVC: UIViewController {
    
    @IBOutlet weak var loginTxtField: UITextField!
    @IBOutlet weak var loginStackView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        setUpStackView()
    }
    
    func setUpStackView() {
        loginStackView.layer.cornerRadius = 10
        loginStackView.backgroundColor?.withAlphaComponent(0.2)
    }

    @IBAction func login(_ sender: Any) {
        if loginTxtField.text != "" {
            Auth.auth().signInAnonymously(completion: { user, error in
                if error == nil {
                    self.performSegue(withIdentifier: "chatListVC", sender: nil)
                } else {
                    print(error?.localizedDescription)
                    return
                }
            })
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let navVc = segue.destination as! UINavigationController
        let channelVC = navVc.viewControllers.first as! chatListVC
        
        channelVC.senderLogin = loginTxtField?.text
    }
    
}
