//
//  ReviewDeckViewController.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 4/16/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit

let screenSize = UIScreen.main.bounds

class ReviewDeckViewController: UIViewController {
  
  var selectedDeck: Deck?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let deck = selectedDeck {
      if let firstCard = deck.cards.first {
        let newCard = createCard(from: firstCard)
        view.addSubview(newCard)
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
          newCard.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 40),
          newCard.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 40),
          newCard.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: 40),
          newCard.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: 80),
          ])
      }
    }
    
  }
  
  //
  // MARK: - New card
  //
  
  func createCard(from card: Card) -> SwipeableCard {
    let cardView = SwipeableCard() as SwipeableCard
    cardView.frame = CGRect(x: 40, y: 100, width: screenSize.width - 80, height: screenSize.height - 220)
    cardView.mainLabel.text = card.questionText
    cardView.secondaryLabel.text = card.questionNotes
    cardView.layer.shadowColor = UIColor.black.cgColor
    cardView.layer.shadowOpacity = 0.11
    cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
    cardView.layer.shadowRadius = 14
    
    return cardView
  }

}
