//
//  SignupViewController.swift
//  SocialHub
//
//  Created by GLB-312-PC on 13/03/18.
//  Copyright © 2018 GLB-312-PC. All rights reserved.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView
import ProgressHUD
import  Photos
class SignupViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var profilePicImageview: UIImageView!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
   
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    var seletedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeUI()
     
    }

    
    func customizeUI(){
        
        nameTextField.customizeTextfield()
        let bottomnameLayer = CALayer()
        bottomnameLayer.backgroundColor = UIColor.darkGray.cgColor
        bottomnameLayer.frame = CGRect(x: 0, y: 43, width: UIScreen.main.bounds.width - 40, height: 0.9)
        nameTextField.layer.addSublayer(bottomnameLayer)
        nameTextField.delegate = self
        
        emailTextField.customizeTextfield()
        let bottomemailLayer = CALayer()
        bottomemailLayer.backgroundColor = UIColor.darkGray.cgColor
        bottomemailLayer.frame = CGRect(x: 0, y: 43, width: UIScreen.main.bounds.width - 40, height: 0.9)
        emailTextField.layer.addSublayer(bottomemailLayer)
        emailTextField.delegate = self
        
        passwordTextfield.customizeTextfield()
        let bottompasswordLayer = CALayer()
        bottompasswordLayer.backgroundColor = UIColor.darkGray.cgColor
        bottompasswordLayer.frame = CGRect(x: 0, y: 43, width: UIScreen.main.bounds.width - 40, height: 0.9)
        passwordTextfield.layer.addSublayer(bottompasswordLayer)
        passwordTextfield.delegate = self
        
        profilePicImageview.clipsToBounds = true
        profilePicImageview.layer.cornerRadius = 35
        profilePicImageview.isUserInteractionEnabled = true
        
        let profiletap = UITapGestureRecognizer(target: self, action:#selector(handleprofilePicSelectAction))
        profilePicImageview.addGestureRecognizer(profiletap)
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        signupButton.isEnabled = false
        self.activityIndicatorView.color = UIColor.white
        self.activityIndicatorView.type = NVActivityIndicatorType(rawValue: 29)!
      
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        print("touch")
    }
    
  
    @objc func textFieldDidChange(){
        guard let username = nameTextField.text , !username.isEmpty,let email = emailTextField.text,!email.isEmpty,let password = passwordTextfield.text ,!password.isEmpty
        else {
            signupButton.setTitleColor(UIColor.darkGray, for: .normal)
            signupButton.isEnabled = false
            return
           }
        signupButton.setTitleColor(UIColor.white, for: .normal)
        signupButton.isEnabled = true
    }
    @objc func handleprofilePicSelectAction(){
        
      
        
        let status = PHPhotoLibrary.authorizationStatus()
        print("\(status)")
        
        if (status == PHAuthorizationStatus.authorized) {
           self.openimagepickerGallery()
        }
            
        else if (status == PHAuthorizationStatus.denied) {
          self.showerrormessageonGalleryopenRequest()
        }
            
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                   
                    self.openimagepickerGallery()
                }
                else {
                    
                    self.showerrormessageonGalleryopenRequest()
                }
            })
        }
            
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
        }

    }
    
    
    func openimagepickerGallery(){
        let pickerController  = UIImagePickerController()
        pickerController.delegate = self
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func showerrormessageonGalleryopenRequest(){
        
        let alert =  UIAlertController(title: "Access denied", message: "Sorry,user denied to access their photos,your photos won't be shared without your permission!!Please go to setting and give permission to access your photos to use our app", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go To settings", style: .default) { action in
            
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
            
        })
        alert.addAction(UIAlertAction(title: ":Cancle", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    @IBAction func signupAction(_ sender: Any) {
        view.endEditing(true)
        if let profileImage = self.seletedImage ,let imagedata = UIImageJPEGRepresentation(profileImage, 0.1) {
            
            self.activityIndicatorView.startAnimating()
       
        AuthProvider.shareinstance.signUp(username: self.nameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextfield.text!, imageData: imagedata, onSuccessCallback: {
            
                self.nameTextField.text = ""
                self.passwordTextfield.text = ""
                self.emailTextField.text = ""
                self.profilePicImageview.image = UIImage(named: "user")
            self.seletedImage = nil
               self.activityIndicatorView.stopAnimating()
               self.performSegue(withIdentifier: "SignupToTabBarVCSegueID", sender: nil)
        }, onerrorCallback: { (error) in
            self.activityIndicatorView.stopAnimating()
            let alert =  UIAlertController(title: "New user creationfailed", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default) { action in
            })
            self.present(alert, animated: true, completion: nil)
        })
            
          
        }

        else {
            ProgressHUD.showError("Profile Image can't be empty")
        }
}
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.emailTextField.resignFirstResponder()
        self.passwordTextfield.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
        return true
    }
        
    //MARK: Alredy registred Sign in Action
    @IBAction func signInAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
 
}

extension SignupViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("\(info)")
  if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage{
         self.profilePicImageview.image = pic
         self.seletedImage = pic
        }
        dismiss(animated: true, completion: nil)
    }
    
    
}
