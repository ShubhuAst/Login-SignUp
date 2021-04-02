//
//  ViewController.swift
//  Login
//
//  Created by SHUBHAM ASTHANA on 31/03/21.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var incorrectCredMsg: UILabel!
    @IBOutlet weak var emailForLogin: UITextField!
    @IBOutlet weak var passwordForLogin: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        incorrectCredMsg.text = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if let email = emailForLogin.text, let password = passwordForLogin.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.incorrectCredMsg.text = "*Incorrect email address or password!"
                    print(e)
                } else{
                    self.incorrectCredMsg.text = ""
                    self.passwordForLogin.text = ""
                    self.emailForLogin.text = ""
                    self.performSegue(withIdentifier: "loginToGoProfile", sender: self)
                }
            }
        }
    }
}

