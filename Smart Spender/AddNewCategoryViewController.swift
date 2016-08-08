//
//  AddNewCategoryViewController.swift
//  Smart Spender
//
//  Created by Alex on 27.07.16.
//  Copyright © 2016 AppStory. All rights reserved.
//

import UIKit
import Canvas


class AddNewCategoryViewController: UIViewController {

    let icons = ["Pic1", "Pic2", "Pic3","Pic4","Pic5", "Pic6", "Pic7", "Pic8", "Pic9", "Pic10", "Pic11"]
    
    private var categories: [String] {
        get {
            let userCategories = NSUserDefaults.standardUserDefaults().objectForKey("categories") as? [String]
            return userCategories!
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "categories")
        }
    }
    
    private var categoryImages: [String] {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("categoryImages") as! [String]
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "categoryImages")
        }
    }
    
    @IBOutlet var selectedImage: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var textField: UITextField!
    
    struct Constants {
        static let PicWidth: CGFloat = UIScreen.mainScreen().bounds.width/6
        static let Inset: CGFloat = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedImage.layer.cornerRadius = selectedImage.bounds.width / 2
        selectedImage.layer.masksToBounds = true
        setupNavBar ()
    }

    @IBAction func donePressed(sender: UIBarButtonItem) {
        guard textField.text! != "" else {return}
        categories.append(textField.text!)
        categoryImages.append(icons[collectionView.indexPathsForSelectedItems()!.last!.row])
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func setupNavBar () {
        navigationController!.navigationBar.setBackgroundImage(UIImage.init(named: "Toolbar Label"), forBarMetrics: .Default)
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        closeKeyboard ()
    }
    
    private func closeKeyboard () {
        self.view.endEditing(true)
    }
}

extension AddNewCategoryViewController: UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("iconCell", forIndexPath: indexPath) as! CategoryIconsCell
        cell.iconView.image = UIImage(named: icons[indexPath.item])
        cell.iconView.layer.masksToBounds = true
        cell.iconView.layer.cornerRadius =  Constants.PicWidth / 2
        return cell
    }
}

extension AddNewCategoryViewController: UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        UIView.animateWithDuration(0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 0.2,
                                   initialSpringVelocity: 9.0,
                                   options: [],
                                   animations: { collectionView.subviews[indexPath.item].transform = CGAffineTransformMakeScale(1.5, 1.5)
                                    collectionView.subviews[indexPath.item].transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: nil)
        selectedImage.image = UIImage(named: icons[indexPath.item])
        UIView.animateWithDuration(0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 0.2,
                                   initialSpringVelocity: 9.0,
                                   options: [],
                                   animations: { self.selectedImage.transform = CGAffineTransformMakeScale(1.5, 1.5)
                                    self.selectedImage.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: nil)
    }
}

extension AddNewCategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return Constants.Inset
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return Constants.Inset
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: Constants.Inset, left: Constants.Inset, bottom: 0, right: Constants.Inset)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = CGSize(width: Constants.PicWidth, height: Constants.PicWidth)
        return size
    }
}

