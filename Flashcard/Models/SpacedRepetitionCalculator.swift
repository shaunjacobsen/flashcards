//
//  SpacedRepetition.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 4/26/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import Foundation

enum ProgressAssessment {
  case hard
  case fair
  case easy
}

class SpacedRepetitionCalculator {
  
  let INTERVALS = [1, 2, 3, 8, 16, 32, 64]
  
  private func maxProgress() -> Int {
    return self.INTERVALS.count
  }
  
  private func getScore(_ assessment: ProgressAssessment) -> Int {
    switch assessment {
    case .easy:
      return 1
    case .fair:
      return -1
    case .hard:
      return -3
    }
  }
  
  func calculateNextReview(assessment: ProgressAssessment, card: Card) -> CardPerformance {
    let score = getScore(assessment)
    let timestamp = Date()
    let correct = score == 1
    let newProgressScore = card.progress + score
    var nextDueDate = timestamp.addingTimeInterval(86400)
    if correct && card.progress < self.maxProgress() {
      nextDueDate = timestamp + TimeInterval(86400 * self.INTERVALS[card.progress])
    }
    
    return CardPerformance.init(progress: newProgressScore < 0 ? 0 : newProgressScore, nextReview: nextDueDate)
  }
  
}
