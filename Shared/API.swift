//
//  API.swift
//  AlgebraMathMage (iOS)
//
//  Created by Andrew Johnson on 8/16/22.
//

import Foundation
import KeychainSwift
import Security
import SwiftUI

struct APIKeys {
  static let chapterIndex = "chapterIndex"
  static let multipleChoice = "multiple_choice"
  static let currentProblem = "currentProblem"
  static let sectionIndex = "sectionIndex"
  static let problemIndex = "problemIndex"
  static let username = "username"
  static let userAnswersLookupSuffix = "_answers"
}

struct Problem: Decodable, Hashable {
  let answer: Int?
  let buttonTitles: [String]?
  let formula: String?
  let formulaNumbers: [Int]?
  let formulaOperation: String?
  let formulaOrientation: String?
  let hint: String
  let id: Int
  let prompt: String?
  let type: String
}

struct Section: Decodable, Hashable {
  let id: Int
  let inOrder:Bool
  let sectionTitle: String
  let problemIDs: [Int]
}

struct Chapter: Decodable, Hashable {
  let id: Int
  let chapterTitle: String
  let sections: [Section]
}

struct Curriculum: Decodable, Hashable {
  let chapters: [Chapter]
  let problems: [Problem]
}

struct AnswerRecord: Codable, Hashable {
  let index: CurriculumIndex
  var answers: [Int]
}

struct CurriculumIndex: Codable, Hashable {
    let chapterID: Int
    let sectionID: Int
    let problemID: Int
}


// todo: make this use a server
class API {
  static func loadCurriculum() -> Curriculum? {
    if let url = Bundle.main.url(forResource: "curriculum", withExtension: "json") {
         do {
             let data = try Data(contentsOf: url)
             let decoder = JSONDecoder()
             let jsonData = try decoder.decode(Curriculum.self, from: data)
             return jsonData
         } catch {
             print("error:\(error)")
         }
    }
    return nil
  }
  
  static func sectionPairIsMastered(chapterID:Int, sectionIDInOrder:Int, sectionIDRandom:Int) -> Bool {
    if let curriculum = API.loadCurriculum() {
      if let chapter = curriculum.chapters.first(where: {$0.id == chapterID}),
         let sectionInOrder = chapter.sections.first(where: {$0.id == sectionIDInOrder}),
         let sectionRandom = chapter.sections.first(where: {$0.id == sectionIDRandom}) {
  
        let keychain = KeychainSwift()
        if let username = keychain.get(APIKeys.username) {
          let answersLookupKey = "\(username)\(APIKeys.userAnswersLookupSuffix)"
          var records:[AnswerRecord] = []
          if let dataAnswers = keychain.getData(answersLookupKey) {
            records = API.dataToAnswerArray(data:dataAnswers) ?? []
          }
          print("Section In Order Answers\n")
          let inOrderMastered = API.sectionIsMastered(curriculum: curriculum, chapterID: chapterID, section: sectionInOrder, records: records)
          print("\n\nSection Random Answers\n")
          let randomMastered = API.sectionIsMastered(curriculum: curriculum, chapterID: chapterID, section: sectionRandom, records: records)
          return inOrderMastered && randomMastered
        }
      }
    }
    return false
  }

  static func sectionIsMastered(curriculum:Curriculum, chapterID:Int, section:Section, records:[AnswerRecord]) -> Bool {
    var answerMap = Dictionary(uniqueKeysWithValues: section.problemIDs.map{ ($0, false) })
    for record in records {
      if (record.index.chapterID == chapterID && record.index.sectionID == section.id) {
        if answerMap[record.index.problemID] != nil {
          if API.answerRecordHasCorrectAnswer(record: record, problem: API.problemForID(problemID: record.index.problemID)) {
            answerMap[record.index.problemID] = true
          }
        }
      }
    }
    print("\(answerMap as AnyObject)")
    for (_, isCorrect) in answerMap {
      if !isCorrect {
        return false
      }
    }
    return true
  }

  static func answerRecordHasCorrectAnswer(record:AnswerRecord, problem:Problem?) -> Bool {
    if problem != nil {
      for answer in record.answers {
        if answer == problem?.answer {
          return true
        }
      }
    }
    return false
  }
  
  static func problemForIndices(chapterIndex:Int, sectionIndex:Int, problemIndex:Int) -> Problem? {
    if let curriculum = API.loadCurriculum() {
      let chapter = curriculum.chapters[chapterIndex]
      let section = chapter.sections[sectionIndex]
      let problems = API.problemsForIDs(problemIDs: section.problemIDs)
      return problems[problemIndex]
    }
    return nil
  }

  static func problemForID(problemID:Int) -> Problem? {
    if let curriculum = API.loadCurriculum() {
      for p in curriculum.problems {
        if (p.id == problemID) {
          return p
        }
      }
    }
    return nil
  }

  static func problemsForIDs(problemIDs:[Int]) -> [Problem] {
    if let curriculum = API.loadCurriculum() {
      return problemIDs.compactMap{ id in
        curriculum.problems.filter { (problem) -> Bool in
          problemIDs.contains(problem.id)}.filter{ $0.id == id }.first
      }
    }
    return []
  }

  static func chapterForID(chapterID:Int) -> Chapter? {
    if let curriculum = API.loadCurriculum() {
      for c in curriculum.chapters {
        if (c.id == chapterID) {
          return c
        }
      }
    }
    return nil
  }
  
  static func sectionForID(chapterID:Int, sectionID:Int) -> Section? {
    if let curriculum = API.loadCurriculum() {
      for c in curriculum.chapters {
        if (c.id == chapterID) {
          for s in c.sections {
            if s.id == sectionID {
              return s
            }
          }
        }
      }
    }
    return nil
  }
  
  static func titleForProblem(problem:Problem) -> String {
    if problem.prompt != nil {
      return problem.prompt!
    }
    if problem.formula != nil {
      return problem.formula!
    }
    if problem.formulaOperation == "multiplication", let numbers = problem.formulaNumbers {
      return "\(numbers[0]) x \(numbers[1])"
    }
    // should never get here
    return ""
  }
  
  static func answerArrayToData(answerArray: [AnswerRecord]) -> Data? {
    let encoder = JSONEncoder()
    if let jsonData = try? encoder.encode(answerArray) {
      return jsonData
    }
    return nil
  }
  
  static func dataToAnswerArray(data: Data) -> [AnswerRecord]? {
    let decoder = JSONDecoder()
    if let answerArray = try? decoder.decode([AnswerRecord].self, from: data) {
      return answerArray
    }
    return nil
  }

  // answerGiven is either a numeric answer or the index of a multiple choice answer
  static func saveUserAnswer(index: CurriculumIndex, answerGiven:Int) {
    let keychain = KeychainSwift()
    if keychain.get(APIKeys.username) == nil {
      // todo: set a random username from server
      keychain.set(Strings.initialUsername, forKey: APIKeys.username)
      print("saved initial username")
    }
    if let username = keychain.get(APIKeys.username) {
      let answersLookupKey = "\(username)\(APIKeys.userAnswersLookupSuffix)"
      if keychain.get(answersLookupKey) == nil {
        // todo is this force unwrap bad?
        keychain.set(API.answerArrayToData(answerArray:[])!, forKey: answersLookupKey)
      }

      if let dataAnswers = keychain.getData(answersLookupKey) {
        if var answers = API.dataToAnswerArray(data:dataAnswers) {
          var found = false
          let newAnswers: [AnswerRecord] = answers.map { answer in
            if (answer.index.chapterID == index.chapterID && answer.index.sectionID == index.sectionID && answer.index.problemID == index.problemID) {
              var previousAnswers = answer.answers
              previousAnswers.append(answerGiven)
              found = true
              return AnswerRecord(index: index, answers: previousAnswers)
            }
            return answer
          }
          if (!found) {
            let newAnswer:AnswerRecord = AnswerRecord(index: index, answers: [answerGiven])
            answers.append(newAnswer)
            if let data = API.answerArrayToData(answerArray:answers) {
              keychain.set(data, forKey: answersLookupKey)
            }
          } else {
            if let data = API.answerArrayToData(answerArray:newAnswers) {
              keychain.set(data, forKey: answersLookupKey)
            }
          }
        }
      }
    }
  }

  static func saveCurrentQuestion(index: CurriculumIndex) {
    let keychain = KeychainSwift()
    if let encoded = try? JSONEncoder().encode(index) {
      keychain.set(encoded, forKey: APIKeys.currentProblem)
    }
  }

  static func getLastQuestion() -> CurriculumIndex {
    let keychain = KeychainSwift()
    if let encoded = keychain.getData(APIKeys.currentProblem),
      let index = try? JSONDecoder().decode(CurriculumIndex.self, from: encoded) {
        return index
    }
    return CurriculumIndex(chapterID: 0, sectionID: 0, problemID: 0)
  }
  
  static func printKeychain() {
    let keychain = KeychainSwift()
    for keykey in keychain.allKeys {
      if keykey == APIKeys.username {
        print("\(keykey): \(keychain.get(keykey)!)")
      } else {
        if let data = keychain.getData(keykey), let answers = API.dataToAnswerArray(data: data) {
          for answer in answers {
            print("chapterID: \(answer.index.chapterID), sectionID: \(answer.index.sectionID), problemID: \(answer.index.problemID), answers: \(answer.answers)")
          }
        }
      }
    }
  }
  
  static func clearKeychain() {
    let keychain = KeychainSwift()
    keychain.clear()
    
    if let curriculum = API.loadCurriculum(), let encoded = try? JSONEncoder().encode(CurriculumIndex(chapterID: curriculum.chapters[0].id, sectionID: curriculum.chapters[0].sections[0].id, problemID: curriculum.chapters[0].sections[0].problemIDs[0])) {
      keychain.set(encoded, forKey: APIKeys.currentProblem)
    }
  }
}
