//
//  ReviewDeckViewController.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 4/16/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit
import RealmSwift

let screenSize = UIScreen.main.bounds
let SEPARATOR_DISTANCE = 8
let MAX_BUFFER_SIZE = 1

class ReviewDeckViewController: UIViewController {
  
  let realm = try! Realm()
  
  var selectedDeck: Deck?
  var cardsForReview: [Card]?
  var allSwipeableCards: [SwipeableCard] = []
  var swipeableCards: [SwipeableCard] = []
  var currentIndex = 0
  
  @IBOutlet weak var progressBar: UIView!
  @IBOutlet weak var progressBarColored: UIView!
  @IBOutlet weak var progressBarColoredTrailingConstraint: NSLayoutConstraint!
  
  @IBAction func handleTapCloseButton(_ sender: UIButton) {
    let alertController = UIAlertController(title: "Exit Review?", message: "Are you sure you'd like to quit your review? Your progress up until this point is saved.", preferredStyle: .alert)
    let yesAction = UIAlertAction(title: "Yes, exit", style: .cancel) { (_) in
      self.dismiss(animated: true, completion: nil)
    }
    let cancelAction = UIAlertAction(title: "No, keep reviewing", style: .default, handler: nil)
    alertController.addAction(yesAction)
    alertController.addAction(cancelAction)
    present(alertController, animated: true)
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let cards = cardsForReview {
      let capCount = (cards.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : cards.count
      for (i, card) in cards.enumerated() {
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
      
      print("allSwipeableCards (\(allSwipeableCards.count)): \(allSwipeableCards)")
      print("swipeableCards (\(swipeableCards.count)): \(swipeableCards)")
      
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    progressBar.layer.cornerRadius = 6
    progressBarColored.layer.cornerRadius = 6
    progressBarColoredTrailingConstraint.constant = self.progressBar.frame.width
    view.layoutIfNeeded()

  }
  
  //
  // MARK: - New card
  //
  
  func createCard(from card: Card) -> SwipeableCard {
    let cardView = SwipeableCard()
    cardView.card = card
    cardView.frame = CGRect(x: 40, y: 120, width: screenSize.width - 80, height: screenSize.height - 220)
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
    cardView.addGestureRecognizer(cardView.longPressGestureRecognizer)
    
    
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
    refreshProgressBar()
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
  
  func refreshProgressBar() {
    let widthOfProgressPlaceholder = progressBar.frame.width
    let totalCards = self.allSwipeableCards.count
    let spaceToOccupy = (widthOfProgressPlaceholder / CGFloat(totalCards)) * CGFloat(totalCards - self.currentIndex)
    UIView.animate(withDuration: 0.3) {
      self.progressBarColoredTrailingConstraint.constant = spaceToOccupy
      
      self.view.layoutIfNeeded()
    }
  }

}

extension ReviewDeckViewController: SwipeableCardDelegate {
  func cardMovement(card: Card) {
    animateCardAfterSwiping()
    removeCardAndAppendNew()
    dismissIfNoFurtherCards()
  }
  
  func cardWentLeft(card: Card) {
    let calculator = SpacedRepetitionCalculator()
    let next = calculator.calculateNextReview(assessment: .hard, card: card)
    debugPrint(next.nextReview, next.progress)
    savePerformance(card: card, cardPerformance: next)
  }
  
  func cardWentRight(card: Card) {
    let calculator = SpacedRepetitionCalculator()
    let next = calculator.calculateNextReview(assessment: .easy, card: card)
    debugPrint(next.nextReview, next.progress)
    savePerformance(card: card, cardPerformance: next)
  }
  
  func cardWentUp(card: Card) {
    let calculator = SpacedRepetitionCalculator()
    let next = calculator.calculateNextReview(assessment: .fair, card: card)
    debugPrint(next.nextReview, next.progress)
    savePerformance(card: card, cardPerformance: next)
  }
  
  func currentCardStatus(card: Card, distance: CGFloat) {
    
  }
  
  func savePerformance(card: Card, cardPerformance: CardPerformance) {
    do {
      try self.realm.write {
        card.progress = cardPerformance.progress
        card.nextReview = cardPerformance.nextReview
        card.lastReview = cardPerformance.timestamp
      }
    } catch {
      print("Error saving to Realm: \(error)")
    }
  }
  
}

extension ReviewDeckViewController: TappableCardDelegate {
  func cardTapped(card: SwipeableCard) {
    print("Tapped")
  }
  
  func cardLongPressed(card: SwipeableCard) {
    print("Long press")
  }
  
}
