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
import AWSS3
import Photos
import AWSMobileClient
import AWSUserPoolsSignIn
import AWSFacebookSignIn
import FBSDKCoreKit


class SecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    var imagePicker = UIImagePickerController()

    @IBAction func signOutButton(_ sender: Any) {
        if(AWSFacebookSignInProvider.sharedInstance().isLoggedIn)
        {
            AWSFacebookSignInProvider.sharedInstance().logout()
        }
        if (AWSSignInManager.sharedInstance().isLoggedIn) {
            AWSSignInManager.sharedInstance().logout(completionHandler: {(result: Any?, error: Error?) in
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "loggedOut")
                self.present(controller, animated: true, completion: nil)            })
        }
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "loggedOut")
        self.present(controller, animated: true, completion: nil)
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
    
    @IBAction func changeProfilePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func uploadProfilePicture(newPicture: UIImage, newImageUrl: URL) -> Void {
        let S3BucketName = "radius-userfiles-mobilehub-1592979956"
//        AWSCognitoUserPoolsSignInProvider.sharedInstance().getUserPool().currentUser()?.getSession()

//        let data: Data = Data() // Data to be uploaded
        let data: Data = UIImagePNGRepresentation(newPicture)!
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Update a progress bar.
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        
        transferUtility.uploadData(data,
                                   bucket: S3BucketName,
                                   key: "public/test.asdfd",
                                   contentType: "image/png",
                                   expression: expression,
                                   completionHandler: completionHandler).continueWith {
                                    (task) -> AnyObject! in
                                    if let error = task.error {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                    
                                    if let _ = task.result {
                                        // Do something with uploadTask.
                                        print("TEST!!!!!!!!")
                                    }
                                    return nil;
        }

    }
    
    // MARK: - ImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePicture.contentMode = .scaleAspectFit
            profilePicture.image = pickedImage
            let imgUrl = info[UIImagePickerControllerImageURL] as? URL
            
            uploadProfilePicture(newPicture: pickedImage, newImageUrl: imgUrl!)
            print("DONE!!!")
        }

        
//        if let imgUrl = info[UIImagePickerControllerImageURL] as? URL
//        {
//            let imgName = imgUrl.lastPathComponent
//            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
//            let localPath = documentDirectory?.appending(imgName)
//
//            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//            let data = UIImagePNGRepresentation(image)! as NSData
//            data.write(toFile: localPath!, atomically: true)
//            //let imageData = NSData(contentsOfFile: localPath!)!
//            let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
//            print(imgUrl)
//            uploadProfilePicture(newPicture: image, newImageUrl: imgUrl)
//        }
        
        /*
         
         Swift Dictionary named “info”.
         We have to unpack it from there with a key asking for what media information we want.
         We just want the image, so that is what we ask for.  For reference, the available options are:
         
         UIImagePickerControllerMediaType
         UIImagePickerControllerOriginalImage
         UIImagePickerControllerEditedImage
         UIImagePickerControllerCropRect
         UIImagePickerControllerMediaURL
         UIImagePickerControllerReferenceURL
         UIImagePickerControllerMediaMetadata
         
         */
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }


}

