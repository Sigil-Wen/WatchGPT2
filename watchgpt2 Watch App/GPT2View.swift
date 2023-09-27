//
//  GPT2View.swift
//  watchgpt2
//
//  Created by Sigil Wen on 2023-09-26.
//

import Foundation
import SwiftUI
import WatchKit

struct GPT2View: View {
    @State private var text: String = ""
    @State private var speed: Double = 0.0
    @State private var prompt: String = ""
    
    let model = GPT2(strategy: .topK(40))
    
    let prompts = [
        "Before boarding your rocket to Mars, remember to pack these items",
        "Here is a pickup line that is gaurenteed to work:",
        "According to all known laws of aviation, there is no way a bee should",
        "The meaning of life is",
        "Airchat is an asynchronous audio platform for conversations",
    ]
    
    var body: some View {
        VStack(spacing: 10) {
            ScrollView {
                HStack{
                    Text("GPT2 on Watch ")
                    Text(String(format: "%.2f", speed))
                }
              
              HStack(spacing: 10) {
                  Button("🆕") {
                      shuffle()
                  }
                  
                  Button("✨") {
                      trigger()
                  }
                }
                    Text(text)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                }
              }
              .padding()
              .onAppear() {
                  shuffle()
              }
    }
    
    func shuffle() {
        if let prompt = prompts.randomElement() {
            self.prompt = prompt
            text = prompt
        }
    }
    
    func trigger() {
        DispatchQueue.global(qos: .userInitiated).async {
            _ = self.model.generate(text: text, nTokens: 50) { completion, time in
                DispatchQueue.main.async {
                    self.text = prompt + completion
                    self.speed = 1.0 / time
                }
            }
        }
    }
}

#if DEBUG
struct GPT2View_Previews: PreviewProvider {
    static var previews: some View {
        GPT2View()
    }
}
#endif
