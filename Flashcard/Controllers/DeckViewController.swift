//
//  DeckViewController.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 3/30/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit
import RealmSwift

class DeckViewController: UITableViewController {
  
  var cards: Results<Card>?
  
  var selectedDeck: Deck? {
    didSet {
      loadItems()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
    return 0
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
    return 0
  }
  
  // MARK: - Data source methods
  
  func loadItems() {
    cards = selectedDeck?.cards.sorted(byKeyPath: "nextAppearanceOn", ascending: true)
    
    tableView.reloadData()
  }

  
}
