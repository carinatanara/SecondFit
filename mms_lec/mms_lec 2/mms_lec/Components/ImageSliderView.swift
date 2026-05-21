//
//  ImageSliderView.swift
//  mms_lec
//
//  Created by Visitor on 07/10/25.
//

import SwiftUI

struct ImageSliderView: View {
    @State private var currentIndex = 0
    var slides : [String] = ["Image1", "Image2"]
    var body: some View {
        ZStack(alignment: .centerLastTextBaseline) {
            ZStack(alignment: .trailing) {
                Image(slides[currentIndex]).resizable().frame(width: 330, height: 185).scaledToFill().clipped().cornerRadius(10)
            }
            
            HStack {
                ForEach(0..<slides.count) {
                    index in Circle().fill(self.currentIndex == index ? Color("Dark Gray") : Color("Gray")).frame(width: 8, height: 8)
                }
            }.padding()
        }.onAppear {
                Timer.scheduledTimer(withTimeInterval: 6, repeats: true) {
            timer in
            if self.currentIndex + 1 == self.slides.count {
                self.currentIndex = 0
            } else {
                self.currentIndex += 1
            }
        }
    }
        
    }
}

#Preview {
    ImageSliderView()
}
