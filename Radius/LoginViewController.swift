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


class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if AWSSignInManager.sharedInstance().isLoggedIn {
            // GO to user screen
        }
    }
    @IBAction func ButtonTouch(_ sender: Any) {
        let config = AWSAuthUIConfiguration()
        config.enableUserPoolsUI = true
        //        config.addSignInButtonView(class: AWSFacebookSignInButton.self)
        //        config.addSignInButtonView(class: AWSGoogleSignInButton.self)
        //        config.backgroundColor = UIColor.blue
        config.font = UIFont (name: "Helvetica Neue", size: 20)
        config.isBackgroundColorFullScreen = true
        config.canCancel = true
        //        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "theView")
        
        //        self.navigationController!.pushViewController(VC1, animated: true)
        
        AWSAuthUIViewController.presentViewController(
            with: self.navigationController!,
            configuration: config, completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                if error == nil {
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "loggedIn")
                    self.present(controller, animated: true, completion: nil)
                } else {
                    // end user faced error while loggin in, take any required action here.
                }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

