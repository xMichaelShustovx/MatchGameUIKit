//
//  ViewController.swift
//  MatchGame
//
//  Created by Michael Shustov on 15.10.2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex: IndexPath?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardArray = model.getCards()
        
        // Set the view controller as the data source and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Return the number of cells
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Return cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Configure the state of the cell based on the properties of the Card that it represents
        
        let cardCell = cell as? CardCollectionViewCell
        
        // Configure cell
        cardCell?.configureCell(card: cardArray[indexPath.row])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Get the reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            
            // Flip the card up
            cell?.flipUp(speed: 0.3)
            
            // Check if it is the first card that was flipped or the second card
            if firstFlippedCardIndex == nil {
                
                // It's the first card
                firstFlippedCardIndex = indexPath
                
            }
            else {
             
                // It's the second card
                // Run comparison game logic
                checkForMatch(indexPath)
                
            }
        }
    }
    
    // MARK: - Game Logic
    func checkForMatch(_ secondFlippedCardIndex: IndexPath) {
        
        // Get the two card objects for the two indicies and see if they match
        let firstCard = cardArray[firstFlippedCardIndex!.row]
        let secondCard = cardArray[secondFlippedCardIndex.row]
        
        // Get the two collection view cells that represent card one and two
        let firstCardCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let secondCardCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Compare cards
        if firstCard.imageName == secondCard.imageName {
            
            // It's a match
            
            // Set the status and remove them
            firstCard.isMatched = true
            secondCard.isMatched = true
            
            firstCardCell?.remove()
            secondCardCell?.remove()
            
        }
        else {
            
            // It's not a match
            
            // Flip them back over
            firstCardCell?.flipDown()
            secondCardCell?.flipDown()
            
        }
        
        // Reset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
}

