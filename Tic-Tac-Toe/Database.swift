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
    
    private func registerUser(){
        
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
