//
//  UIView.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 4/16/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  
  func xibSetup() {
    let view = loadFromNib()
    addSubview(view)
    stretch(view: view)
  }

  func loadFromNib<T: UIView>() -> T {
    let selfType = type(of: self)
    let bundle = Bundle(for: selfType)
    let nibName = String(describing: selfType)
    let nib = UINib(nibName: nibName, bundle: bundle)
    
    guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else {
      fatalError("Error loading nib with name \(nibName))")
    }
    
    return view
  }
  
  func stretch(view: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: topAnchor),
      view.leftAnchor.constraint(equalTo: leftAnchor),
      view.rightAnchor.constraint(equalTo: rightAnchor),
      view.bottomAnchor.constraint(equalTo: bottomAnchor)
      ])
  }
}
