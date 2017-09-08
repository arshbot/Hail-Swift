//
//  ReceiveTransactionViewController.swift
//  Hail
//
//  Created by Harsha Goli on 8/29/17.
//  Copyright © 2017 Harsha Goli. All rights reserved.
//

import Foundation
import UIKit

class ReceiveTransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Begin IB outlets
    @IBOutlet weak var walletSelectionTableView: UITableView!
    
    @IBAction func generateAddress(_ sender: Any) {
        if (selectedWallet.name == "null") {
            let alert = UIAlertController(title: "Alert", message: "Please select a wallet", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.dataManager.getNewAddressfor(id: selectedWallet.id, network: selectedWallet.network, completionHandler: {
            returnedAddr in
            self.addressLabel.text = returnedAddr.value
        })
    }
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    let dataManager = DataManager()

    var wallets:[CryptoWallet] = []
    
    var selectedWallet = CryptoWallet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressLabel.text = ""
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
        cell.coinType.text = wallet.network
        cell.coinValue.text = String(wallet.aggregateCoinValue())
        return cell
    }
    
}
