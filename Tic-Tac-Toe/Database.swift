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
    
    func getUserData(completion: @escaping ((String?,String?,Player?) -> Void))  {
        
  //      var newGame = UserData()
        var fcmtoken : String?
        var gameid : String?
        var player : Player?
        rootRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                let valu = (item as! DataSnapshot).value as? NSDictionary
                if let fcm = valu?["fcmtoken"] {
                    print(fcm)
                    if fcm as! String == self.token! {
                        fcmtoken = fcm as! String
                    }
                }
                gameid = valu?["GameId"] as? String
                fcmtoken = valu?["fcmtoken"] as? String
                player = valu?["player"] as? Player
                
                if (fcmtoken?.isEmpty)! && (gameid?.isEmpty)! && (player?.isEmpty)! {
                    return completion(nil, nil,nil)
                } else {
                    completion(fcmtoken,gameid,player)
                }
                
                print("fcmtoken retrived is ",fcmtoken ?? <#default value#>)
                print("gameid retrived is ",gameid ?? <#default value#>)
                print("player retrived is : ",player ?? <#default value#>)
            }
        })
    }
    
    
    func shouldInsertData(completion: @escaping ((Bool) -> Void))  {
        
        rootRef.observe(.value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let shouldIinsert = !snapshot.exists()
            print("value is    ...",shouldIinsert)
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
