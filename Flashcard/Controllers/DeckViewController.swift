//
//  DeckViewController.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 3/30/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit
import RealmSwift

class DeckViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var cards: Results<Card>?
  var cardsForReview: [Card]?
  
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
        startReviewLabel.text = String(describing: cardsForReview!.count)
      } else {
        startReviewButton.isEnabled = false
        startReviewLabel.font = UIFont.init(name: "Helvetica", size: 36.0)
        startReviewLabel.text = "🏅"
        startReviewAuxLabel.font = UIFont.init(name: "HK Grotesk", size: 28.0)
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
    
    let card = cards?[indexPath.row]
    
    cell.cardName.text = card?.questionText
    
    return cell
  }
  
  //
  // MARK: - Data source methods
  //
  
  func loadItems() {
    cards = selectedDeck?.cards.sorted(byKeyPath: "nextReview", ascending: true)
    
  }
  
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
