//
//  MyProfileController.swift
//  Login
//
//  Created by SHUBHAM ASTHANA on 31/03/21.
//

import UIKit
import Firebase

class MyProfileController: UIViewController {
    let db = Firestore.firestore()

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        loadUserData()
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
    do {
      try Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
    }
    
    func loadUserData() {
        if let registerUser = Auth.auth().currentUser?.email {
            db.collection("userInfo").getDocuments { (querySnapshot, error) in
                if let e = error {
                    print("error loading data!\(e)")
                } else{
                    if let snapshotDoc = querySnapshot?.documents {
                        for i in snapshotDoc {
                            let data = i.data()
                            if  registerUser == data["sender"] as? String{
                                DispatchQueue.main.async {
                                    self.nameLabel.text = data["name"] as? String
                                    self.emailLabel.text = data["sender"] as? String
                                    self.genderLabel.text = data["gender"] as? String
                                    self.cityLabel.text = data["city"] as? String
                                    self.dobLabel.text = data["dob"] as? String
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
