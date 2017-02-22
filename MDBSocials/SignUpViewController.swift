//
//  SignUpViewController.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/21/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    var signUpTitle: UILabel!
    var nameTextField: TextField!
    var emailTextField: TextField!
    var userNameTextField: TextField!
    var passwordTextField: TextField!
    var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage() // set line below bar to blank
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func textFieldShouldReturn(_ textField: TextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? TextField {
            nextField.becomeFirstResponder() //advances to next text field when return is pressed
        } else {
            // no more text fields after, which means this is the last text field and therefore we should signup
            signUpClicked()
        }
        return false
    }
    
    
    func setUpUI() {
        setUpBackground()
        setUpSignUpTitle()
        setUpTextFields()
        setUpSignUpButton()
    }
    
    func setUpBackground() {
        self.setUpImage()
        self.setUpBlur()
    }
    
    func setUpSignUpTitle() {
        signUpTitle = UILabel(frame: CGRect(x: 0, y: UIScreen.main.bounds.height * 0.22, width: 100, height: 30))
        signUpTitle.text = "Sign Up"
        signUpTitle.font = UIFont(name: "SanFranciscoText-Regular", size: 35)
        signUpTitle.textColor = UIColor.white
        signUpTitle.sizeToFit()
        signUpTitle.frame.origin.x = view.frame.width / 2 - signUpTitle.frame.width / 2
        view.addSubview(signUpTitle)
    }
    
    // implement return button!!!
    func setUpTextFields() {
        setUpNameTextField()
        setUpEmailTextField()
        setUpUserNameTextField()
        setUpPasswordTextField()
        nameTextField.delegate = self
        emailTextField.delegate = self
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        UITextField.appearance().tintColor = UIColor.white
    }
    
    func setUpNameTextField() {
        nameTextField = TextField(frame: CGRect(x: view.frame.width / 2 - 125, y: signUpTitle.frame.maxY + 20, width: 250, height: 40))
        nameTextField.textColor = UIColor.white
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.white])
        nameTextField.layer.borderColor = UIColor.white.cgColor
        nameTextField.layer.borderWidth = 0.6
        nameTextField.layer.cornerRadius = 10
        nameTextField.layer.masksToBounds = true
        nameTextField.tag = 0 //used for pressing return, advances to next text field
        view.addSubview(nameTextField)
    }
    
    func setUpEmailTextField() {
        emailTextField = TextField(frame: CGRect(x: view.frame.width / 2 - 125, y: nameTextField.frame.maxY + 20, width: 250, height: 40))
        emailTextField.textColor = UIColor.white
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.white])
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.layer.borderWidth = 0.6
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.masksToBounds = true
        emailTextField.tag = 1
        view.addSubview(emailTextField)
    }
    
    func setUpUserNameTextField() {
        userNameTextField = TextField(frame: CGRect(x: view.frame.width / 2 - 125, y: emailTextField.frame.maxY + 20, width: 250, height: 40))
        userNameTextField.textColor = UIColor.white
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "Username",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.white])
        userNameTextField.layer.borderColor = UIColor.white.cgColor
        userNameTextField.layer.borderWidth = 0.6
        userNameTextField.layer.cornerRadius = 10
        userNameTextField.layer.masksToBounds = true
        userNameTextField.tag = 2
        view.addSubview(userNameTextField)
    }
    
    func setUpPasswordTextField() {
        passwordTextField = TextField(frame: CGRect(x: view.frame.width / 2 - 125, y: userNameTextField.frame.maxY + 20, width: 250, height: 40))
        passwordTextField.textColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.white])
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.borderWidth = 0.6
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.masksToBounds = true
        passwordTextField.isSecureTextEntry = true
        passwordTextField.tag = 3
        passwordTextField.returnKeyType = UIReturnKeyType.go
        passwordTextField.addTarget(self, action: #selector(signUpClicked), for: .touchUpInside)
        view.addSubview(passwordTextField)
    }
    
    func setUpSignUpButton() {
        signUpButton = UIButton(frame: CGRect(x: view.frame.width / 2 - 125, y: passwordTextField.frame.maxY + 20, width: passwordTextField.frame.width, height: 40))
        signUpButton.setTitle("Register", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "SanFranciscoText-Regular", size: 17)
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.backgroundColor = UIColor(red: 0, green: 162/255, blue: 0, alpha: 0.6)
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.masksToBounds = true
        signUpButton.addTarget(self, action: #selector(signUpClicked), for: .touchUpInside)
        view.addSubview(signUpButton)
    }
    
    func signUpClicked() {
        let email = emailTextField.text!
        let name = nameTextField.text!
        let username = userNameTextField.text!
        let password = passwordTextField.text!
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error == nil {
                let ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()?.currentUser?.uid)!)
                ref.setValue(["name": name, "email": email, "username": username])
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.nameTextField.text = ""
                self.userNameTextField.text = ""
                //                let storage = FIRStorage.storage().reference().child("profilepics/\((FIRAuth.auth()?.currentUser?.uid)!)")
                //                let metadata = FIRStorageMetadata()
                //                metadata.contentType = "image/jpeg"
                //                storage.put(profileImageData!, metadata: metadata).observe(.success) { (snapshot) in
                //                    let url = snapshot.metadata?.downloadURL()?.absoluteString
                //                    ref.setValue(["name": name, "email": email, "imageUrl": url])
                //                    //self.performSegue(withIdentifier: "toFeedFromSignup", sender: self)
                //                    self.emailTextField.text = ""
                //                    self.passwordTextField.text = ""
                //                    self.nameTextField.text = ""
                //                    self.performSegue(withIdentifier: "toFeedFromSignup", sender: self)
                //
                //                }
                let feedVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedNavigation") as! UINavigationController
                self.present(feedVC, animated: true, completion: nil)
            }
            else {
                self.displayErrorMessage(withError: error!)
            }
        })
    }
    func displayErrorMessage(withError error: Error) {
        let errorMessage = UILabel(frame: CGRect(x: 15, y: Int((navigationController?.navigationBar.frame.maxY)! + 10), width: Int(self.view.frame.width - 30), height: 40))
        let description = error.localizedDescription
        errorMessage.textColor = UIColor.white
        errorMessage.font = UIFont.systemFont(ofSize: 15)
        errorMessage.backgroundColor = UIColor(red: 255/255, green: 77/255, blue: 77/255, alpha: 1)
        errorMessage.textAlignment = .center
        errorMessage.layer.cornerRadius = 10
        errorMessage.clipsToBounds = true
        if description.contains("internal") {
            errorMessage.text = "Something is wrong. Try again."
        } else {
            errorMessage.text = description
        }
        self.view.addSubview(errorMessage)
    }

}