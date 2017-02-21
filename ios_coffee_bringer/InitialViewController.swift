//
//  InitialViewController.swift
//  ios_coffee_bringer
//
//  Created by Rikard Olsson on 2016-12-09.
//  Copyright © 2016 Rikard Olsson. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    
    func setDelegates() {
        self.nameTextField.delegate = self
    }
    
    func setResignResponderOnTouch() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InitialViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set delegates
        self.setDelegates()
        
        // Set respond on touch
        self.setResignResponderOnTouch()
        
        if Current.user != nil {
            self.nameTextField.text = Current.user!.name
        }
    }
    
    @IBAction func beginActionButton(_ sender: Any) {
        if validateTextField(textField: self.nameTextField) {
            self.saveUser(user: User(name: nameTextField.text!))
            
            self.dismiss(animated: true, completion: nil)
        } else {
            _ = SweetAlert().showAlert("Check your name!", subTitle: "Has to be between 2 and 20 chars.", style: .error)
        }
    }

    func validateTextField(textField: UITextField) -> Bool {
        if let text = textField.text {
            if text.characters.count >= 2 && text.characters.count <= 20 {
                return true
            }
        }
        
        return false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func saveUser(user: User) {
        Current.user = user
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(Current.user!, toFile: User.ArchiveURL.path)
        
        if !isSuccessfulSave {
            print("Couldnt save Current User...")
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
}
