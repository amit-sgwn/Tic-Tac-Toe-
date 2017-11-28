//
//  FireBaseNotification.swift
//  Tic-Tac-Toe
//
//  Created by Amit on 28/11/17.
//  Copyright © 2017 Amit. All rights reserved.
//

import Foundation
import AFNetworking
import Firebase
import FirebaseDatabase

class FireBaseNotification {
    
    //MARK: Properties
    let baseURL = URL(string: BASE_URL)!
    
    //MARK: Action
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
}
