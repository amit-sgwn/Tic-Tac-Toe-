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

class SplashScreenViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var nameField: UITextField!
    let baseURL = URL(string: "https://fcm.googleapis.com")!
    
    // MARK : Declairing database variables
    var ref: DatabaseReference!
    var rootRef: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        let token = Messaging.messaging().fcmToken
        self.nameField.delegate = self
        ref = Database.database().reference(withPath : "Games")
        ref.observe(.value, with: { snapshot in
            print("key is ",snapshot.key)
            print(snapshot.value)
            for item in snapshot.children {
                print("key is ",(item as! DataSnapshot).key)
                print((item as! DataSnapshot).value)
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return false
    }
    func dismissKeyboard() {
        
        view.endEditing(true)
    }

    @IBAction func submitAction(_ sender: UIButton) {
        var playerName = nameField.text
        let token = Messaging.messaging().fcmToken
        
        ref = Database.database().reference(withPath : "Games")
        let gameId = ref.child("GameId")
        let fcmTocken = ref.child("fcmtoken")
        let player = ref.child("player")
        let playerid = player.child("playerId")
        let playername = player.child("name")
        let playersign = player.child("Sign")
        var newplayer = Player(playerName!,.circle)
        gameId.setValue("1")
        fcmTocken.setValue(token)
        playerid.setValue(newplayer.id)
        playername.setValue(newplayer.name)
        playersign.setValue(String(describing: newplayer.sign))
        //print(rootRef.key)
    }
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
    

    @IBAction func online(_ sender: UIButton) {
       postReqest()
//        let token = Messaging.messaging().fcmToken
//        print("firebase token ",token)
//        rootRef = Database.database().reference()
//        ref = Database.database().reference(withPath : "Games")
//        let gameId = ref.child("GameId")
//        let fcmTocken = ref.child("fcmtoken")
//        let player = ref.child("player")
//        let playerid = player.child("playerId")
//        let playername = player.child("name")
//        gameId.setValue("1")
//        fcmTocken.setValue("jdkjskjfhjkdfhkdhkfjhkhjfhkd")
//        playerid.setValue("jskjf")
//        playername.setValue("Amit")
//        //print(rootRef.key)
//       // self.ref.child("player").child(user.uid).setValue(["username": username])
//        print(ref.key)
    }
    
}
