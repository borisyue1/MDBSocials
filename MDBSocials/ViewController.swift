//
//  ViewController.swift
//  MDBSocials
//
//  Created by Boris Yue on 2/20/17.
//  Copyright © 2017 Boris Yue. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {

    var loginTitle: UILabel!
    var emailTextField: TextField!
    var passwordTextField: TextField!
    var loginButton: UIButton!
    var signUpButton: UIButton!
    var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder() //advances to next text field when return is pressed
        } else {
            // no more text fields after, which means this is the last text field and therefore we should signup
            loginClicked()
        }
        return false
    }
    
    
    func setUpUI() {
        setUpBackground()
        setUpLoginTitle()
        setUpTextFields()
        setUpLoginButton()
        setUpSignUpButton()
    }
    
    func setUpBackground() {
        self.setUpImage()
        self.setUpBlur()
    }
    
    
    func setUpLoginTitle() {
        loginTitle = UILabel(frame: CGRect(x: 0, y: UIScreen.main.bounds.height * 0.25, width: 100, height: 30))
        loginTitle.text = "Sign In"
        loginTitle.font = UIFont(name: "SanFranciscoText-Regular", size: 35)
        loginTitle.font = UIFont.boldSystemFont(ofSize: 35)
        loginTitle.textColor = UIColor.white
        loginTitle.sizeToFit()
        loginTitle.frame.origin.x = view.frame.width / 2 - loginTitle.frame.width / 2
        view.addSubview(loginTitle)
    }
    
    // implement return button!!!
    func setUpTextFields() {
        setUpemailTextField()
        setUpPasswordTextField()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        UITextField.appearance().tintColor = UIColor.white
    }
    
    
    func setUpemailTextField() {
        emailTextField = TextField(frame: CGRect(x: view.frame.width / 2 - 125, y: loginTitle.frame.maxY + 20, width: 250, height: Constants.textFieldHeight))
        emailTextField.textColor = UIColor.white
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.layer.masksToBounds = true
        emailTextField.tag = 0
        emailTextField.borderStyle = .none
        emailTextField.createBottomBorder()
        view.addSubview(emailTextField)
    }
    
    func setUpPasswordTextField() {
        passwordTextField = TextField(frame: CGRect(x: view.frame.width / 2 - 125, y: emailTextField.frame.maxY + 20, width: 250, height: 40))
        passwordTextField.textColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.white])
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.masksToBounds = true
        passwordTextField.isSecureTextEntry = true
        passwordTextField.tag = 1
        passwordTextField.returnKeyType = UIReturnKeyType.go
        passwordTextField.addTarget(self, action: #selector(loginClicked), for: .touchUpInside)
        passwordTextField.createBottomBorder()
        view.addSubview(passwordTextField)
    }
    
    func setUpLoginButton() {
        loginButton = UIButton(frame: CGRect(x: view.frame.width / 2 - 125, y: passwordTextField.frame.maxY + 20, width: passwordTextField.frame.width, height: Constants.textFieldHeight))
        loginButton.setTitle("Sign In", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "SanFranciscoText-Regular", size: 17)
        loginButton.setTitleColor(Constants.blueColor, for: .normal)
        loginButton.backgroundColor = UIColor.white
        loginButton.layer.cornerRadius = Constants.signInCornerRadius
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: #selector(loginClicked), for: .touchUpInside)
        view.addSubview(loginButton)
    }
    
    func loginClicked() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        createLoader()
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error == nil {
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.loader.removeFromSuperview()
                let feedVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedNavigation") as! UINavigationController
                self.show(feedVC, sender: nil)
            }
            else {
                self.displayErrorMessage(withError: error!)
                self.loader.removeFromSuperview()
                
            }
        })
        
    }
    
    func displayErrorMessage(withError error: Error) {
        let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
    }
    
    func setUpSignUpButton() {
        signUpButton = UIButton(frame: CGRect(x: view.frame.width / 2, y: loginButton.frame.maxY + 10, width: 60, height: Constants.textFieldHeight))
        signUpButton.setTitle("Create An Account", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "SanFranciscoText-Regular", size: 17)
        signUpButton.sizeToFit()
        signUpButton.frame.origin.x = view.frame.width / 2 - signUpButton.frame.width / 2
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpClicked), for: .touchUpInside)
        view.addSubview(signUpButton)
    }
    
    func signUpClicked() {
        performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    
    func createLoader() {
        loader = UIActivityIndicatorView(frame: CGRect(x: view.frame.width / 2 - 15, y: signUpButton.frame.maxY + 10, width: 40, height: Constants.textFieldHeight))
        loader.startAnimating()
        loader.tintColor = UIColor.white
        view.addSubview(loader)
    }
}

extension UIViewController {
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setUpImage() {
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        backgroundImage.image = #imageLiteral(resourceName: "background")
        view.addSubview(backgroundImage)
    }
    
    func setUpBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
}

