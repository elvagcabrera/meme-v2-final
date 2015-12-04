//
//  MemeCollectionViewController.swift
//  MemeMe v2
//
//  Created by Elva Cabrera on 12/3/15.
//  Copyright © 2015 elvacabrera. All rights reserved.
//

import Foundation
import UIKit


class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    // Outlet to our collection view
    @IBOutlet weak var memeCollectionView: UICollectionView!
    
    var memes: [Meme]! {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let screenSize = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        _ = screenSize.height
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (screenWidth/3) - 1, height: (screenWidth/3) - 1)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        memeCollectionView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get a copy of the memes array from the AppDelegate
       //let object = UIApplication.sharedApplication().delegate
       //let appDelegate = object as! AppDelegate
       //memes = appDelegate.memes
        
        // Reload the collection view
        memeCollectionView.reloadData()
        
        // Disable translucency to prevent table from disappearing under navigation bar
        self.navigationController?.navigationBar.translucent = false
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        
        cell.memeImageView?.image = meme.memeImage
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let memeDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        memeDetailVC.memes = memes[indexPath.item]
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
    }
}