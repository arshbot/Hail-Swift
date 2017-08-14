//
//  ViewController.swift
//  Hail
//
//  Created by Harsha Goli on 7/31/17.
//  Copyright © 2017 Harsha Goli. All rights reserved.
//

import UIKit

class WorldViewController: UIViewController {

    //Begin Import things
    
    @IBOutlet weak var walletCollectionView: UICollectionView!
    
    @IBAction func createWallet(_ sender: Any) {
        print("HELLO")
        self.performSegue(withIdentifier: "NewWallet", sender: self)
    }
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        walletCollectionView.delegate = walletCollectionView as! UICollectionViewDelegate
        walletCollectionView.dataSource = walletCollectionView as! UICollectionViewDataSource
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func loadList(){
        //load data here
        self.walletCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class walletCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let dataManager = DataManager(coin: "All")
    let nodeManager = NodeManager(coin: "Bitcoin")
    //var wallets:[NSObject] = []
    var isEmpty: Bool = false
    var runCount = 0
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let num = dataManager.walletCount
        if (num == 0) {
            self.isEmpty = true
            return 1
        }
        return num
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        runCount+=1

        
        if (isEmpty){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noWalletCell", for: indexPath)
            return cell
        }
        //let index = dataManager.walletCount - indexPath.item - 1
        let wallet = Array(dataManager.getWalletsOrderedByIndex().reversed())[indexPath.item]
        switch wallet.transactions.count {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyWalletReusableCell", for: indexPath) as! emptyWalletReusableCell
                cell.coinType!.text = wallet.coinType
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
    
    let dataManager = DataManager(coin: "All")

    
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
    
    let dataManager = DataManager(coin: "All")

}



class emptyWalletReusableCell: UICollectionViewCell {
    
    @IBOutlet weak var coinType: UILabel!
    
    @IBAction func deleteWallet(_ sender: Any) {
        dataManager.deleteWallet(wallet: wallet)
    }
    
    var wallet: CryptoWallet = CryptoWallet()
    
    let dataManager = DataManager(coin: "All")
}
