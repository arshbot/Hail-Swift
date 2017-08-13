//
//  NodeManager.swift
//  Hail
//
//  Created by Harsha Goli on 8/13/17.
//  Copyright © 2017 Harsha Goli. All rights reserved.
//

import Foundation

class NodeManager {
    
    let coin: String
    
    init(coin: String) {
        self.coin = coin
    }
    
    func establishConnection() -> Bool {
        switch coin {
        case "Bitcoin":
            let url = URL(string: "http://www.stackoverflow.com")
            let request = URLRequest(url: url!)
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {(response, data, error) in
                print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
            }
        default:
            print("coin variable not initialized in NodeManager")
        }
    }
    
}
