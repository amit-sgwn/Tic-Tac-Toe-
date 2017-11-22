//
//  SplashScreenViewController.swift
//  Tic-Tac-Toe
//
//  Created by Amit on 20/11/17.
//  Copyright © 2017 Amit. All rights reserved.
//

import UIKit
import AFNetworking
import Firebase
import FirebaseDatabase

class SplashScreenViewController: UIViewController {
    
    let baseURL = URL(string: "https://fcm.googleapis.com")!
    
    // MARK : Declairing database variables
    var ref: DatabaseReference!
    var rootRef: DatabaseReference!
    
    func postReqest()
    {
         let manager = AFHTTPSessionManager(baseURL: baseURL)
        manager.responseSerializer = AFJSONResponseSerializer()
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("key=AAAAEi3zdu4:APA91bEcVVZW1HGnqLzaiBOFnJqOOYpGyZJQP-kTa0z17V-y0vpI_YlKpJIvzJEXbR4fjipb-tc1Velu9DaKP21Y2DXd57FkwK528odOetUn3rT2oRRaCloEmhrvO4ciVtTm4CQWHaxk", forHTTPHeaderField: "Authorization")
        
        let parameters = NSMutableDictionary()
        parameters["to"] = "cqtdI7BObw8:APA91bGIaJJ6ruMh5yffpjSFqs2M3aIrqY8aFc2-Q7xjHG5QGLmDqyl4ujieQq93PD2zqA1k2Dw03AFhVZgOo3Bj7ls4lV1EhzF9iqss-tg9QHBJozsDiC6T8MHNZqmInaPN9eAISOzE"
        
        let notification = NSMutableDictionary()
        notification["body"] = "This is an FCM notification message!"
        notification["title"] = "Test Title"
        parameters["notification"] = notification
        
        _ = manager.post("https://fcm.googleapis.com/fcm/send", parameters: parameters, success: { (_, response) in
            print(response)
        }) { (task, error) in
            print(error)
        }
    }
    
    func getRawPlayer(){
        var player = Player("Amit",.circle)
    }
    @IBAction func online(_ sender: UIButton) {
       postReqest()
        rootRef = Database.database().reference()
        ref = Database.database().reference(withPath : "Games")
        let gameId = ref.child("GameId")
        let fcmTocken = ref.child("fcmtoken")
        let player = ref.child("player")
        var playerid = player.child("playerId")
        var playername = player.child("name")
        gameId.setValue("1")
        fcmTocken.setValue("jdkjskjfhjkdfhkdhkfjhkhjfhkd")
        playerid.setValue("jskjf")
        playername.setValue("Amit")
        //print(rootRef.key)
       // self.ref.child("player").child(user.uid).setValue(["username": username])
        print(ref.key)
    }
    
}
