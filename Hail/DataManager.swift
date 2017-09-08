//
//  DataSource.swift
//  Hail
//
//  Created by Harsha Goli on 7/31/17.
//  Copyright © 2017 Harsha Goli. All rights reserved.
//

import Foundation
import RealmSwift

class DataManager {
    let realm = try! Realm()
    let thread = Thread.current
    let nodeManager = NodeManager()
    
    init(){
        //Prints Realm URL. Useful for debugging
        print("Realm URL: "+(realm.configuration.fileURL?.absoluteString)! + "\n\n")
    }
    
    //completionHandler accepts an optional closure with params returnedAddress of type WalletAddress. For example usage see ReceiveTransactionViewController
    func getNewAddressfor(id:String, network: String, completionHandler:@escaping ((_ returnedAddress:WalletAddress) -> Void) = {returnedAddress in print(returnedAddress.value)}) {
        nodeManager.generateNewAddress(network: network, identifier: id, completionHandler: {
            returnedJSON in
            /*
             self.thread.async {} is used to keep track of the current thread that involves this class.
             This is done because Realm is not thread safe and you cannot access Realm instances across 
             threads, a problem that will occur when doing async programming. 
             
             - Adds block to the end of the queue
            */
            self.thread.async {
                //Add to db
                let addr = WalletAddress(address: returnedJSON["address"] as! String)
                let wallet = self.realm.objects(CryptoWallet.self).filter("id == %@", id).first
                try! self.realm.write {
                    wallet?.receiveAddresses.append(addr)
                }
                
                //Now the address is passed to another block that accesses another thread. I know, iOS async is fun
                completionHandler(addr)
            }
        })
    }
    
    //TODO: Implement this logic
    func submitTransaction(wallet: CryptoWallet, toAddress: String, amount: Double) -> Bool {
        
        if ((wallet.aggregateCoinValue() - amount) < 0) {
            return false
        }
        
        let tx = Transaction()
        tx.coinValue = amount - (2 * amount)
        
        let addr = WalletAddress()
        addr.value = toAddress
        
        tx.toAddress = addr
        try! realm.write {
            wallet.transactions.append(tx)
        }
        
        return true
    }
    
    func addWallet(name: String, network: String, masterKey:String? = nil) {
        let key = masterKey ?? "null"
        let id = String(arc4random())
        
        //TODO: add func that does this and check bcoin for duplicate Id
        let duplicateWallets = realm.objects(CryptoWallet.self).filter("id == %@", id)
        
        if (duplicateWallets.count != 0) {
            print("Wallet input failed. Wallet with same id found")
            return
        }
        
        //If key is provided, then import the wallet
        if (key != "null") {
            nodeManager.registerNewWallet(network: network, identifier: id, name: name, masterkey: key, completionHandler: {
                returnedJSON in
                self.thread.async {
                    let wallet = CryptoWallet()
                    wallet.id = returnedJSON["id"] as! String
                    wallet.token = returnedJSON["token"] as! String
                    let account = returnedJSON["account"] as! [String : AnyObject]
                    wallet.changeAddress = WalletAddress(address: account["changeAddress"] as! String)
                    wallet.receiveAddresses.append(WalletAddress(address: account["receiveAddress"] as! String))
                    wallet.masterKey = account["accountKey"] as! String
                    wallet.network = network
                    wallet.name = name
                    
                    self.saveWallet(wallet: wallet)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                }
            })
        } else {
            nodeManager.registerNewWallet(network: network, identifier: id, name: name, completionHandler: {
                returnedJSON in
                self.thread.async {
                    let wallet = CryptoWallet()
                    wallet.id = returnedJSON["id"] as! String
                    wallet.token = returnedJSON["token"] as! String
                    let account = returnedJSON["account"] as! [String : AnyObject]
                    wallet.changeAddress = WalletAddress(address: account["changeAddress"] as! String)
                    wallet.receiveAddresses.append(WalletAddress(address: account["receiveAddress"] as! String))
                    wallet.masterKey = account["accountKey"] as! String
                    wallet.network = network
                    wallet.name = name
                    
                    self.saveWallet(wallet: wallet)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                }
            })
        }
        
    }
    
    func saveWallet(wallet: CryptoWallet){
        if (wallet.id == "null") {
            print("wallet creation failed")
            return
        }
        try! realm.write {
            realm.add(wallet)
        }
    }
    
    var walletCount: Int {
        get{
            return realm.objects(CryptoWallet.self).count
        }
    }
    
    func getNumberOfWalletsFor(network: String) -> Int {
        return realm.objects(CryptoWallet.self).filter("network == %@", network).count
    }
    
    func getWalletsFor(network: String) -> Results<CryptoWallet> {
        return realm.objects(CryptoWallet.self).filter("network == %@", network)
    }
    
    func getWalletsOrderedByIndex() -> Results<CryptoWallet> {
        //Returns wallets by index from 0 to last
        return realm.objects(CryptoWallet.self).sorted(byKeyPath: "positionIndex")
    }
    
    func deleteWallet(wallet: CryptoWallet){
        try! realm.write {
            realm.delete(realm.objects(CryptoWallet.self).filter("id == %@", wallet.id))
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func importWallet(network: String, masterKey: String) {
        switch network {
        case "Bitcoin":
            break;
        default:
           print("Error")
        }
    }
}

//Begin Realm models
class WalletAddress: Object {
    dynamic var value: String = "null"
    
    convenience init(address: String) {
        self.init()
        self.value = address
    }
}

class Transaction: Object {
    dynamic var transactionId: String = "null"
    dynamic var coinValue: Double = -1.0
    dynamic var purchasedFiatValue: Double = -1.0
    dynamic var fiatType: String = "null"
    dynamic var dateSent: Date = Date()
    dynamic var toAddress: WalletAddress? = WalletAddress()
    

}


class CryptoWallet: Object {
    dynamic var network: String = "null"
    dynamic var name: String = "null"
    dynamic var masterKey: String = "null"
    dynamic var id: String = "null"
    dynamic var token = "null"

    let receiveAddresses = List<WalletAddress>()
    dynamic var changeAddress: WalletAddress? = WalletAddress()
    let transactions = List<Transaction>()
    
    //Index presents views starting at 1
    dynamic var positionIndex: Int = -1
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func aggregateCoinValue() -> Double {
        var balance = 0.0
        var postedBalance = 0.0
        
        for tx in self.transactions {
            if (self.receiveAddresses.contains(tx.toAddress!)) {
                balance += tx.coinValue
            } else {
                postedBalance += tx.coinValue
            }
        }
        
        return balance - postedBalance
    }
    
    func aggregateFiatValue() -> Double {
        let txs = self.transactions
        var total = 0.0
        for t in txs {
            total += t.purchasedFiatValue
        }
        return total
    }
    
    func popLastTwoTransactions() -> [Transaction] {
        var result: [Transaction] = []
        result.append(self.transactions.first!)
        result.append(self.transactions.last!)
        return result
    }
    
    func getLastTransaction() -> Transaction {
        return self.transactions.last!
    }
}

//Begin needed extensions
extension Thread {
    
    private typealias Block = @convention(block) () -> Void
    
    /**
     Execute block, used internally for async/sync functions.
     
     - parameter block: Process to be executed.
     */
    @objc private func run(block: Block) {
        block()
    }
    
    /**
     Perform block on current thread asynchronously.
     
     - parameter block: Process to be executed.
     */
    public func async(execute: Block) {
        guard Thread.current != self else { return execute() }
        perform(#selector(run(block:)), on: self, with: execute, waitUntilDone: false)
    }
    
    /**
     Perform block on current thread synchronously.
     
     - parameter block: Process to be executed.
     */
    public func sync(execute: Block) {
        guard Thread.current != self else { return execute() }
        perform(#selector(run(block:)), on: self, with: execute, waitUntilDone: true)
    }
}


