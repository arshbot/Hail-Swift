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
        print("Realm URL: "+(realm.configuration.fileURL?.absoluteString)!)
    }
    
    init(coin: String) {
        self.coin = coin
        print("Realm URL: "+(realm.configuration.fileURL?.absoluteString)!)

    }
    
    func addWallet(name: String, coinType: String) {
        var wallet = CryptoWallet()
        wallet.name = name
        wallet.coinType = coinType
        wallet.id = String(arc4random())
        //wallet.positionIndex = walletCount + 1
        try! realm.write {
            realm.add(wallet)
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
    
    func getWalletAt(index: Int) -> CryptoWallet{
        let dummyWallet = CryptoWallet()
        
        //Load dummy tx data
        let tx = Transaction()
        tx.transactionId = "sdkljfID"
        tx.coinValue = 100
        tx.purchasedFiatValue = 100000
        tx.fiatType = "USD"
        tx.dateSent = Date()
        tx.toAddress = "ME"
        
        let tx2 = Transaction()
        tx2.transactionId = "ljkhakljsdhfID"
        tx2.coinValue = 14
        tx2.purchasedFiatValue = 1444
        tx2.fiatType = "USD"
        tx2.dateSent = Date()
        tx2.toAddress = "HKJkhhJBhknJJklmlp"
        
        dummyWallet.transactions.append(tx)
        dummyWallet.transactions.append(tx2)
        
        dummyWallet.positionIndex = index
        return dummyWallet
    }
    
    func getCurrentFiatValue(){
        
    }
    
    func deleteWallet(wallet: CryptoWallet){
        realm.delete(realm.objects(CryptoWallet))
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
    dynamic var toAddress: String = "null"

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
    
    func aggregateCoinValue() -> Double {
        let txs = self.transactions
        var total = 0.0
        for t in txs {
            total += t.coinValue
        }
        return total
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


