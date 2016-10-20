//
//  ImagesCollectionTableViewCell.swift
//  homework
//
//  Created by Liu, Naitian on 10/18/16.
//  Copyright © 2016 naitianliu. All rights reserved.
//

import UIKit

class ImagesCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!

    var imageArray: [UIImage]!

    typealias AddImageClickedClosureType = () -> Void
    var addImageClickedBlock: AddImageClickedClosureType?

    typealias ImagePickedClosureType = (index: Int) -> Void
    var imagePickedBlock: ImagePickedClosureType?

    override func awakeFromNib() {
        super.awakeFromNib()

        self.initCollectionView()

        self.selectionStyle = .None

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    private func initCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerNib(UINib(nibName: "ImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImagesCollectionViewCell")
        collectionView.registerNib(UINib(nibName: "AddImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddImageCollectionViewCell")
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count + 1
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row < self.imageArray.count {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImagesCollectionViewCell", forIndexPath: indexPath) as! ImagesCollectionViewCell
            let image = self.imageArray[indexPath.row]
            cell.configurate(image)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AddImageCollectionViewCell", forIndexPath: indexPath) as! AddImageCollectionViewCell
            return cell
        }

    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.imageArray.count {
            if let addImageClicked = self.addImageClickedBlock {
                addImageClicked()
            }
        } else {
            if let imagePicked = self.imagePickedBlock {
                imagePicked(index: indexPath.row)
            }
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = CGSize(width: 100, height: 150)
        return size
    }

    func configurate(imageArray: [UIImage], addImageClicked: AddImageClickedClosureType, imagePicked: ImagePickedClosureType) {
        self.imageArray = imageArray
        self.addImageClickedBlock = addImageClicked
        self.imagePickedBlock = imagePicked
        collectionView.reloadData()
    }
    
}
