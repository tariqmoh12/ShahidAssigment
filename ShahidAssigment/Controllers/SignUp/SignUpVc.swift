//
//  TestViewController.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 24/11/2023.
//

import UIKit

class SignUpVc: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    private let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        viewModel.signUpSuccess = { [weak self] in
            guard let strongSelf = self else { return }
            let newViewController = SignInVc.loadFromNib()
            strongSelf.navigationController?.pushViewController(newViewController, animated: true)
        }
        
        viewModel.signUpFailed = { [weak self] error in
            guard let strongSelf = self else { return }
            AlertManager.showAlert(in: strongSelf, title: "Sign Up Failed", message: error)
        }
    }

    @IBAction func signUpTapped(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            viewModel.signUp(email: email, password: password)
        }
    }
    @IBAction func goToSignInTapped(_ sender: Any) {
        let newViewController = SignInVc.loadFromNib()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}
