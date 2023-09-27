//
//  GPT2View.swift
//  watchgpt2
//
//  Created by Sigil Wen on 2023-09-26.
//

import Foundation
import SwiftUI
import Combine

struct GPT2View: View {
    @State private var text: String = ""
    @State private var speed: Double = 0.0
    
    let model = GPT2(strategy: .topK(40))
    
    let prompts = [
        "Before boarding your rocket to Mars, remember to pack these items",
        "In a shocking finding, scientist discovered a herd of unicorns living in a remote, previously unexplored valley, in the Andes Mountains. Even more surprising to the researchers was the fact that the unicorns spoke perfect English.",
        "Legolas and Gimli advanced on the orcs, raising their weapons with a harrowing war cry.",
        "Today, scientists confirmed the worst possible outcome: the massive asteroid will collide with Earth",
        "Hugging Face is a company that releases awesome projects in machine learning because",
    ]
    
    var body: some View {
        VStack {
            TextEditor(text: $text)
                .background(Color.black.opacity(0.5))
                .onAppear() {
                    shuffle()
                }
            
            Text(String(format: "%.2f", speed))
            
            HStack {
                Button("Shuffle") {
                    shuffle()
                }
                
                Button("Trigger") {
                    trigger()
                }
            }
        }
    }
    
    func shuffle() {
        if let prompt = prompts.randomElement() {
            text = prompt
        }
    }
    
    func trigger() {
        DispatchQueue.global(qos: .userInitiated).async {
            _ = self.model.generate(text: text, nTokens: 50) { completion, time in
                DispatchQueue.main.async {
                    self.text += completion
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
