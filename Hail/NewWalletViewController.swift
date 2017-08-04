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
    
    @IBAction func newWalletName(_ sender: Any) {
    }
    
    @IBAction func bitcoinSelected(_ sender: Any) {
        self.performSegue(withIdentifier: "NewWallet", sender: self)

    }
    
    @IBAction func litecoinSelected(_ sender: Any) {
        self.performSegue(withIdentifier: "NewWallet", sender: self)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
