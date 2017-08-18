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

    var coin: String!
    
    init(){
        self.coin = "Any"
        print("Realm URL: "+(realm.configuration.fileURL?.absoluteString)! + "\n\n")
    }
    
    init(coin: String) {
        self.coin = coin
        //print("Realm URL: "+(realm.configuration.fileURL?.absoluteString)!)

    }
    
    func submitTransaction(wallet: CryptoWallet, toAddress: String, amount: Double) -> Bool {
        
        if ((wallet.aggregateCoinValue() - amount) < 0) {
            return false
        }
        
        let tx = Transaction()
        tx.coinValue = amount - (2 * amount)
        
        let addr = Address()
        addr.value = toAddress
        
        tx.toAddress = addr
        try! realm.write {
            wallet.transactions.append(tx)
        }
        
        return true
    }
    
    func addWallet(name: String, coinType: String) {
        var wallet = CryptoWallet()
        wallet.name = name
        wallet.coinType = coinType
        wallet.id = String(arc4random())
        //wallet.positionIndex = walletCount + 1
        
        let duplicateWallets = realm.objects(CryptoWallet.self).filter("id == %@", wallet.id)
        
        if (duplicateWallets.count != 0) {
            print("Wallet input failed. Wallet with same id found")
        } else {
            try! realm.write {
                realm.add(wallet)
            }
        }
    }
    
    func getAllWallets(){
        
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
}

class Address: Object {
    dynamic var value: String = "null"
}

class Transaction: Object {
    dynamic var transactionId: String = "null"
    dynamic var coinValue: Double = -1.0
    dynamic var purchasedFiatValue: Double = -1.0
    dynamic var fiatType: String = "null"
    dynamic var dateSent: Date = Date()
    dynamic var toAddress: Address = Address()

}


class CryptoWallet: Object {
    dynamic var coinType: String = "null"
    dynamic var name: String = "null"
    dynamic var masterKey: String = "null"
    dynamic var id: String = "null"

    let addresses = List<Address>()
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
            if (self.addresses.contains(tx.toAddress)) {
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


