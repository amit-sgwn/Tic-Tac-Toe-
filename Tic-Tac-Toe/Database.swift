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
    var ref: DatabaseReference!
    var rootRef: DatabaseReference!
    var otherDevicesTokens : [String?] = []
    var otherPlayer : [Player?] = []
    
    //MARK: Action
    private func registerUser(Name name : String){
        let token = Messaging.messaging().fcmToken
        rootRef = Database.database().reference()
        ref = Database.database().reference(withPath : "Games")
        
        
        // MARK : Accessing json child
        let gameName = rootRef.child("Games\(token!)")
        let gameId = gameName.child("GameId")
        let fcmTocken = gameName.child("fcmtoken")
        let player = gameName.child("player")
        let playerid = player.child("playerId")
        let playername = player.child("name")
        let playersign = player.child("Sign")
        let newplayer = Player(name,.circle)
        
        
        //MARK : setting values
        gameId.setValue("1")
        fcmTocken.setValue(token)
        playerid.setValue(newplayer.id)
        playername.setValue(newplayer.name)
        playersign.setValue(String(describing: newplayer.sign))
    }
    
    func getUserData() -> UserData {
        
        return UserData()
    }
}

struct UserData {
    var fcmtoken : String?
    var gameid : String?
    var player : Player?
}
