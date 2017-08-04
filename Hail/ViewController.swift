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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class walletCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    let dataManager = DataManager(coin: "All")
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var num = dataManager.getNumberOfWallets
        //print(num)
        return dataManager.getNumberOfWallets()
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walletReusableCell", for: indexPath) as! walletReusableCell
        
        let wallet = dataManager.getWalletAtPosition(index: indexPath.row)
        
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

class walletReusableCell: UICollectionViewCell {
    
    //Begin Import things
    
    @IBOutlet weak var coinValueComprehensive: UILabel!
  
    @IBOutlet weak var fiatValueComprehensive: UILabel!
    
    @IBOutlet weak var TX1CoinValue: UILabel!
    
    @IBOutlet weak var TX1FiatValue: UILabel!
    
    @IBOutlet weak var TX2CoinValue: UILabel!

    @IBOutlet weak var TX2FiatValue: UILabel!
    
    
}
