//
//  ViewController.swift
//  MatchGame
//
//  Created by Michael Shustov on 15.10.2021.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cardArray = [Card]()
    
    var timer: Timer?
    var milliseconds: Int = 100 * 1000
    
    var firstFlippedCardIndex: IndexPath?
    
    var soundPlayer = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardArray = model.getCards()
        
        // Set the view controller as the data source and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Initialize the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
    }
    
    //MARK: - Timer Methods
    @objc func timerFired() {
        
        // Decrement the counter
        milliseconds -= 1
        
        // Update the label
        let seconds: Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        
        // Stop the timer if it reaches zero
        if milliseconds == 0 {
            
            timerLabel.textColor = UIColor.red
            
            timer?.invalidate()
            
            // Check if the user has cleared all the cards
            checkForGameEnd()
        }
        
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
        
        // Check if the game still running
        if milliseconds <= 0 {
            return
        }
        
        // Get the reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            
            // Flip the card up
            cell?.flipUp(speed: 0.3)
            
            // Play the flip sound
            soundPlayer.playSound(effect: .flip)
            
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
            
            // Play match sound
            soundPlayer.playSound(effect: .match)
            
            // Set the status and remove them
            firstCard.isMatched = true
            secondCard.isMatched = true
            
            firstCardCell?.remove()
            secondCardCell?.remove()
            
            // Was that the last pair
            checkForGameEnd()
            
        }
        else {
            
            // It's not a match
            
            // Play nomatch sound
            soundPlayer.playSound(effect: .nomatch)
            
            // Flip them back over
            firstCardCell?.flipDown()
            secondCardCell?.flipDown()
            
        }
        
        // Reset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
    
    func checkForGameEnd() {
        
        var hasWon = true
        
        // Check if it's any unmatched cards
        for card in cardArray {
            
            if !card.isMatched {
                
                hasWon = false
                
                break
                
            }
        }
        
        if hasWon {
            
            // User has won, show the alert
            timer?.invalidate()
            
            showAlert(title: "Congratulations!", message: "You've won the game!")
        }
        else {
            
            // User hasn't won yet, check if there is time left
            if milliseconds <= 0 {
                
                showAlert(title: "Sorry...", message: "You'll succeed next time for sure!")
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok!", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
}

