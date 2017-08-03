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
    
    
    
    let dataSrc = DataSource(coin: "All")
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var num = dataSrc.getNumberOfWallets
        //print(num)
        return dataSrc.getNumberOfWallets()
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walletReusableCell", for: indexPath) as! walletReusableCell
        
        let wallet = dataSrc.getWalletAtPosition(index: indexPath.row)
        
        cell.btcValueOverall.text = wallet.aggregateCoinValue().description
        cell.fiatValueOverall.text = indexPath.row.description
        cell.btcValueRow1.text = indexPath.row.description
        cell.fiatValueRow1.text = indexPath.row.description
        cell.btcValueRow2.text = indexPath.row.description
        cell.fiatValueRow2.text = indexPath.row.description
        
        return cell
    }
    
}

class walletReusableCell: UICollectionViewCell {
    
    //Begin Import things
    
    @IBOutlet weak var btcValueOverall: UILabel!
    
    @IBOutlet weak var fiatValueOverall: UILabel!
    
    @IBOutlet weak var btcValueRow1: UILabel!
    
    @IBOutlet weak var fiatValueRow1: UILabel!
    
    @IBOutlet weak var btcValueRow2: UILabel!
    
    @IBOutlet weak var fiatValueRow2: UILabel!
    
    
}
