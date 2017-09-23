//
//  NewWalletViewController.swift
//  Hail
//
//  Created by Harsha Goli on 8/3/17.
//  Copyright © 2017 Harsha Goli. All rights reserved.
//

import Foundation
import UIKit

class NewWalletViewController: UIViewController {
    
    //Begin IB outlets
    @IBOutlet weak var litecoinSelectedHue: UIView!
    
    @IBOutlet weak var bitcoinSelectedHue: UIView!
    
    @IBOutlet weak var walletNameField: UITextField!

    @IBOutlet weak var importWalletMasterKeyField: UITextField!
    
    @IBAction func importWallet(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            //TODO: Implement import logic
            let name = self.walletNameField.text
            let masterkey = self.importWalletMasterKeyField.text
            let network = self.network
            
        })
    }
    
    @IBAction func testnetSwitch(_ sender: Any) {
        self.isTestnet = !self.isTestnet
    }
    
    /***NETWORK CODES***
     
        BTC MAINNET
        BTC TESTNET
        LTC MAINNET
        LTC TESTNET
     
    */
    
    @IBAction func newWalletCreated(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            if(self.isTestnet) {
                self.network = self.network + " TESTNET"
            } else {
                self.network = self.network + " MAINNET"
            }
            self.dataManager.addWallet(name: self.walletNameField.text!, network: self.network)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        })
    }
    
    @IBAction func bitcoinSelected(_ sender: Any) {
        selectCoin(network: "BTC")
    }
    
    @IBAction func litecoinSelected(_ sender: Any) {
        selectCoin(network: "LTC")
    }
    
    var isTestnet: Bool = false
    
    var network: String = "null"
    
    let dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        litecoinSelectedHue.backgroundColor = UIColor.clear
        bitcoinSelectedHue.backgroundColor = UIColor.clear
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func selectCoin(network: String) {
        litecoinSelectedHue.backgroundColor = UIColor.clear
        bitcoinSelectedHue.backgroundColor = UIColor.clear
        self.network = network
        if(network == "BTC") {
            bitcoinSelectedHue.backgroundColor = UIColor.blue
        }
        else if (network == "LTC") {
            litecoinSelectedHue.backgroundColor = UIColor.blue
        }
    }
}
