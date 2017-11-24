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
    var isthere = false
    var otherDevicesTokens : [String?] = []
    var otherPlayer : [Player?] = []
    var serverData : ServerData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let token = Messaging.messaging().fcmToken
        self.nameField.delegate = self
        
        serverData = getServerData()
        
//        if serverData!.shouldInsertData() == false  {
//            //serverData!.registerUser(Name: <#T##String#>)
//            var userData = serverData!.getUserData()
//
//        }
//
        ref = Database.database().reference()
        ref.observe(.value, with: { snapshot in
            print("key is ",snapshot.key)
            print("value is ",snapshot.value!)
            let value = snapshot.value as? NSDictionary
            let fcm = value?["fcmtoken"] as? String ?? ""
            print("fcm is ",fcm)
            for item in snapshot.children {
                print("key is ",(item as! DataSnapshot).key)
                print("value is ",(item as! DataSnapshot).value!)
                let valu = (item as! DataSnapshot).value as? NSDictionary
                if let fcm = valu?["fcmtoken"] {
                    print(fcm)
                    if fcm as! String == token! {
                        self.isthere = true
                    }
                }
                self.otherDevicesTokens.append(valu?["fcmtoken"] as? String)
                self.otherPlayer.append(valu?["player"] as? Player)
             //   print(valu?["fcmtoken"])
               
            }
        })
        
    }
    
    
    func getServerData() -> ServerData{
        return ServerData()
    }
    
    
//    override func viewDidDisappear(_ animated: Bool) {
//        let token = Messaging.messaging().fcmToken
//        rootRef = Database.database().reference()
//        let gameName = rootRef.child("Games\(token!)")
//        gameName.setValue(nil)
//    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return false
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    
    @IBAction func submitAction(_ sender: UIButton) {
        
        // MARK : Properties
        let playerName = nameField.text
        //print(serverData!.shouldInsertData())
        
        serverData?.shouldInsertData(completion: { (shouldInsert) in
            if shouldInsert
            {
                self.serverData?.registerUser(Name: playerName!)
                var data = self.self.serverData?.getUserData()
                print("fcm token is ",data?.fcmtoken)
                print("game id",data?.gameid)
                print("palyer name is " ,data?.player?.name," id is ",data?.player?.id)
            }
        })
        
        
        
        
        
   
//        // MARK : Properties
//        let playerName = nameField.text
//        let token = Messaging.messaging().fcmToken
//        rootRef = Database.database().reference()
//        ref = Database.database().reference(withPath : "Games")
//
//
//        // MARK : Accessing json child
//        let gameName = rootRef.child("Games\(token!)")
//        let gameId = gameName.child("GameId")
//        let fcmTocken = gameName.child("fcmtoken")
//        let player = gameName.child("player")
//        let playerid = player.child("playerId")
//        let playername = player.child("name")
//        let playersign = player.child("Sign")
//        let newplayer = Player(playerName!,.circle)
//
//
//        //MARK : setting values
//        gameId.setValue("1")
//        fcmTocken.setValue(token)
//        playerid.setValue(newplayer.id)
//        playername.setValue(newplayer.name)
//        playersign.setValue(String(describing: newplayer.sign))

        
//        if otherDevicesTokens.count > 0 {
//            //otherDevicesTokens.first
//            if token != otherDevicesTokens.first!  {
//                if var name = otherPlayer.first??.name {
//                }
//                postReqest(from: token, to: otherDevicesTokens.first , title: "StartGame" , message: "You are connected to new player ")
//            }
//        }
        //print(rootRef.key)
    }
    
    
    
    func postReqest(from _: String? ,to: String??,title : String, message: String)
    {
         let manager = AFHTTPSessionManager(baseURL: baseURL)
        manager.responseSerializer = AFJSONResponseSerializer()
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("key=AAAAEi3zdu4:APA91bEcVVZW1HGnqLzaiBOFnJqOOYpGyZJQP-kTa0z17V-y0vpI_YlKpJIvzJEXbR4fjipb-tc1Velu9DaKP21Y2DXd57FkwK528odOetUn3rT2oRRaCloEmhrvO4ciVtTm4CQWHaxk", forHTTPHeaderField: "Authorization")
        
        let parameters = NSMutableDictionary()
      //  parameters["to"] = "cqtdI7BObw8:APA91bGIaJJ6ruMh5yffpjSFqs2M3aIrqY8aFc2-Q7xjHG5QGLmDqyl4ujieQq93PD2zqA1k2Dw03AFhVZgOo3Bj7ls4lV1EhzF9iqss-tg9QHBJozsDiC6T8MHNZqmInaPN9eAISOzE"
        parameters["to"] = to!!
        let notification = NSMutableDictionary()
        notification["body"] = message
        notification["title"] = title
        parameters["notification"] = notification
        
        _ = manager.post("https://fcm.googleapis.com/fcm/send", parameters: parameters, success: { (_, response) in
            print(response!)
        }) { (task, error) in
            print(error)
        }
        print("notifi")
        
    }
    

    @IBAction func online(_ sender: UIButton) {
       //postReqest()
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
