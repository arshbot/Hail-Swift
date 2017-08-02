//
//  DataSource.swift
//  Hail
//
//  Created by Harsha Goli on 7/31/17.
//  Copyright © 2017 Harsha Goli. All rights reserved.
//

import Foundation
import RealmSwift

class DataSource {
    
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
        return CryptoWallet()
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
    dynamic var purchaseFiatValue: Double = -1.0
    dynamic var fiatType: String = "null"
    dynamic var dateSent: Date = Date()
    dynamic var toAddress: String = "null"

}


class CryptoWallet: Object {
    dynamic var masterKey: String = "null"
    let addresses = List<Address>()
    let utxos = List<Transaction>()
    let sentTransactions = List<Transaction>()
    let positionIndex: Int = -1
}

class BitcoinWallet: CryptoWallet {
    
}
