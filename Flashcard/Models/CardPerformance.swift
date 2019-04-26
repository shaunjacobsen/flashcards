//
//  CardPerformance.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 4/26/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import Foundation

class CardPerformance {
  
  var timestamp: Date = Date()
  var progress: Int = 0
  var nextReview: Date = Date()
  
  init(progress: Int, nextReview: Date) {
    self.progress = progress
    self.nextReview = nextReview
  }
}
