//
//  SignInViewController.swift
//  SocialHub
//
//  Created by GLB-312-PC on 13/03/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView
import ProgressHUD
import Quickblox
class SignInViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var passwardtextField: UITextField!
    @IBOutlet weak var emailtextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeUi()
      
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            
//            QuickblocxManager.shareinstance.createnewQuickblocksUser(Quserlogin: (Auth.auth().currentUser?.uid)!, QuserPassword: (Auth.auth().currentUser?.uid)!)
            self.performSegue(withIdentifier: "SignInVCtoTabbarSegueID", sender: nil)
        }
        
    }
    

    func customizeUi(){

        emailtextField.customizeTextfield()
        let bottomemailLayer = CALayer()
        bottomemailLayer.backgroundColor = UIColor.darkGray.cgColor
        bottomemailLayer.frame = CGRect(x: 0, y: 43, width: UIScreen.main.bounds.width - 40, height: 0.9)
        emailtextField.layer.addSublayer(bottomemailLayer)
        emailtextField.delegate = self
        passwardtextField.customizeTextfield()
        let bottompasswordLayer = CALayer()
        bottompasswordLayer.backgroundColor = UIColor.darkGray.cgColor
        bottompasswordLayer.frame = CGRect(x: 0, y: 43, width: UIScreen.main.bounds.width - 40, height: 0.9)
        passwardtextField.layer.addSublayer(bottompasswordLayer)
        passwardtextField.delegate = self
        emailtextField.addTarget(self, action: #selector(textfieldChanged), for: .editingChanged)
        passwardtextField.addTarget(self, action: #selector(textfieldChanged), for: .editingChanged)
        signInButton.isEnabled = false
        self.activityIndicatorView.color = UIColor.white
        self.activityIndicatorView.type = NVActivityIndicatorType(rawValue: 29)!
      
    }
    
   
    
    @objc func textfieldChanged(){
        
        guard  let email = emailtextField.text, !email.isEmpty ,let password = passwardtextField.text ,!password.isEmpty
        else {
            signInButton.setTitleColor(UIColor.darkGray, for: .normal)
            signInButton.isEnabled = false
            return
        }
        signInButton.setTitleColor(UIColor.white, for: .normal)
        signInButton.isEnabled = true
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
         view.endEditing(true)
            self.activityIndicatorView.startAnimating()
        AuthProvider.shareinstance.signIn(email: emailtextField.text!, password: passwardtextField.text!, onSuccessCallback: {
               self.emailtextField.text = ""
               self.passwardtextField.text = ""
               self.activityIndicatorView.stopAnimating()
            ProgressHUD.showSuccess("Login Successful")
            
//             QuickblocxManager.shareinstance.createnewQuickblocksUser(Quserlogin: (Auth.auth().currentUser?.uid)!, QuserPassword: (Auth.auth().currentUser?.uid)!)
            self.performSegue(withIdentifier: "SignInVCtoTabbarSegueID", sender: nil)
        }) { (error) in
             self.activityIndicatorView.stopAnimating()
            print(error!)
            ProgressHUD.showError("\(error!)")
        }
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.emailtextField.resignFirstResponder()
        self.passwardtextField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }
    
}
