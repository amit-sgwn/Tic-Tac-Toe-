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
    let baseURL = URL(string: BASE_URL)!
    
    // MARK : Declairing database variables
    var ref: DatabaseReference!
    var rootRef: DatabaseReference!
    var type : Type = .offline
    var otherDevicesTokens : [String?] = []
    var otherPlayer : [Player?] = []
    var serverData : ServerData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let token = Messaging.messaging().fcmToken
        self.nameField.delegate = self
        
        serverData = getServerData()
        
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
                       
                    }
                }
                self.otherDevicesTokens.append(valu?["fcmtoken"] as? String)
                self.otherPlayer.append(valu?["player"] as? Player)
             //   print(valu?["fcmtoken"])
               
            }
        })
        
        serverData?.getUserData(completion: { (fcmtoken,gameid,player) in
            if fcmtoken == nil {
               print("no user online")
            } else if fcmtoken! == (self.serverData?.token)! {
                print("you are there")
            } else {
                print("fcm from server ",fcmtoken!)
                print("my fcm ",(self.serverData?.token)!)
                print("other user is there with fcmtoken ",fcmtoken)
            }
            print("Inside did view load")
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
        
        var existingToken : Bool?
        serverData?.shouldInsertData(completion: { (shouldInsert) in
            if shouldInsert
            {
                self.serverData?.registerUser(Name: playerName!)
                print("we are here in ")
                existingToken = false
            } else {
                print("we are here in else")
                existingToken = true
                self.serverData?.getUserData(completion: { (fcmtoken,gameid,player) in
                    if fcmtoken! == nil {
                        print("no user online")
                    } else if fcmtoken! == (self.serverData?.token)! {
                        print("you are there")
                    } else {
                        print("fcm from server ",fcmtoken!)
                        print("my fcm ",(self.serverData?.token)!)
                        print("other user is there with fcmtoken ",fcmtoken)
                        
                    }
                })
            }
        })
        
//        if existingToken! { serverData?.getUserData(completion: { (fcmtoken,gameid,player) in
//            if fcmtoken! == nil {
//                print("no user online")
//            } else if fcmtoken! == (self.serverData?.token)! {
//                print("you are there")
//            } else {
//                print("fcm from server ",fcmtoken!)
//                print("my fcm ",(self.serverData?.token)!)
//                print("other user is there with fcmtoken ",fcmtoken)
//
//            }
//        })
//        }
        
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
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "Gameclass"
        {
            let DestViewController = segue.destination as! GameScreenCollectionViewController
            DestViewController.game = Game()
            DestViewController.game.type = self.type
            print("game id ",DestViewController.game.id)
            print("game type " ,DestViewController.game.type)
            print("game type in splash ",type)
        }
    }

    @IBAction func online(_ sender: UIButton) {
        type = .online
        print("inside onlinre type is ",type)
    }
    
    
    func startGame(){
        
    }
    
}
