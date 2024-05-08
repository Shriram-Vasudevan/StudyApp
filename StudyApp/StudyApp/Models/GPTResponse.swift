//
//  GPTResponse.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/25/24.
//

import Foundation

struct GPTResponse: Decodable {
    let id: String
    let created: TimeInterval
    let usage: Usage
    let object: String
    let model: String
    let choices: [Choice]
    
    struct Usage: Decodable {
        let completion_tokens: Int
        let prompt_tokens: Int
        let total_tokens: Int
    }
    
    struct Choice: Decodable {
        let finish_reason: String
        let index: Int
        let message: Message
    }
    
    struct Message: Decodable {
        let content: String
        let role: String
    }
}
