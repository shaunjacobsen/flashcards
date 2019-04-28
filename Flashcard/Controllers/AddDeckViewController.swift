//
//  AddDeckViewController.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 3/30/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit
import RealmSwift

class AddDeckViewController: UIViewController, UITextFieldDelegate {
  
  let realm = try! Realm()
  
  let newDeck = Deck()

  //
  // MARK: - IBOutlets
  //
  
  @IBOutlet weak var textFieldView: UIView!
  @IBOutlet weak var textField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textField.layer.borderWidth = 0
    textFieldView.layer.cornerRadius = 6
    textFieldView.layer.shadowColor = UIColor.black.cgColor
    textFieldView.layer.shadowOpacity = 0.08
    textFieldView.layer.shadowOffset = CGSize(width: 0, height: 3)
    textFieldView.layer.shadowRadius = 4

  }
  
  //
  // MARK: - IBActions
  //
  
  @IBAction func handleTouchNextButton(_ sender: Any) {
    addDeck()
  }
  
  
  //
  // MARK: - Text field delegate
  //
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
  }
  
  //
  // MARK: - Data manipulation/validation methods
  //
  
  func addDeck() {
    if textField.text!.count < 1 {
      presentNameValidationAlert()
    } else {
      do {
        try self.realm.write {
          newDeck.name = textField.text!
          newDeck.createdOn = Date()
          newDeck.source = "self"
          newDeck.cards = List<Card>()
          self.realm.add(newDeck)
        }
        performSegue(withIdentifier: "goToDeckFromNewDeckSegue", sender: self)
      } catch {
        print("Error saving to Realm: \(error)")
      }
    }
  }
  
  func presentNameValidationAlert()  {
    let validationAlertController = UIAlertController(title: "Invalid deck name", message: "The deck name must include at least one letter.", preferredStyle: .alert)
    validationAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(validationAlertController, animated: true)
  }
  
  //
  // MARK: - Navigation
  //
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "goToDeckFromNewDeckSegue" {
      let destinationVC = segue.destination as! DeckViewController
      
      destinationVC.selectedDeck = newDeck
      
    }
    
  }

}
