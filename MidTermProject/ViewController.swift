//
//  ViewController.swift
//  MidTermProject
//
//  Created by Tyler Boudreau on 2018-05-02.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet var segmentController: UISegmentedControl!
    @IBOutlet var signInView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var registerView: UIView!
    
    @IBOutlet var registerEmailTextField: UITextField!
    @IBOutlet var registerPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

        registerEmailTextField.delegate = self
        registerPasswordTextField.delegate = self
        
        
        registerView.isHidden=true
        
   
    }//load

    
    
    
    
    
    
    @IBAction func segmentClicked(_ sender: UISegmentedControl) {
    
        
        switch segmentController.selectedSegmentIndex {
        case 0:
            signInView.isHidden = false
            registerView.isHidden = true
            signInView.becomeFirstResponder()
            
            
        case 1:
            signInView.isHidden = true
            registerView.isHidden = false
            signInView.resignFirstResponder()
        
        default:
            break
        }
        
    
    
    
    
    
    }//segmentClicked
    

    @IBAction func signInEmailReturn(_ sender: Any) {
        if (emailTextField.text != ""){
            passwordTextField.becomeFirstResponder()
        }
    }
    
    
    @IBAction func signInPasswordExit(_ sender: Any) {
        if (passwordTextField.text != "" && emailTextField.text != ""){
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil {
                    print(error)
                } else {
                    
                    print("login Succesful")
                    self.performSegue(withIdentifier: "goToChat", sender: self)
                }
            })//closure
            
        }////if
        
    }//signIn
    
   
    
    
    @IBAction func registerEmailReturn(_ sender: Any) {
        if (registerEmailTextField.text != ""){
            registerPasswordTextField.becomeFirstResponder()
        }
    }
    
    
    @IBAction func registerPasswordExit(_ sender: Any) {
        if (registerEmailTextField.text != "" && registerPasswordTextField.text != ""){
            Auth.auth().createUser(withEmail: registerEmailTextField.text!, password: registerPasswordTextField.text!, completion: { (user, error) in
                
                
                if error != nil {
                    print(error!)
                } else {
                    print("Registration Succesful")
                    let userDB = Database.database().reference().child("Users")
                    let userDirectory = ["User":Auth.auth().currentUser?.uid, "Name":self.registerEmailTextField.text]
                    userDB.childByAutoId().setValue(userDirectory) {
                        (error, reference) in
                        if error != nil {
                            print(error)
                        } else {
                            print("User addedd succesfully")
                            
                            self.performSegue(withIdentifier: "goToChat", sender: self)
                        }
                        
                    }
                    
                    
                    
                    
                    
                    
                }//else
                
            })
        }
        
    }//registerPasswordExit
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    
    
    
    
    
    


}//end

