//
//  ViewController.swift
//  MatchGame
//
//  Created by Michael Shustov on 15.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let model = CardModel()
    var cardArray = [Card]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardArray = model.getCards()
    }

}

