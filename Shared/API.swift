//
//  API.swift
//  AlgebraMathMage (iOS)
//
//  Created by Andrew Johnson on 8/16/22.
//

import Foundation
import KeychainSwift
import Security

struct APIKeys {
  static let chapterIndex = "chapterIndex"
  static let multipleChoice = "multiple_choice"
  static let lastChapterIndex = "lastChapterIndex"
  static let lastSectionIndex = "lastSectionIndex"
  static let lastProblemIndex = "lastProblemIndex"
  static let sectionIndex = "sectionIndex"
  static let problemIndex = "problemIndex"
  static let username = "username"
  static let userAnswersLookupSuffix = "_answers"
}

struct Problem: Decodable, Hashable {
  enum Category: Decodable {
      case swift, combine, debugging, xcode
  }
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
  enum Category: Decodable {
      case swift, combine, debugging, xcode
  }
  let id: Int
  let sectionTitle: String
  let problemIDs: [Int]
}

struct Chapter: Decodable, Hashable {
  enum Category: Decodable {
      case swift, combine, debugging, xcode
  }
  let id: Int
  let chapterTitle: String
  let sections: [Section]
}

struct Curriculum: Decodable, Hashable {
  enum Category: Decodable {
      case swift, combine, debugging, xcode
  }
  let chapters: [Chapter]
  let problems: [Problem]
}

struct AnswerRecord: Encodable, Decodable, Hashable {
    enum Category: Decodable {
        case swift, combine, debugging, xcode
    }
    let chapterID: Int
    let sectionID: Int
    let problemID: Int
    var answers: [Int]
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
  static func saveUserAnswer(problemID:Int, sectionID: Int, chapterID: Int, answerGiven:Int) {
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
            if (answer.chapterID == chapterID && answer.sectionID == sectionID && answer.problemID == problemID) {
              var previousAnswers = answer.answers
              previousAnswers.append(answerGiven)
              found = true
              return AnswerRecord(chapterID: answer.chapterID, sectionID: answer.sectionID, problemID: answer.problemID, answers: previousAnswers)
            }
            return answer
          }
          if (!found) {
            let newAnswer:AnswerRecord = AnswerRecord(chapterID: chapterID, sectionID: sectionID, problemID: problemID, answers: [answerGiven])
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

  static func saveLastQuestion(chapterIndex: Int, sectionIndex: Int, problemIndex: Int) {
    let keychain = KeychainSwift()
    keychain.set("\(chapterIndex)", forKey: APIKeys.lastChapterIndex)
    keychain.set("\(sectionIndex)", forKey: APIKeys.lastSectionIndex)
    keychain.set("\(problemIndex)", forKey: APIKeys.lastProblemIndex)
  }

  static func getLastQuestion() -> [String:Int] {
    let keychain = KeychainSwift()
    if let chapterIndex = keychain.get(APIKeys.lastChapterIndex), let sectionIndex = keychain.get(APIKeys.lastSectionIndex), let problemIndex = keychain.get(APIKeys.lastProblemIndex) {
      return [APIKeys.chapterIndex: Int(chapterIndex) ?? 0, APIKeys.sectionIndex: Int(sectionIndex) ?? 0, APIKeys.problemIndex: Int(problemIndex) ?? 0]
    }
    return [APIKeys.chapterIndex: 0, APIKeys.sectionIndex: 0, APIKeys.problemIndex: 0]
  }
  
  static func printKeychain() {
    let keychain = KeychainSwift()
    for keykey in keychain.allKeys {
      if keykey == APIKeys.username {
        print("\(keykey): \(keychain.get(keykey)!)")
      } else {
        if let data = keychain.getData(keykey), let answers = API.dataToAnswerArray(data: data) {
          for answer in answers {
            print("chapterID: \(answer.chapterID), sectionID: \(answer.sectionID), problemID: \(answer.problemID), answers: \(answer.answers)")
          }
        }
      }
    }
  }
  
  static func clearKeychain() {
    let keychain = KeychainSwift()
    keychain.clear()
    keychain.set("0", forKey: APIKeys.lastChapterIndex)
    keychain.set("0", forKey: APIKeys.lastSectionIndex)
    keychain.set("0", forKey: APIKeys.lastProblemIndex)
  }
}
