//
//  CardModel.swift
//  MatchGame
//
//  Created by Michael Shustov on 15.10.2021.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        // Declare an array
        var generatedCards = [Card]()
        
        // Randomly generate 8 pairs of cards
        while generatedCards.count < 16 {
            
            let randonNumber = Int.random(in: 1...13)
            
            if !generatedCards.contains(where: { card in
                card.imageName == "card\(randonNumber)"
            }) {
                
                let cardOne = Card()
                let cardTwo = Card()
                
                cardOne.imageName = "card\(randonNumber)"
                cardTwo.imageName = cardOne.imageName
                
                generatedCards += [cardOne, cardTwo]
                
                print(randonNumber)
            }
        }

        // Randomize cards in array
        generatedCards.shuffle()
        
        // Return the array
        return generatedCards
    }
}
