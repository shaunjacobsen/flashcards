//
//  ReviewDeckViewController.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 4/16/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit

let screenSize = UIScreen.main.bounds
let SEPARATOR_DISTANCE = 8
let MAX_BUFFER_SIZE = 1

class ReviewDeckViewController: UIViewController {
  
  var selectedDeck: Deck?
  var allSwipeableCards: [SwipeableCard] = []
  var swipeableCards: [SwipeableCard] = []
  var currentIndex = 0
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let deck = selectedDeck {
      let capCount = (deck.cards.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : deck.cards.count
      for (i, card) in deck.cards.enumerated() {
        let newCard = createCard(from: card)
        allSwipeableCards.append(newCard)
        if i < capCount {
          swipeableCards.append(newCard)
        }
      }
      
      for (i, _) in swipeableCards.enumerated() {
        if i > 0 {
          view.insertSubview(swipeableCards[i], belowSubview: swipeableCards[i - 1])
        } else {
          view.addSubview(swipeableCards[i])
        }
      }
      
      animateCardAfterSwiping()
      
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  //
  // MARK: - New card
  //
  
  func createCard(from card: Card) -> SwipeableCard {
    let cardView = SwipeableCard()
    cardView.frame = CGRect(x: 40, y: 100, width: screenSize.width - 80, height: screenSize.height - 220)
    cardView.backgroundColor = UIColor.white
    cardView.mainLabel.text = card.questionText
    cardView.secondaryLabel.text = card.questionNotes
    cardView.frontLabel = card.questionText
    cardView.frontNotes = card.questionNotes
    cardView.rearLabel = card.answerText
    cardView.rearNotes = card.answerNotes
    cardView.layer.shadowColor = UIColor.black.cgColor
    cardView.layer.shadowOpacity = 0.11
    cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
    cardView.layer.shadowRadius = 14
    cardView.layer.cornerRadius = 12
    cardView.swipeDelegate = self
    cardView.tapDelegate = self
    cardView.isUserInteractionEnabled = false
    cardView.addGestureRecognizer(cardView.panGestureRecognizer)
    cardView.addGestureRecognizer(cardView.tapGestureRecognizer)
    
    
    return cardView
  }
  
  func dismissIfNoFurtherCards() {
    if swipeableCards.isEmpty {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  func removeCardAndAppendNew() {
    swipeableCards.remove(at: 0)
    currentIndex = currentIndex + 1
    
    if (currentIndex + swipeableCards.count) < allSwipeableCards.count {
      let card = allSwipeableCards[currentIndex + swipeableCards.count]
      var frame = card.frame
      card.layer.opacity = 0
      frame.origin.y = 100
      card.frame = frame
      swipeableCards.append(card)
      view.insertSubview(swipeableCards[MAX_BUFFER_SIZE - 1], belowSubview: swipeableCards[MAX_BUFFER_SIZE - 1])
    }
    animateCardAfterSwiping()
  }
  
  func animateCardAfterSwiping() {
    for (i, card) in swipeableCards.enumerated() {
      UIView.animate(withDuration: 0.5, animations: {
        if i == 0 {
          card.isUserInteractionEnabled = true
        }
        card.layer.opacity = 100
      })
    }
  }

}

extension ReviewDeckViewController: SwipeableCardDelegate {
  func cardMovement(card: SwipeableCard) {
    animateCardAfterSwiping()
    removeCardAndAppendNew()
    dismissIfNoFurtherCards()
  }
  
  func cardWentLeft(card: SwipeableCard) {
    print("Card went left")
  }
  
  func cardWentRight(card: SwipeableCard) {
    print("Card went right")
  }
  
  func cardWentUp(card: SwipeableCard) {
    print("Card went up and away")
  }
  
  func currentCardStatus(card: SwipeableCard, distance: CGFloat) {
    
  }
  
}

extension ReviewDeckViewController: TappableCardDelegate {
  func cardTapped(card: SwipeableCard) {
    print("Tapped")
  }
  
  
}
