//
//  SignUpViewModel.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 24/11/2023.
//

import Foundation
import FirebaseAuth

class SignUpViewModel {
    
    var signUpSuccess: (() -> Void)?
    var signUpFailed: ((String) -> Void)?
    
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] (result, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.signUpFailed?(error.localizedDescription)
            } else {
                strongSelf.signUpSuccess?()
            }
        }
    }
}
