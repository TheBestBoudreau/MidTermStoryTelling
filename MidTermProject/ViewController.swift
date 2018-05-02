//
//  ViewController.swift
//  MidTermProject
//
//  Created by Tyler Boudreau on 2018-05-02.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet var segmentController: UISegmentedControl!
    @IBOutlet var signInView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var registerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        emailTextField.delegate = self
        emailTextField.delegate = self
        
        showView ()
    }//load

    
    
    
    
    
    
    @IBAction func segmentClicked(_ sender: UISegmentedControl) {
    
        
        switch segmentController.selectedSegmentIndex {
        case 0:
            signInView.isHidden = false
            registerView.isHidden = true
//            signInView.becomeFirstResponder()
            print("A")
            
        case 1:
            signInView.isHidden = true
            registerView.isHidden = false
            print("B")
        
        default:
            break
        }
        
    
    
    
    
    
    }//segmentClicked
    
    
    
    func showView () {
        
        switch segmentController.selectedSegmentIndex {
        case 0:
            signInView.isHidden = false
            registerView.isHidden = true
            signInView.becomeFirstResponder()
            print("A")
        
        case 1:
            signInView.isHidden = true
            registerView.isHidden = false
            print("B")
        default:
            break
        }
        
        
       
        
    }//showView
    
    
    
    
    
    
    
    
    
    


}//end

