//
//  SecondViewController.swift
//  Radius
//
//  Created by Elijah Harmon on 7/30/18.
//  Copyright © 2018 Rainy Vibes. All rights reserved.
//

import AWSCore
import AWSPinpoint
import UIKit
import AWSAuthCore
import AWSAuthUI
import AWSMobileClient
import AWSUserPoolsSignIn


class SecondViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!

    @IBAction func signOutButton(_ sender: Any) {
        if (AWSSignInManager.sharedInstance().isLoggedIn) {
            AWSSignInManager.sharedInstance().logout(completionHandler: {(result: Any?, error: Error?) in
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "loggedOut")
                self.present(controller, animated: true, completion: nil)            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            //            presentAuthUIViewController()
        }

        let userFromPool = AWSCognitoUserPoolsSignInProvider.sharedInstance().getUserPool().currentUser()

        usernameLabel.text = userFromPool?.username
        
        userFromPool?.getDetails().continueOnSuccessWith(block: { (task) -> Any? in
            DispatchQueue.main.async {
                
                if let error = task.error as NSError? {
                    print("Error getting user attributes from Cognito: \(error)")
                } else {
                    let response = task.result
                    if let userAttributes = response?.userAttributes {
                        print("user attributes found: \(userAttributes)")
                        for attribute in userAttributes {
                            print("\(attribute.name) = \(attribute.value)")
                        }
                    }
                }
            }
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

