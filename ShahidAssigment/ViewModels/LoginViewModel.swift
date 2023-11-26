//
//  LoginViewModel.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 24/11/2023.
//

import Foundation
import FirebaseAuth

class SignInViewModel {
    var signInSuccess: (() -> Void)?
    var signInFailed: ((String) -> Void)?

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] (result, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.signInFailed?(error.localizedDescription )
            } else {
                strongSelf.signInSuccess?()
            }
        }
    }
}
