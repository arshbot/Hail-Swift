//
//  NodeManager.swift
//  Hail
//
//  Created by Harsha Goli on 8/13/17.
//  Copyright © 2017 Harsha Goli. All rights reserved.
//

import Foundation
import SwiftHTTP

//TODO: get rid SwiftHTTP stuff

class NodeManager {

    let bitcoinNodeURL: String = "http://127.0.0.1:18332"
    let bitcoinNodeUser: String = "x"
    let bitcoinNodePassword: String = "iamsatoshi"
    
    init() {
        self.establishConnection()
    }
    
    func establishConnection() {
        
        //Bitcoin
        let headers = [
            "cache-control": "no-cache",
        ]
        let request = NSMutableURLRequest(url: NSURL(string: "http://127.0.0.1:18332/")! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(data)
            }
        })
        dataTask.resume()
    }
    
    func registerNewWallet(network: String, identifier:String, name:String, masterkey:String? = nil, completionHandler: @escaping ((_ returnedJSON:[String: AnyObject]) -> Void)) {
        let key = masterkey ?? "null"
        var walletValue:CryptoWallet = CryptoWallet() {
            willSet(wal) {
                print("about to set walletValue")
            }
            didSet {
                print("Set walletValue")
            }
        }
        
        switch network {
        case "Bitcoin":
            do {
                
                //If masterkey is present, import wallet
                if (key != "null") {
                    
                    let headers = [
                        "content-type": "application/json",
                        "authorization": "Basic eDppYW1zYXRvc2hp",
                        "cache-control": "no-cache",
                    ]
                    
                    let postData = NSData(data: "{\"masterKey\": \(identifier)}"
                        .data(using: String.Encoding.utf8)!)
                    
                    let request = NSMutableURLRequest(url: NSURL(string: "http://\(bitcoinNodeURL)/wallet/\(identifier)")! as URL,
                                                      cachePolicy: .useProtocolCachePolicy,
                                                      timeoutInterval: 10.0)
                    request.httpMethod = "PUT"
                    request.allHTTPHeaderFields = headers
                    request.httpBody = postData as Data
                    
                    let session = URLSession.shared
                    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                        if (error != nil) {
                            print(error)
                        } else {
                            do {
                                guard let jsonDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject] else {
                                    print("error trying to convert data to JSON")
                                    return
                                }
                                
                                //Execute block passed in
                                completionHandler(jsonDict)
                            } catch {
                                print("error trying to convert data to JSON")
                                return
                            }
                        }
                    })
                    
                    dataTask.resume()
                    
                //If not, create new wallet
                } else {
                    let headers = [
                        "authorization": "Basic eDppYW1zYXRvc2hp",
                        "content-type": "application/javascript",
                        "cache-control": "no-cache",
                    ]
                    
                    let postData = NSData(data: "{\"id\": \(identifier), \"witness\": false}"
                    .data(using: String.Encoding.utf8)!)
                    
                
                    let request = NSMutableURLRequest(url: NSURL(string: "\(bitcoinNodeURL)/wallet/\(identifier)")! as URL,
                        cachePolicy: .useProtocolCachePolicy,
                        timeoutInterval: 10.0)
                    request.httpMethod = "PUT"
                    request.allHTTPHeaderFields = headers
                    request.httpBody = postData as Data
                
                    let session = URLSession.shared
                    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                        if (error != nil) {
                            print(error)
                        } else {
                            do {
                                guard let w = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject] else {
                                        print("error trying to convert data to JSON")
                                        return
                                }
                                
                                completionHandler(w)
                                
                            } catch {
                                print("error trying to convert data to JSON")
                                return
                            }
                        }
                    })
                
                    dataTask.resume()
                }
        
                //return success!
            } catch let error {
                print("got an error creating the request: \(error)")
                //return false
            }
        default:
            print("network variable not initialized in NodeManager")
            //return false
        }
        
        //Return to silence annoying Xcode errors
        //return walletValue

    }
    
    func importWallet(network: String, masterKey: String) {
        switch network {
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
    
    //Returns the new address in the completion handler
    func generateNewAddress(network: String, identifier:String, account:String="default", completionHandler: @escaping ((_ returnedJSON:[String: AnyObject]) -> Void)) {
        switch network {
        case "Bitcoin":
            let headers = [
                "content-type": "application/json",
                "authorization": "Basic eDppYW1zYXRvc2hp",
                "cache-control": "no-cache",
            ]
            
            let postData = NSData(data: "{\"account\": \"\(account)\"}"
            .data(using: String.Encoding.utf8)!)
            
            let request = NSMutableURLRequest(url: NSURL(string: "\(bitcoinNodeURL)/wallet/\(identifier)/address")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    do {
                        guard let w = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject] else {
                            print("error trying to convert data to JSON")
                            return
                        }
                        
                        completionHandler(w)
                        
                    } catch {
                        print("error trying to convert data to JSON")
                        return
                    }
                }
            })
            
            dataTask.resume()
        default:
            print("Error")
        }
        
    }
    
}
