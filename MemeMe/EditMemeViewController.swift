//
//  EditMemeViewController.swift
//  MemeMe v2
//
//  Created by Elva Cabrera on 11/1/15.
//  Copyright (c) 2015 elvacabrera. All rights reserved.
//

import Foundation

import UIKit


class EditMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let imagePicker = UIImagePickerController()
   
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var photoPreview: UIImageView!
    @IBOutlet weak var pickFromAlbum: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cancelByUser: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.grayColor()
        
    
        topText.delegate = self;
        bottomText.delegate = self;
        imagePicker.delegate = self;
        
       
        if  UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == false {
            //cameraButton.enabled = false
        }
        
        shareButton.enabled = false
      
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
       
        func applyTextStyle(text: UITextField!){
            
            text.backgroundColor = UIColor.clearColor()
            text.borderStyle = .None
            text.tintColor = UIColor.whiteColor()
           
            let charAttributes = [
                NSStrokeWidthAttributeName: -3.0,
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSStrokeColorAttributeName: UIColor.blackColor(),
                NSFontAttributeName: UIFont(name: "Impact", size: 30)!,
            ]
            topText.defaultTextAttributes = charAttributes
            topText.textAlignment = .Center
            bottomText.defaultTextAttributes = charAttributes
            bottomText.textAlignment = .Center
        }
        applyTextStyle(topText)        
        applyTextStyle(bottomText)

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object: nil)
    }
  
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    @IBAction func cameraActivate(sender: UIBarButtonItem) {
            imagePicker.sourceType = .Camera
            presentViewController(imagePicker, animated: true, completion: nil)
            shareButton.enabled = true
    }
    
    @IBAction func albumActivate(sender: UIBarButtonItem) {
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage! {
            photoPreview.contentMode = .ScaleAspectFill
            photoPreview.image = selectedImage
            shareButton.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelByUser(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareIt(sender: UIBarButtonItem) {
        let shareMeme = createMemeImage()
        let activityController = UIActivityViewController(activityItems: [shareMeme], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            (activity, success, items, error) in
            self.saveMeme()
        }
        presentViewController(activityController, animated: true, completion: nil)
      
        
    }

    func createMemeImage() -> UIImage {
        navBar.hidden = true
        toolBar.hidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        
        navBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }

  //  struct Meme {
    //    var topText: String
      //  var bottomText: String
       // var image: UIImage
        //var memedImage: UIImage
   // }
    
    func saveMeme() {
        let memes = Meme(
            topText: topText.text!,
            bottomText: bottomText.text!,
            originalImage: photoPreview.image!,
            memeImage: createMemeImage()
        )
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(memes)
        
    }
    

}


