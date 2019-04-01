//
//  AddCardViewController.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 3/31/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController, UITextFieldDelegate {
  
  //
  // MARK: - IBOutlets
  //
  
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var cardFrontTextField: UITextField!
  @IBOutlet weak var cardFrontNotesTextField: UITextField!
  @IBOutlet weak var cardViewBottomDistanceConstraint: NSLayoutConstraint!
  @IBOutlet weak var swapCardButtonBottomDistanceConstraint: NSLayoutConstraint!
  
  @IBAction func handleTouchCancelButton(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardViewTapped))
    cardView.addGestureRecognizer(tapGesture)

    cardView.layer.cornerRadius = 8
  }
  
  //
  // MARK: - Text field delegate methods
  //
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    UIView.animate(withDuration: 0.3, animations: {
      self.cardViewBottomDistanceConstraint.constant = 300
      self.swapCardButtonBottomDistanceConstraint.constant = 320
      self.view.layoutIfNeeded()
    })
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    UIView.animate(withDuration: 0.2, animations: {
      self.cardViewBottomDistanceConstraint.constant = 40
      self.swapCardButtonBottomDistanceConstraint.constant = 0
      self.view.layoutIfNeeded()
    })
  }
  
  //
  // MARK: - Touchable methods
  //
  
  @objc func cardViewTapped() {
    cardFrontNotesTextField.endEditing(true)
    cardFrontTextField.endEditing(true)
  }

}
