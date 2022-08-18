//
//  API.swift
//  AlgebraMathMage (iOS)
//
//  Created by Andrew Johnson on 8/16/22.
//

import Foundation
import Security

struct Problem: Decodable, Hashable {
  enum Category: Decodable {
      case swift, combine, debugging, xcode
  }
  let id: Int
  let prompt: String
  let formula: String
  let hint: String
  let buttonTitles: [String]
  let answer: Int
}

struct Section: Decodable, Hashable {
  enum Category: Decodable {
      case swift, combine, debugging, xcode
  }
  let id: Int
  let sectionTitle: String
  let problems: [Problem]
}

struct Answer: Encodable, Decodable, Hashable {
    enum Category: Decodable {
        case swift, combine, debugging, xcode
    }
    let sectionID: Int
    let problemID: Int
    var answerIndices: [Int]
}

// todo: make this use a server
class API {
  static func loadCurriculum() -> [Section]? {
    if let url = Bundle.main.url(forResource: "curriculum", withExtension: "json") {
         do {
             let data = try Data(contentsOf: url)
             let decoder = JSONDecoder()
             let jsonData = try decoder.decode([Section].self, from: data)
             return jsonData
         } catch {
             print("error:\(error)")
         }
    }
    return nil
  }
  
  static func answerArrayToData(answerArray: [Answer]) -> Data? {
    let encoder = JSONEncoder()
    if let jsonData = try? encoder.encode(answerArray) {
      return jsonData
    }
    return nil
  }
  
  static func dataToAnswerArray(data: Data) -> [Answer]? {
    let decoder = JSONDecoder()
    if let answerArray = try? decoder.decode([Answer].self, from: data) {
      return answerArray
    }
    return nil
  }

  static func saveUserAnswer(problemID:Int, sectionID: Int, answerIndex:Int) {
    let keychain = KeychainSwift()
    if keychain.get("username") == nil {
      // todo: set a random username from server
      keychain.set("Cat Mellon Runner", forKey: "username")
      print("saved initial username")
    }
    if let username = keychain.get("username") {
      if keychain.get("\(username)_answers") == nil {
        // todo is this force unwrap bad?
        keychain.set(API.answerArrayToData(answerArray:[])!, forKey: "\(username)_answers")
      }

      if let dataAnswers = keychain.getData("\(username)_answers") {
        if var answers = API.dataToAnswerArray(data:dataAnswers) {
          var found = false
          let newAnswers: [Answer] = answers.map { answer in
            if (answer.sectionID == sectionID && answer.problemID == problemID) {
              var answerIndices = answer.answerIndices
              answerIndices.append(answerIndex)
              found = true
              print ("found question, adding an answer")
              return Answer(sectionID: answer.sectionID, problemID: answer.problemID, answerIndices: answerIndices)
            }
            return answer
          }
          if (!found) {
            let newAnswer:Answer = Answer(sectionID: sectionID, problemID: problemID, answerIndices: [answerIndex])
            answers.append(newAnswer)
            print ("saved an unanswered question")
            if let data = API.answerArrayToData(answerArray:answers) {
              keychain.set(data, forKey: "\(username)_answers")
            }
          } else {
            if let data = API.answerArrayToData(answerArray:newAnswers) {
              keychain.set(data, forKey: "\(username)_answers")
            }
          }
        }
      }
    }
  }
  
  static func saveLastQuestion(sectionIndex: Int, problemIndex: Int) {
    let keychain = KeychainSwift()
    keychain.set("\(sectionIndex)", forKey: "lastSectionIndex")
    keychain.set("\(problemIndex)", forKey: "lastProblemIndex")
  }

  static func getLastQuestion() -> [String:Int] {
    let keychain = KeychainSwift()
    if let sectionIndex = keychain.get("lastSectionIndex"), let problemIndex = keychain.get("lastProblemIndex") {
      return ["sectionIndex": Int(sectionIndex) ?? 0, "problemIndex": Int(problemIndex) ?? 0]
    }
    return ["sectionIndex": 0, "problemIndex": 0]
  }
  
  static func printKeychain() {
    let keychain = KeychainSwift()
    for keykey in keychain.allKeys {
      if keykey == "username" {
        print("\(keykey): \(keychain.get(keykey)!)")
      } else {
        if let data = keychain.getData(keykey), let answers = API.dataToAnswerArray(data: data) {
          for answer in answers {
            print("sectionID: \(answer.sectionID), problemID: \(answer.problemID), answers: \(answer.answerIndices)")
          }
        }
      }
    }
  }
  
  static func clearKeychain() {
    let keychain = KeychainSwift()
    keychain.clear()
    keychain.set("0", forKey: "lastSectionIndex")
    keychain.set("0", forKey: "lastProblemIndex")
  }
}
