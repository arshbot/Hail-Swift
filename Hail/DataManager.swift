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
        print("Realm URL: "+(realm.configuration.fileURL?.absoluteString)! + "\n\n")
    }
    
    func getNewAddressfor(id:String, coin: String, completionHandler:@escaping ((_ returnedAddress:WalletAddress) -> Void) = {returnedAddress in print(returnedAddress.value)}) {
        nodeManager.generateNewAddress(coin: coin, identifier: id, completionHandler: {
            returnedJSON in
            self.thread.async {
                //Add to db
                let addr = WalletAddress(address: returnedJSON["address"] as! String)
                let wallet = self.realm.objects(CryptoWallet.self).filter("id == %@", id).first
                try! self.realm.write {
                    wallet?.receiveAddresses.append(addr)
                }
                //change view shit
                completionHandler(addr)
            }
        })
    }
    
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
    
    func addWallet(name: String, coin: String, masterKey:String? = nil) {
        let key = masterKey ?? "null"

        let id = String(arc4random())
        
        
        //TODO: add func that does this and check bcoin for duplicate Id
        let duplicateWallets = realm.objects(CryptoWallet.self).filter("id == %@", id)
        
        if (duplicateWallets.count != 0) {
            print("Wallet input failed. Wallet with same id found")
            return
        }
        
        if (key == "null") {
            nodeManager.registerNewWallet(coin: coin, identifier: id, name: name, masterkey: key, completionHandler: {
                returnedJSON in
                self.thread.async {
                    let wallet = CryptoWallet()
                    wallet.id = returnedJSON["id"] as! String
                    wallet.token = returnedJSON["token"] as! String
                    let account = returnedJSON["account"] as! [String : AnyObject]
                    wallet.changeAddress = WalletAddress(address: account["changeAddress"] as! String)
                    wallet.receiveAddresses.append(WalletAddress(address: account["receiveAddress"] as! String))
                    wallet.masterKey = account["accountKey"] as! String
                    wallet.coinType = coin
                    wallet.name = name
                    
                    self.saveWallet(wallet: wallet)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                }
            })
        } else {
            nodeManager.registerNewWallet(coin: coin, identifier: id, name: name, completionHandler: {
                returnedJSON in
                self.thread.async {
                    let wallet = CryptoWallet()
                    wallet.id = returnedJSON["id"] as! String
                    wallet.token = returnedJSON["token"] as! String
                    let account = returnedJSON["account"] as! [String : AnyObject]
                    wallet.changeAddress = WalletAddress(address: account["changeAddress"] as! String)
                    wallet.receiveAddresses.append(WalletAddress(address: account["receiveAddress"] as! String))
                    wallet.masterKey = account["accountKey"] as! String
                    wallet.coinType = coin
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
    
    func getAllWallets() {
    }
    
    var walletCount: Int {
        get{
            return realm.objects(CryptoWallet.self).count
        }
    }
    
    func getNumberOfWalletsFor(coin: String) -> Int {
        return realm.objects(CryptoWallet.self).filter("coinType == %@", coin).count
    }
    
    func getWalletsFor(coin: String) -> Results<CryptoWallet> {
        return realm.objects(CryptoWallet.self).filter("coinType == %@", coin)
    }
    
    func getWalletsOrderedByIndex() -> Results<CryptoWallet> {
        //Returns wallets by index from 0 to last
        return realm.objects(CryptoWallet.self).sorted(byKeyPath: "positionIndex")
    }
    
    func getCurrentFiatValue(){
        
    }
    
    func deleteWallet(wallet: CryptoWallet){
        try! realm.write {
            realm.delete(realm.objects(CryptoWallet.self).filter("id == %@", wallet.id))
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func importWallet(coin: String, masterKey: String) {
        switch coin {
        case "Bitcoin":
            break;
        default:
           print("Error")
        }
    }
}

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
    dynamic var coinType: String = "null"
    dynamic var name: String = "null"
    dynamic var masterKey: String = "null"
    dynamic var id: String = "null"
    dynamic var token = "null"
    dynamic var network = "null"

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


