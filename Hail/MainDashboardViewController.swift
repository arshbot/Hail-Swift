//
//  ViewController.swift
//  Hail
//
//  Created by Harsha Goli on 7/31/17.
//  Copyright © 2017 Harsha Goli. All rights reserved.
//

import UIKit

class MainDashboardViewController: UIViewController {

    //Begin IB Outlets
    @IBOutlet weak var walletCollectionView: UICollectionView!
    
    @IBAction func createWallet(_ sender: Any) {
        self.performSegue(withIdentifier: "NewWallet", sender: self)
    }
  
    @IBAction func newTx(_ sender: Any) {
        self.performSegue(withIdentifier: "NewTransaction", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walletCollectionView.delegate = walletCollectionView as! UICollectionViewDelegate
        walletCollectionView.dataSource = walletCollectionView as! UICollectionViewDataSource
        
        //Begin listening for notifications to reload the walletCollectionView
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func loadList(){
        self.walletCollectionView.reloadData()
    }
}

class walletCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let dataManager = DataManager()
    var isEmpty: Bool = false
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let num = dataManager.walletCount
        if (num == 0) {
            self.isEmpty = true
            return 1
        } else {
            isEmpty = false
            return num
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //If no wallets are present then present the noWalletCell view
        if (isEmpty){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noWalletCell", for: indexPath)
            return cell
        }
        
        let wallet = Array(dataManager.getWalletsOrderedByIndex().reversed())[indexPath.item]
        
        //Construct a different cell based on how many transactions are present
        switch wallet.transactions.count {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyWalletReusableCell", for: indexPath) as! emptyWalletReusableCell
                cell.wallet = wallet
                cell.coinType!.text = wallet.coinType
                cell.name.text = wallet.name
                cell.value.text = String(wallet.aggregateCoinValue())
                cell.txs.text = String(wallet.transactions.count)
                cell.network.text = wallet.network
                cell.id.text = wallet.id
                cell.fiatValue.text = String(wallet.aggregateFiatValue())
                cell.addr.text = wallet.receiveAddresses.first?.value
                return cell
            
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "singleTXWalletReusableCell", for: indexPath) as! singleTXWalletReusableCell
                cell.wallet = wallet
                cell.coinValueComprehensive.text = wallet.aggregateCoinValue().description
                cell.fiatValueComprehensive.text = wallet.aggregateFiatValue().description
                cell.TX1CoinValue.text = wallet.transactions.last?.coinValue.description
                cell.TX1FiatValue.text = wallet.transactions.last?.fiatType.description
                return cell

            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walletReusableCell", for: indexPath) as! walletReusableCell
                cell.wallet = wallet
                cell.coinValueComprehensive.text = wallet.aggregateCoinValue().description
                cell.fiatValueComprehensive.text = wallet.aggregateFiatValue().description
            
                let transactions: [Transaction] = wallet.popLastTwoTransactions()
                cell.TX1CoinValue.text = transactions[0].coinValue.description
                cell.TX1FiatValue.text = transactions[0].purchasedFiatValue.description
                cell.TX2CoinValue.text = transactions[1].coinValue.description
                cell.TX2FiatValue.text = transactions[1].purchasedFiatValue.description
                return cell
        }
    }
}

class walletReusableCell: UICollectionViewCell {
    
    //Begin Import things
    
    @IBOutlet weak var coinValueComprehensive: UILabel!
  
    @IBOutlet weak var fiatValueComprehensive: UILabel!
    
    @IBOutlet weak var TX1CoinValue: UILabel!
    
    @IBOutlet weak var TX1FiatValue: UILabel!
    
    @IBOutlet weak var TX2CoinValue: UILabel!

    @IBOutlet weak var TX2FiatValue: UILabel!
    
    @IBAction func deleteWallet(_ sender: Any) {
        dataManager.deleteWallet(wallet: wallet)
    }
    
    var wallet: CryptoWallet = CryptoWallet()
    
    let dataManager = DataManager()

    
}

class singleTXWalletReusableCell: UICollectionViewCell {

    @IBOutlet weak var coinValueComprehensive: UILabel!
    
    @IBOutlet weak var fiatValueComprehensive: UILabel!
    
    @IBOutlet weak var TX1CoinValue: UILabel!
    
    @IBOutlet weak var TX1FiatValue: UILabel!
    
    @IBAction func deleteWallet(_ sender: Any) {
        dataManager.deleteWallet(wallet: wallet)
    }
    
    var wallet: CryptoWallet = CryptoWallet()
    
    let dataManager = DataManager()

}



class emptyWalletReusableCell: UICollectionViewCell {
    
    @IBOutlet weak var coinType: UILabel!
    
    @IBAction func deleteWallet(_ sender: Any) {
        dataManager.deleteWallet(wallet: wallet)
    }
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var value: UILabel!
    
    @IBOutlet weak var txs: UILabel!

    @IBOutlet weak var network: UILabel!
    
    @IBOutlet weak var id: UILabel!
    
    @IBOutlet weak var fiatValue: UILabel!
    
    @IBOutlet weak var addr: UILabel!
    
    var wallet: CryptoWallet = CryptoWallet()
    
    let dataManager = DataManager()
}
