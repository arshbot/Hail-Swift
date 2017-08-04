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
    
    var coin: String!
    
    init(){
        self.coin = "Any"
    }
    
    init(coin: String) {
        self.coin = coin
    }
    
    func getAllWallets(){
        
    }
    
    func getTotalNumberOfWallets() -> Int {
        return 2
    }
    
    func getNumberOfWallets() -> Int {
        return 3
        
    }
    
    func getWalletAtPosition(index: Int) -> CryptoWallet{
        let dummyWallet = CryptoWallet()
        
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
    dynamic var masterKey: String = "null"
    let addresses = List<Address>()
    //let utxos = List<Transaction>()
    let transactions = List<Transaction>()
    var positionIndex: Int = -1
    
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
}


