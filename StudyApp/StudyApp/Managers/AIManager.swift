//
//  AIManager.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/25/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AIManager: ObservableObject {
    @Published private(set) var messages: [Message] = []
    
    func createRequestBody(with messages: [Message]) -> [String: Any] {
        guard let user = Auth.auth().currentUser else { return [
            "model": "gpt-4",
            "messages": ""
        ]}
        
        let messagesFormatted = messages.map { message -> [String: Any] in
            let role = message.senderID == user.uid ? "system" : "user"
            return [
                "role": role,
                "content": message.message
            ]
        }
        
        let body: [String: Any] = [
            "model": "gpt-4",
            "messages": messagesFormatted
        ]
        
        return body
    }
    
    func getGPTResponse(prompt: String) {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else { return }
        let apiKey = "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"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let body = createRequestBody(with: self.messages)
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
        } catch {
            print("failed to convert to json data")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error occured: \(error)")
                return
            }
            
            guard let data = data else { return }
            print("the data: \(String(decoding: data, as: UTF8.self))")
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(GPTResponse.self, from: data)
                
                DispatchQueue.main.sync {
                    self.messages.append(Message(id: UUID().uuidString, message: response.choices[0].message.content, senderID: "system", senderName: "Kevin", timestamp: Date()))
                }
            } catch {
                print("Error occured: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func askQuestion(prompt: String) {
        guard let user = Auth.auth().currentUser, let userDisplayName = user.displayName else { return }
        let message = Message(id: UUID().uuidString, message: prompt, senderID: user.uid, senderName: userDisplayName, timestamp: Date())
        messages.append(message)
        
        getGPTResponse(prompt: prompt)
    }
}
