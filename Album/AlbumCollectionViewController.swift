//
//  AlbumCollectionViewController.swift
//  Album
//
//  Created by apple on 2023/1/27.
//

import UIKit

private let reuseIdentifier = "Cell"

class AlbumCollectionViewController: UICollectionViewController {
    static var allImages = [UIImage]()
    static var classifyImages: [String: [UIImage]] = [:]
    
    var sort: String = ""
    var sortLabel: UILabel = UILabel()

    var images = allImages
    private var viewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //print(images.count)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        self.viewLayout.itemSize = CGSize(width: self.view.frame.width / 3 - 10, height: self.view.frame.width / 3 - 10)
        self.viewLayout.minimumLineSpacing = 10
        self.viewLayout.minimumInteritemSpacing = 10
        self.collectionView.collectionViewLayout = viewLayout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sortLabel.text = sort
        if sort == "" {
            images = AlbumCollectionViewController.allImages
        } else {
            images = AlbumCollectionViewController.classifyImages[sort]!
            //self.sort = ""
        }
        print("num: ",images.count)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "AlbumToImageView" {
            let cell = sender as! CollectionViewCell
            let ImageView = segue.destination as! ImageViewController
            ImageView.image = cell.imageView.image!
            ImageView.result = self.sortLabel
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image Cell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.image = images[indexPath.item]
        cell.imageView.contentMode = UIView.ContentMode.scaleAspectFill
    
        // Configure the cell
        
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
