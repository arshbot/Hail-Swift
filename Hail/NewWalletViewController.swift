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
    
    @IBOutlet weak var litecoinSelectedHue: UIView!
    
    @IBOutlet weak var bitcoinSelectedHue: UIView!
    
    var coinType: String = "null"
    
    let dataManager = DataManager()
    
    @IBOutlet weak var walletNameField: UITextField!

    @IBOutlet weak var importWalletMasterKeyField: UITextField!
    
    
    
    @IBAction func importWallet(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            let name = self.walletNameField.text
            let masterkey = self.importWalletMasterKeyField.text
            let coinType = self.coinType
            
        })
    }
    
    @IBAction func newWalletCreated(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            let name = self.walletNameField.text
            let coinType = self.coinType
            self.dataManager.addWallet(name: name!, coinType: coinType)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)

        })
        
    }
    
    
    @IBAction func bitcoinSelected(_ sender: Any) {
        selectCoin(coin: "Bitcoin")
        //self.performSegue(withIdentifier: "NewWallet", sender: self)

    }
    
    @IBAction func litecoinSelected(_ sender: Any) {
        selectCoin(coin: "Litecoin")

        //self.performSegue(withIdentifier: "NewWallet", sender: self)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        litecoinSelectedHue.backgroundColor = UIColor.clear
        bitcoinSelectedHue.backgroundColor = UIColor.clear
    }
    
    func selectCoin(coin: String) {
        litecoinSelectedHue.backgroundColor = UIColor.clear
        bitcoinSelectedHue.backgroundColor = UIColor.clear
        coinType = coin
        if(coin == "Bitcoin") {
            bitcoinSelectedHue.backgroundColor = UIColor.blue
        }
        else if (coin == "Litecoin") {
            litecoinSelectedHue.backgroundColor = UIColor.blue
        }
        
    }
    
}
