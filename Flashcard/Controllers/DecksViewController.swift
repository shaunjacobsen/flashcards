//
//  ViewController.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 3/30/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit
import RealmSwift

class DecksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  let realm = try! Realm()
  
  var decks: Results<Deck>!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadItems()
    
    tableView.register(UINib(nibName: "DeckCell", bundle: nil), forCellReuseIdentifier: "DeckCell")
    tableView.separatorStyle = .none
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 100
    
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController?.navigationBar.shadowImage = UIImage()
    
    var fontDescriptor = UIFontDescriptor(name: "HKGrotesk-Bold", size: 34)
    
    let navigationAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(descriptor: fontDescriptor, size: 34), NSAttributedString.Key.foregroundColor: UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)]
    self.navigationController?.navigationBar.largeTitleTextAttributes = navigationAttributes
  }
  
  //
  // MARK: - Tableview methods
  //
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DeckCell", for: indexPath) as! DeckCell
    
    cell.deckLabel.text = decks[indexPath.row].name
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return decks.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToDeckSegue", sender: self)
    
    self.tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //
  // MARK: - Data manipulation
  //
  
  func loadItems() {
    decks = realm.objects(Deck.self)
    
    tableView.reloadData()
  }
  
  //
  // MARK: - IBActions
  //
  
  @IBAction func handleTouchAddButton(_ sender: Any) {
    performSegue(withIdentifier: "goToAddDeckSegue", sender: self)
  }
  
  
  //
  // MARK: - Navigation
  //
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if segue.identifier == "goToDeckSegue" {
      let destinationVC = segue.destination as! DeckViewController
      
      if let indexPath = tableView.indexPathForSelectedRow {
        destinationVC.selectedDeck = decks?[indexPath.row]
      }
    }
    
  }


}

