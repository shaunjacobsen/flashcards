//
//  DeckViewController.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 3/30/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftDate

class DeckViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var cards: Results<Card>?
  var cardsForReview: [Card]?
  let now = DateInRegion()
  
  //
  // MARK: - IBOutlets
  //
  
  @IBOutlet weak var startReviewButton: UIButton!
  @IBOutlet weak var labelsStackView: UIStackView!
  @IBOutlet weak var startReviewLabel: UILabel!
  @IBOutlet weak var startReviewAuxLabel: UILabel!
  @IBOutlet weak var cardTable: UITableView!
  
  @IBAction func handleTouchNewCardButton(_ sender: UIButton) {
    performSegue(withIdentifier: "goToAddNewCardSegue", sender: self)
  }
  
  @IBAction func handleTouchReviewDeckButton(_ sender: UIButton) {
    performSegue(withIdentifier: "goToReviewDeckSegue", sender: self)
  }
  
  var selectedDeck: Deck? {
    didSet {
      loadItems()
    }
  }

  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    cardTable.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
    cardTable.separatorStyle = .none
    cardTable.rowHeight = UITableView.automaticDimension
    cardTable.estimatedRowHeight = 50

    startReviewButton.layer.cornerRadius = 6
    startReviewButton.layer.shadowColor = UIColor.black.cgColor
    startReviewButton.layer.shadowOpacity = 0.11
    startReviewButton.layer.shadowOffset = CGSize(width: 0, height: 3)
    startReviewButton.layer.shadowRadius = 8
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    if let deck = selectedDeck {
      self.navigationController?.title = deck.name
      self.navigationItem.title = deck.name
      
      labelsStackView.isUserInteractionEnabled = false
      
      let timestamp = Date()
      cardsForReview = Array(deck.cards).filter { $0.nextReview < timestamp }
      
      if cardsForReview!.count > 0 {
        startReviewButton.isEnabled = true
        startReviewLabel.font = UIFont.init(name: "HKGrotesk-Bold", size: 48.0)
        startReviewLabel.text = String(describing: cardsForReview!.count)
        if cardsForReview!.count == 1 {
          startReviewAuxLabel.text = "card to review"
        } else {
          startReviewAuxLabel.text = "cards to review"
        }
      } else {
        startReviewButton.isEnabled = false
        startReviewLabel.font = UIFont.init(name: "Helvetica", size: 36.0)
        startReviewLabel.text = "🏅"
        startReviewAuxLabel.font = UIFont.init(name: "HKGrotesk-Medium", size: 28.0)
        startReviewAuxLabel.adjustsFontSizeToFitWidth = true
        startReviewAuxLabel.text = "You're all caught up!"
      }
      
    }
    
    if selectedDeck !== nil {
      self.cardTable.reloadData()
    }
  }

  //
  // MARK: - Table view methods
  //
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cards?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
    
    if let card = cards?[indexPath.row] {
      let nextReviewDate = DateInRegion(card.nextReview)
      let colloquialDate = nextReviewDate.toRelative()
      cell.cardName.text = card.questionText
      
      if nextReviewDate.isInPast {
        cell.cardAuxLabel.textColor = UIColor(red: 0.72, green: 0.91, blue: 0.53, alpha: 1.0)
        cell.cardAuxLabel.text = "ready to review"
      } else {
        cell.cardAuxLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        cell.cardAuxLabel.text = "next review \(colloquialDate)"
      }
      
      
    }
    
    
    
    return cell
  }
  
  //
  // MARK: - Data source methods
  //
  
  func loadItems() {
    cards = selectedDeck?.cards.sorted(byKeyPath: "nextReview", ascending: true)
  }
  
//  func displayNextReviewDateFrom(duration: Duration) -> String {
//    let seconds = duration.seconds
//    switch seconds {
//    case -1...86400:
//      return "\(ceil(seconds / 60).rounded()) minutes"
//    default:
//      return ""
//    }
//  }
  
  //
  // MARK: - Navigation
  //
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToAddNewCardSegue" {
      let destinationVC = segue.destination as! AddCardViewController
      if let deck = selectedDeck {
        destinationVC.selectedDeck = deck
      }
    }
    
    if segue.identifier == "goToReviewDeckSegue" {
      let destinationVC = segue.destination as! ReviewDeckViewController
      if let deck = selectedDeck {
        destinationVC.selectedDeck = deck
        destinationVC.cardsForReview = cardsForReview
      }
    }
  }

  
}
