//
//  SignUpController.swift
//  Login
//
//  Created by SHUBHAM ASTHANA on 31/03/21.
//

import UIKit
import Firebase

class CellClass: UITableViewCell {

}

class SignUpController: UIViewController {
    let db = Firestore.firestore()

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var needInfoMsg: UILabel!
    @IBOutlet weak var btnSelectGender: UIButton!
    @IBOutlet weak var dateOfBirth: UITextField!
    
    let transparentView = UIView()
    let tableView = UITableView()
    var dataSource = [String]()
    let datePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        needInfoMsg.text = ""
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        createDatePicker()
    }
    

    @IBAction func gender(_ sender: UIButton) {
        dataSource = ["Male", "Female","Other"]
        addTransparentView(frames: sender.frame)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        if let email = emailAddress.text, let password = password.text, let userName = name.text, let userCity = city.text, let userConfirmPass = confirmPassword.text, let userGender = btnSelectGender.currentTitle, let userDOB = dateOfBirth.text{
            if userName != "", userCity != "", userConfirmPass == password, userGender != "Gender", userDOB != ""{
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        self.needInfoMsg.text = "*\(e.localizedDescription)!"
                        print(e)
                    } else {
                        if let registerUser = Auth.auth().currentUser?.email {
                            self.db.collection("userInfo").addDocument(data: ["sender": registerUser, "name": userName, "city": userCity, "gender": userGender, "dob": userDOB]) { (error) in
                                if let e = error {
                                    print("saving failed:-\(e)")
                                } else {
                                    print("saving data successed")
                                }
                            }
                        }
                        self.performSegue(withIdentifier: "signupToGoProfile", sender: self)
                    }
                }
            } else{
                if userConfirmPass != password {
                    self.needInfoMsg.text = "*Both password must be same!"
                }
                if userGender == "Gender"{
                    self.needInfoMsg.text = "*Select gender from drop down!"
                }
                else{
                    self.needInfoMsg.text = "*Need All Information to Sign Up!"
                }
            }
        }
    }
}



//MARK: - genderDropDown

extension SignUpController {

    func addTransparentView(frames: CGRect) {
             //print(frames.origin.x,frames.origin.y) //This gives wrong i.e.  0.0, 20.333
             let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
             transparentView.frame = window?.frame ?? self.view.frame
             self.view.addSubview(transparentView)
             
             tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
             self.view.addSubview(tableView)
             tableView.layer.cornerRadius = 5
             
             transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
             tableView.reloadData()
             let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
             transparentView.addGestureRecognizer(tapgesture)
             transparentView.alpha = 0
             UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                 self.transparentView.alpha = 0.5
                 self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 30))
             }, completion: nil)
         }
    
    @objc func removeTransparentView() {
        let frames = btnSelectGender.frame
             UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                 self.transparentView.alpha = 0
                 self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
             }, completion: nil)
         }
}


//MARK: - data source method

extension SignUpController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnSelectGender.setTitle(dataSource[indexPath.row], for: .normal)
        btnSelectGender.setTitleColor(.black, for: .normal)
        removeTransparentView()
    }
    
}

//MARK: - date of birth datePicker
extension SignUpController {
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        dateOfBirth.inputAccessoryView = toolbar
        
        dateOfBirth.inputView = datePicker
        
        datePicker.datePickerMode = .date
        
        datePicker.maximumDate = Date()
    }
    
    @objc func donePressed() {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        dateOfBirth.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
}
