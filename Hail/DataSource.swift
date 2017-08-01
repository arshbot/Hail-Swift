//
//  DataSource.swift
//  Hail
//
//  Created by Harsha Goli on 7/31/17.
//  Copyright © 2017 Harsha Goli. All rights reserved.
//

import Foundation
import Realm

class DataSource {
    func getAllWallets(){
        
    }
}

class Transaction: Object {
    
}

class UnspentTransactionOutputs: Object {
    dynamic var coinValue: Double
    dynamic var dateSent: Date
    dynamic var transactionId: String
}

class CryptoWallet: Object {
    dynamic var masterKey: String
    let addresses = List<String>()
    let utxos = List<UnspentTransactionOutputs>()
    let sentTransactions = List
}
