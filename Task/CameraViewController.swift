//
//  CameraViewController.swift
//  Task
//
//  Created by Rajat Agarwal on 16/01/18.
//  Copyright © 2018 Rajat. All rights reserved.
//

import UIKit
import SDWebImage

class CameraViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var arr = [Any]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        readMYJson()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let img:UIImageView = cell.viewWithTag(1) as! UIImageView
        let indicator:UIActivityIndicatorView = cell.viewWithTag(2) as! UIActivityIndicatorView
        
        let dict = arr[0] as! [String: Any]
        //print(dict["link"] as! String)
        
        indicator.isHidden = false
        indicator.startAnimating()
        img.sd_setImage(with: URL(string:dict["link"] as! String), placeholderImage: nil, options: SDWebImageOptions(rawValue: 0) , completed: { (image, error, cache, url) in
            if error == nil
            {
                img.image = image
            }
            else
            {
                print(error?.localizedDescription as Any)
            }
            indicator.isHidden = true
            indicator.stopAnimating()
        })
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if UIScreen.main.traitCollection.userInterfaceIdiom == .phone
        {
            return CGSize(width: collectionView.frame.size.width/3 - 10, height: collectionView.frame.size.width/3 - 10)
        }
        else
        {
            return CGSize(width:collectionView.frame.size.width/4 - 10,height:collectionView.frame.size.width/4 - 10)
        }
    }
     func readMYJson() {
        do {
            if let file = Bundle.main.url(forResource: "CollectionJSON", withExtension: ".txt") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    arr = (object["items"] as? [Any])!
                    collectionView.reloadData()
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
