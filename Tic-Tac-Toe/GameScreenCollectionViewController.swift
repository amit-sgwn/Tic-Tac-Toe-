//
//  GameScreenCollectionViewController.swift
//  Tic-Tac-Toe
//
//  Created by Amit on 17/11/17.
//  Copyright © 2017 Amit. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class GameScreenCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    @IBOutlet weak var gameGridView: UICollectionView!
    var game: Game = Game()

    override func viewDidLoad()
    {
        super.viewDidLoad()
//        guard game != nil else
//        {
//            fatalError("Game object not provided")
//        }
        
        let gridLayout = gameGridView.collectionViewLayout as! UICollectionViewFlowLayout
        gridLayout.itemSize.width = (view.frame.width - 4)/3
        gridLayout.itemSize.height = gridLayout.itemSize.width
    }
    
    private func getGamePosition(from indexPath: IndexPath) -> (row: Int, column: Int)
    {
        let row = indexPath.row/3
        let column = indexPath.row%3
        return (row, column)
    }
    
    private func indexPath(from move: Move) -> IndexPath
    {
        return IndexPath(row: move.position.row*3 + move.position.column, section: 0)
    }
    
    private func restartGame()
    {
        game = Game()
        gameGridView.reloadData()
    }

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return game.size
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath as IndexPath) as! GameButtonCell
        let position = getGamePosition(from: indexPath)
        cell.display(game.state[position.row, position.column])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let position = getGamePosition(from: indexPath)
        let move = game.makeMoveOn(row: position.row, column: position.column)
        if move != nil
        {
            gameGridView.reloadItems(at: [indexPath])
            if let winningSign = game.state.getWinner()
            {
                let alert = UIAlertController(title: "\(winningSign) won!", message: "Game completed, you can start again or go back", preferredStyle: .alert)
                let goBackAction = UIAlertAction(title: "Go back", style: .cancel, handler: { (_) in
                    self.dismiss(animated: true, completion: nil)
                })
                let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { (_) in
                    self.restartGame()
                })
                
                alert.addAction(goBackAction)
                alert.addAction(restartAction)
                present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            let alert = UIAlertController(title: "Invalid move", message: "You can't play on this cell again, but you can undo your last move", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let undoAction = UIAlertAction(title: "Undo", style: .destructive, handler: { (_) in
                if let move = self.game.undoLastMove()
                {
                    let indexPath = self.indexPath(from: move)
                    self.gameGridView.reloadItems(at: [indexPath])
                }
            })
            
            alert.addAction(undoAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
}


