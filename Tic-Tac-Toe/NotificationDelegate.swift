//
//  NotificationDelegate.swift
//  Tic-Tac-Toe
//
//  Created by Amit on 21/11/17.
//  Copyright © 2017 Amit. All rights reserved.
//

import Foundation
import UserNotifications
import Firebase

class NotificationDelegate : NSObject, UNUserNotificationCenterDelegate {
    override init(){
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    
}
