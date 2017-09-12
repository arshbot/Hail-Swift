//
//  NodeManager.swift
//  Hail
//
//  Created by Harsha Goli on 8/13/17.
//  Copyright © 2017 Harsha Goli. All rights reserved.
//

import Foundation

class NodeManager {

    //Default ports
    let bitcoinNodeURL: String = "http://127.0.0.1:18332"
    let litecoinNodeURL: String = "http://127.0.0.1:19336"
    
    //Ideally this would be pulled from firebase or some off site server. Don't store credentials in code!
    let bitcoinNodeUser: String = "x"
    let bitcoinNodePassword: String = "iamsatoshi"
    let litcoinNodeUser: String = "x"
    let litcoinNodePassword: String = "iamsatoshi"
    
    init() {
        self.establishConnection()
    }
    
    func establishConnection() {
        
        //BTC TESTNET
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
        //Execute the call
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
        case "BTC TESTNET":
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
                    //Execute the call
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
                                guard let jsonDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject] else {
                                        print("error trying to convert data to JSON")
                                        return
                                }
                                completionHandler(jsonDict)
                            } catch {
                                print("error trying to convert data to JSON")
                                return
                            }
                        }
                    })
                    //Execute the call
                    dataTask.resume()
                }
            } catch let error {
                print("got an error creating the request: \(error)")
            }
        default:
            print("network variable not initialized in NodeManager")
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
