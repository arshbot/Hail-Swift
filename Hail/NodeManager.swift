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
    let btcTestnetNodeURL: String = "http://127.0.0.1:18332"
    let ltcTestnetNodeURL: String = "http://127.0.0.1:19336"
    
    //Ideally this would be pulled from firebase or some off site server. Don't store credentials in code!
    let btcTestnetNodeUser: String = "x"
    let btcTestnetNodePassword: String = "iamsatoshi"
    
    let ltcTestnetNodeUser: String = "x"
    let ltcTestnetNodePassword: String = "iamsatoshi"
    
    init() {
        self.establishConnection()
    }
    
    private func establishConnection() {
        
        //BTC TESTNET
        executeRequest(URL: NSURL(string: btcTestnetNodeURL)! as URL, httpMethod: "GET", completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(data)
            }
        })
        
        //LTC TESTNET
        executeRequest(URL: NSURL(string: ltcTestnetNodeURL)! as URL, httpMethod: "GET", completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(data)
            }
        })
        
    }
    
    func executeRequest(URL: URL, httpMethod: String, postData: String? = nil, headers: [String: String] = ["content-type": "application/json", "cache-control": "no-cache"], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void){
        
        let hdrs = headers
        let request = NSMutableURLRequest(url: URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        if (postData != nil){
            request.httpBody = NSData(data: postData!.data(using: String.Encoding.utf8)!) as Data
        }
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = hdrs
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
        
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
                    
                    let request = NSMutableURLRequest(url: NSURL(string: "http://\(btcTestnetNodeURL)/wallet/\(identifier)")! as URL,
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
                    
                    let request = NSMutableURLRequest(url: NSURL(string: "\(btcTestnetNodeURL)/wallet/\(identifier)")! as URL,
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
            
        case "LTC TESTNET":
            do {
                //If masterkey is present, import wallet
                if (key != "null") {
                    //Imports wallet from masterkey
                    executeRequest(URL: NSURL(string: "\(ltcTestnetNodeURL)/wallet/\(identifier)")! as URL,
                                   httpMethod: "PUT",
                                   postData: "{\"masterKey\": \(identifier)}",
                                   completionHandler:{ (data, response, error) -> Void in
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
                    
                //If not, create new wallet
                } else {
                    //Intializes new wallet
                    executeRequest(URL: NSURL(string: "\(ltcTestnetNodeURL)/wallet/\(identifier)")! as URL,
                                   httpMethod: "PUT",
                                   postData: "{\"id\": \(identifier), \"witness\": false}",
                                   completionHandler: { (data, response, error) -> Void in
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
        case "BTC TESTNET":
            /*
                 POST /wallet/:id/address
                 Host: 127.0.0.1:18332
                 Content-Type: application/json
                 Authorization: Basic eDppYW1zYXRvc2hp
                 Cache-Control: no-cache
                 
                 {
                    "account":"default"
                 }
             */
            
            let headers = [
                "content-type": "application/json",
                "authorization": "Basic eDppYW1zYXRvc2hp",
                "cache-control": "no-cache",
            ]
            
            let postData = NSData(data: "{\"account\": \"\(account)\"}"
            .data(using: String.Encoding.utf8)!)
            
            let request = NSMutableURLRequest(url: NSURL(string: "\(btcTestnetNodeURL)/wallet/\(identifier)/address")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
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
            
        case "LTC TESTNET":
            /*
                 POST /wallet/:id/address
                 Host: 127.0.0.1:19336
                 Content-Type: application/json
                 Authorization: Basic eDppYW1zYXRvc2hp
                 Cache-Control: no-cache
             
                 {
                    "account":"default"
                 }
            */
            executeRequest(URL: NSURL(string: "\(ltcTestnetNodeURL)/wallet/\(identifier)/address")! as URL,
                           httpMethod: "POST",
                           postData: "{\"account\": \"\(account)\"}",
                           completionHandler: { (data, response, error) -> Void in
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
            
        default:
            print("Error")
        }
        
    }
    
}
