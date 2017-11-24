//
//  Database.swift
//  Tic-Tac-Toe
//
//  Created by Amit on 23/11/17.
//  Copyright © 2017 Amit. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import AFNetworking

class ServerData {
    
    //MARK: Properties
    var rootRef: DatabaseReference
    var otherDevicesTokens : [String?] = []
    var otherPlayer : [Player?] = []
    var token : String?
    var shouldIadd : Bool?
    
    //MARK : Constructor
    init(){
        self.rootRef = Database.database().reference()
        token = Messaging.messaging().fcmToken
        
    }
    
    
    //MARK: Action
    func registerUser(Name name : String){
        // MARK : Accessing json child
        let gameName = rootRef.child("Games\(token!)")
        let gameId = gameName.child("GameId")
        let fcmTocken = gameName.child("fcmtoken")
        let player = gameName.child("player")
        let playerid = player.child("playerId")
        let playername = player.child("name")
        let playersign = player.child("Sign")
        let newplayer = Player(name,.circle)
        
        let gameid = UUID().uuidString
        //MARK : setting values
        gameId.setValue(gameid)
        fcmTocken.setValue(token)
        playerid.setValue(newplayer.id)
        playername.setValue(newplayer.name)
        playersign.setValue(String(describing: newplayer.sign))
    }
    
    func getUserData() -> UserData {
        
        var newGame = UserData()
        rootRef.observe(.value, with: { snapshot in
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
                    if fcm as! String == self.token! {
                      //  self.isthere = true
                    }
                }
                self.otherDevicesTokens.append(valu?["fcmtoken"] as? String)
                self.otherPlayer.append(valu?["player"] as? Player)
                //   print(valu?["fcmtoken"])
                newGame.fcmtoken = valu?["fcmtoken"] as? String
                newGame.gameid = valu?["GameId"] as? String
                newGame.player = valu?["player"] as? Player
            }
        })
        
        return newGame
    }
    
    func shouldInsertData(completion: @escaping ((Bool) -> Void))  {
        
        rootRef.observe(.value, with: { snapshot in
            let shouldIinsert = !snapshot.exists()
            print("value is    ...",shouldIinsert)
           // print(shouldIinsert)
            self.shouldIadd = !snapshot.exists()
            print("return value ",shouldIinsert)
            completion(shouldIinsert)
        })
}

}
struct UserData {
    var fcmtoken : String?
    var gameid : String?
    var player : Player?
}
