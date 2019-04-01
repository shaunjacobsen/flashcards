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
  
  //
  // MARK: - IBOutlets
  //
  
  @IBOutlet weak var startReviewButton: UIButton!
  @IBOutlet weak var cardTable: UITableView!
  @IBAction func handleTouchNewCardButton(_ sender: UIButton) {
    performSegue(withIdentifier: "goToAddNewCardSegue", sender: self)
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
    startReviewButton.layer.shadowPath = UIBezierPath(roundedRect: startReviewButton.bounds, cornerRadius: startReviewButton.layer.cornerRadius).cgPath
    startReviewButton.layer.shadowColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.12).cgColor
    startReviewButton.layer.shadowOpacity = 0.12
    startReviewButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    startReviewButton.layer.shadowRadius = 0
    startReviewButton.layer.masksToBounds = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if let deckName = selectedDeck?.name {
      self.navigationController?.title = deckName
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
    cards = selectedDeck?.cards.sorted(byKeyPath: "nextAppearanceOn", ascending: true)
    
  }

  
}
