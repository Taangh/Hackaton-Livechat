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
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTxtField.autocorrectionType = .no
        loginBtn.layer.cornerRadius = 6
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
        } else {
            let animation = CABasicAnimation(keyPath : "position")
            animation.duration = 0.07
            animation.repeatCount = 2
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.loginTxtField.center.x - 10, y: self.loginTxtField.center.y))
            
            self.loginTxtField.layer.add(animation, forKey: "position")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let navVc = segue.destination as! UINavigationController
        let channelVC = navVc.viewControllers.first as! chatListVC
        
        channelVC.senderLogin = loginTxtField?.text
    }
    
}
