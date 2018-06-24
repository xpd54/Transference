//
//  DataController.swift
//  KavyaSangrah
//
//  Created by Ravi Prakash on 6/24/18.
//  Copyright © 2018 Ravi Prakash. All rights reserved.
//

import UIKit
import Firebase
private var ref: DatabaseReference!

class DataController: NSObject {
    static func fetchCurrentBalance(comppletion: @escaping (Float64) -> Void) {
        fetchAllPayee { (payee) in
            for user in payee {

            }
        }
    }

    static func fetchAllPayee(completion:@escaping (Array<Any>) -> Void) {
        ref = Database.database().reference()
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            //            snapshot.value
            //            completion(snapshot.children.allObjects)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
