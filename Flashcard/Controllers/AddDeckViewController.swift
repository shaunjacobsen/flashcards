//
//  AddDeckViewController.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 3/30/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit

class AddDeckViewController: UIViewController, UITextFieldDelegate {

  //
  // MARK: - IBOutlets
  //
  
  @IBOutlet weak var textField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textField.layer.backgroundColor = UIColor.clear.cgColor
    textField.layer.borderWidth = 0

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
      print(textField.text!)
    }
  }
  
  func presentNameValidationAlert()  {
    let validationAlertController = UIAlertController(title: "Invalid deck name", message: "The deck name must include at least one letter.", preferredStyle: .alert)
    validationAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(validationAlertController, animated: true)
  }

}
