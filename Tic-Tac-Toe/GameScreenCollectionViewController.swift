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
    var notificationObject = FireBaseNotification()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    //making game type online for testing purpose
    var serverdata : ServerData?
    

    //MARK:Action
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.remoteNotificationReceived(notification:)), name: Notification.Name("pushNotificationReceived"), object: nil)
        print(game.type)
        self.game.type = .online
        print("game id viewdidload",game.id)
        print("game type viewdidload " ,game.type)
        let gridLayout = gameGridView.collectionViewLayout as! UICollectionViewFlowLayout
        gridLayout.itemSize.width = (view.frame.width - 4)/3
        gridLayout.itemSize.height = gridLayout.itemSize.width
        
        activityIndicator.center = CGPoint(x: gameGridView.bounds.size.width/2, y: gameGridView.bounds.size.height/2)
        activityIndicator.color = UIColor.yellow
        activityIndicator.color = UIColor.black
        gameGridView.addSubview(activityIndicator)
        if game.type == .online {
            print("calling start game")
            startGame()
        }
        
    }
    
    
    @objc func remoteNotificationReceived(notification: NSNotification)
    {
        print("notificvation recieved is jkfhgdkjghjd@@@@@ ",notification)
        activityIndicator.stopAnimating()
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
    
    private func showGameCompleteAlert(withTitle title: String)
    {
        let alert = UIAlertController(title: title, message: "Game completed, you can start again or go back", preferredStyle: .alert)
        let goBackAction = UIAlertAction(title: "Go back", style: .cancel, handler: { (_) in
            self.navigationController?.popViewController(animated: true)
        })
        let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { (_) in
            self.restartGame()
        })
        
        alert.addAction(goBackAction)
        alert.addAction(restartAction)
        present(alert, animated: true, completion: nil)
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
        activityIndicator.startAnimating()
        if move != nil
        {
            gameGridView.reloadItems(at: [indexPath])
            if let winningSign = game.state.getWinner()
            {
                showGameCompleteAlert(withTitle: "\(winningSign) won!")
            }
            else if game.state.isDraw()
            {
                showGameCompleteAlert(withTitle: "Match draw")
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
    
    func startGame(){
        serverdata = getServerData()
        serverdata!.getUserData(completion: { (fcmtoken,gameid,player) in
            if fcmtoken == nil {
                print("no user online")
            } else if fcmtoken! == (self.serverdata!.token)! {
                print("you are there")
            } else {
                print("fcm from server ",fcmtoken!)
                print("my fcm ",(self.serverdata!.token)!)
                print("other user is there with fcmtoken ",fcmtoken!)
                print(player?.sign as Any)
                var gameobject = GameInfo(game: self.game,player: player!,fcmtoken: self.serverdata!.token!)
                self.notificationObject.postReqest(from: self.serverdata!.token!, to: fcmtoken!, title: "Hello", message: "Notification")
            }
        })
    }
    
    func getServerData() -> ServerData{
        return ServerData()
    }

}


