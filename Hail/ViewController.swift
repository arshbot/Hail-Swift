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
    
    @IBOutlet weak var walletCollectionViewCell: walletReusableCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class walletCollectionView: UICollectionView {
    
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
