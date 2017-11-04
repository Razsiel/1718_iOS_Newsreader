//
//  LoginViewController.swift
//  Newsreader_560825
//
//  Created by Geoffrey Arkenbout on 11/2/17.
//  Copyright © 2017 Geoffrey Arkenbout. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    weak var modalListener: IModalListener?
    
    private var task: URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // click handler for the login button
    @IBAction func onLoginClicked() {
        // validation
        let username = usernameInput?.text
        let password = passwordInput?.text
        if username == nil || password == nil {
            return;
        }
        
        // call to service layer
        self.task = authenticationService.login(withUsername: username!,
                                    password: password!,
                                    onSucces: closeModalAndReloadParent,
                                    onFailure: onLoginFailed)
    }
    
    @IBAction func closeModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func closeModalAndReloadParent() {
        // succes!
        // dismiss this view and reload parent
        closeModal(self)
        modalListener?.onModalSucces()
    }
    
    private func onLoginFailed() {
        // failed to login...
        print("something went wrong")
    }

}
