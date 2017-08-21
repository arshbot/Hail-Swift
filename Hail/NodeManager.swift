//
//  NodeManager.swift
//  Hail
//
//  Created by Harsha Goli on 8/13/17.
//  Copyright © 2017 Harsha Goli. All rights reserved.
//

import Foundation
import SwiftHTTP

//TODO:

class NodeManager {
    
    let bitcoinNodeURL: String = "http://127.0.0.1:18332/"
    let bitcoinNodeUser: String = "x"
    let bitcoinNodePassword: String = "iamsatoshi"
    
    let coin: String = ""
    
    init() {
        self.establishConnection()
    }
    
    func establishConnection() { //-> Bool {
        switch coin {
        case "Bitcoin":
            do {
                let opt = try HTTP.GET(bitcoinNodeURL)
                var success: Bool?
                
                //Inital auth
                var attempted = false
                opt.auth = { challenge in
                    if !attempted {
                        attempted = true
                        return URLCredential(user: self.bitcoinNodeUser, password: self.bitcoinNodePassword, persistence: .forSession)
                    }
                    print("Bitcoin Auth Failed")
                    return nil //auth failed, nil causes the request to be properly cancelled.
                }
                
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        success = false
                    } else {
                        print("Bitcoin connection successful")
                        print("opt finished: \(response.description)")
                        //print("data is: \(response.data)") access the response of the data with response.data
                        if (success == nil) {
                            success = true
                        }
                    }
                   
                }
                //return success!
            } catch let error {
                print("got an error creating the request: \(error)")
                //return false
            }
        default:
            print("coin variable not initialized in NodeManager")
            //return false
        }
    }
    
    func registerNewWallet(coin: String, identifier:String, masterkey:String? = nil) {//-> CryptoWallet {
        let key = masterkey ?? "null"
        switch coin {
        case "Bitcoin":
            do {
                
                //If masterkey is present, import wallet
                if (masterkey != "null") {
                    let opt = try HTTP.POST(bitcoinNodeURL+"/wallet/\(identifier)/import", parameters: ["account":"primary", "key":masterkey!])
                    var createdWallet = CryptoWallet()
                    
                    //Inital auth
                    var attempted = false
                    opt.auth = { challenge in
                        if !attempted {
                            attempted = true
                            return URLCredential(user: self.bitcoinNodeUser, password: self.bitcoinNodePassword, persistence: .forSession)
                        }
                        print("Bitcoin Auth Failed")
                        return nil //auth failed, nil causes the request to be properly cancelled.
                    }
                    
                    opt.start { response in
                        if let err = response.error {
                            print("error: \(err.localizedDescription)")
                        } else {
                            print("Bitcoin connection successful")
                            print("opt finished: \(response.description)")
                            //print("data is: \(response.data)") access the response of the data with response.data
                        }
                        
                    }
                    
                //If not, create new wallet
                } else {
                    let opt = try HTTP.PUT(bitcoinNodeURL+"/wallet/\(identifier)", parameters: ["id":identifier, "witness":false])
                    var success: Bool?
                    
                    //Inital auth
                    var attempted = false
                    opt.auth = { challenge in
                        if !attempted {
                            attempted = true
                            return URLCredential(user: self.bitcoinNodeUser, password: self.bitcoinNodePassword, persistence: .forSession)
                        }
                        print("Bitcoin Auth Failed")
                        return nil //auth failed, nil causes the request to be properly cancelled.
                    }
                    
                    opt.start { response in
                        if let err = response.error {
                            print("error: \(err.localizedDescription)")
                            success = false
                        } else {
                            print("Bitcoin connection successful")
                            print("opt finished: \(response.description)")
                            //print("data is: \(response.data)") access the response of the data with response.data
                        }
                    
                    }
                }
        
                //return success!
            } catch let error {
                print("got an error creating the request: \(error)")
                //return false
            }
        default:
            print("coin variable not initialized in NodeManager")
            //return false
        }
        
    }
    
    func importWallet(coin: String, masterKey: String) {
        switch coin {
        case "Bitcoin":
            do {
                let opt = try HTTP.GET(bitcoinNodeURL)
                var success: Bool?
                
                //Inital auth
                var attempted = false
                opt.auth = { challenge in
                    if !attempted {
                        attempted = true
                        return URLCredential(user: self.bitcoinNodeUser, password: self.bitcoinNodePassword, persistence: .forSession)
                    }
                    print("Bitcoin Auth Failed")
                    return nil //auth failed, nil causes the request to be properly cancelled.
                }
                
                opt.start { response in
                    if let err = response.error {
                        print("error: \(err.localizedDescription)")
                        success = false
                    } else {
                        print("Bitcoin connection successful")
                        print("opt finished: \(response.description)")
                        //print("data is: \(response.data)") access the response of the data with response.data
                        if (success == nil) {
                            success = true
                        }
                    }
                    
                }
                //return success!
            } catch let error {
                print("got an error creating the request: \(error)")
                //return false
            }
        default:
            print("Error")
        }

    }
    
}
