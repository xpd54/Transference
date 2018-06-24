//
//  ViewController.swift
//  Transference
//
//  Created by Ravi Prakash on 6/24/18.
//  Copyright © 2018 xpd54. All rights reserved.
//

import UIKit
import FirebaseUI
class ViewController: UIViewController {
    let authUI = FUIAuth.defaultAuthUI()!
    var user = Auth.auth().currentUser
    override func viewDidLoad() {
        // Set Display name
        self.title = Label.Title

        // setup signup methods for firebase
        authUI.delegate = self
        let providers: [FUIAuthProvider] = [FUIGoogleAuth()]
        self.authUI.providers = providers

        // check if current user is still login
        if user != nil {
            self.title = user?.displayName;
        } else {
            showSignInUI()
        }

        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func showSignInUI() {
        let authViewController = authUI.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
}

extension ViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        // set user name as title
        self.title = authDataResult?.user.displayName
    }
}
