//
//  ViewController.swift
//  Transference
//
//  Created by Ravi Prakash on 6/24/18.
//  Copyright © 2018 xpd54. All rights reserved.
//

import UIKit
import FirebaseUI
class ViewController: UIViewController, FUIAuthDelegate {
    let authUI = FUIAuth.defaultAuthUI()!
    override func viewDidLoad() {

        // setup signup methods for firebase
        authUI.delegate = self
        let providers: [FUIAuthProvider] = [FUIGoogleAuth()]
        self.authUI.providers = providers
        let authViewController = authUI.authViewController()
        self.present(authViewController, animated: true, completion: nil)
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

