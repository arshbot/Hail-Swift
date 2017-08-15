//
//  NewTransactionViewController.swift
//  Hail
//
//  Created by Harsha Goli on 8/15/17.
//  Copyright © 2017 Harsha Goli. All rights reserved.
//

import Foundation
import UIKit

class NewTransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var destination: UITextField!
    
    @IBOutlet weak var amount: UITextField!
    
    @IBAction func sendTx(_ sender: Any) {
        if selectedWallet.name == "null" {
            let alert = UIAlertController(title: "Alert", message: "Please select a wallet", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (destination.text == nil) {
            let alert = UIAlertController(title: "Alert", message: "Please specify a destination", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (amount.text == nil) {
            let alert = UIAlertController(title: "Alert", message: "Please enter a number for the amount", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            do {
                let _ = Double(amount.text!)
            } catch _ {
                let alert = UIAlertController(title: "Alert", message: "Please enter a number for the amount", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            dataManager.submitTransaction(wallet: selectedWallet, destinationAddr: destination.text!, amount: Double(amount.text!)!)
        }
    }
    
    @IBOutlet weak var walletSelectionTableView: UITableView!
    
    let dataManager = DataManager(coin: "All")
    
    var wallets:[CryptoWallet] = []
    
    var selectedWallet = CryptoWallet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walletSelectionTableView.delegate = self
        walletSelectionTableView.dataSource = self
        self.wallets = Array(dataManager.getWalletsOrderedByIndex().reversed())
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWallet = wallets[indexPath.item]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.walletCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wallet = wallets[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletSelectionReusableCell", for: indexPath) as! walletSelectionReusableCell
        cell.name.text = wallet.name
        cell.coinType.text = wallet.coinType
        cell.coinValue.text = String(wallet.aggregateCoinValue())
        return cell
    }
}

class walletSelectionReusableCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var coinType: UILabel!
    
    @IBOutlet weak var coinValue: UILabel!
}
