//
//  LoginVc.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 24/11/2023.
//

import UIKit

class SignInVc: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        viewModel.signInSuccess = { [weak self] in
            guard let strongSelf = self else { return }
            let newViewController = HomeVc.loadFromNib()
            strongSelf.navigationController?.pushViewController(newViewController, animated: true)
        }
        
        viewModel.signInFailed = { [weak self] error in
            guard let strongSelf = self else { return }
            AlertManager.showAlert(in: strongSelf, title: "Sign in Failed", message: error.description)
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            viewModel.signIn(email: email, password: password)
        }
    }
}
