//
//  GameScreenCollectionViewController.swift
//  Tic-Tac-Toe
//
//  Created by Amit on 17/11/17.
//  Copyright © 2017 Amit. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class GameScreenCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var isMyTurn : Bool = true;
    @IBOutlet weak var gameGridView: UICollectionView!
    fileprivate let reuseIdentifier = "GameCell"
var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate var totalcells = [GameButtonCell]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gridLayout = gameGridView.collectionViewLayout as! UICollectionViewFlowLayout
        gridLayout.itemSize.width = (view.frame.width - 4)/3
        gridLayout.itemSize.height = gridLayout.itemSize.width
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath)
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.gameButton. = self.items[indexPath.item]
      //  cell.gameButton.setTitle(self.items[indexPath.item], for: .normal)
//        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        let cellq = collectionView.cellForItem(at: indexPath) as! GameButtonCell
        if isMyTurn {
            cellq.imageView.image = UIImage(named : "image_x.png")
           // cell.backgroundColor = UIColor.red
            print(true)
            isMyTurn = false
        } else{
            cellq.imageView.image = UIImage(named : "image_o.png")
            isMyTurn = true
            print(false)
        }
        
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


