//
//  MemeDetailViewController.swift
//  MemeMe_v1
//
//  Created by Elva Cabrera on 11/9/15.
//  Copyright © 2015 elvacabrera. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    var memes: Meme?
    
    override func viewWillAppear(animated: Bool) {
       super.viewWillAppear(animated)
        
        // Set the image to the memed image passed in
        memeImageView.image = memes?.memeImage
        
        // Re-enable tranlucency
       // self.navigationController?.navigationBar.translucent = true
        
    }
}