//
//  ContentView.swift
//  Bullseye
//
//  Created by Matt Hill on 3/5/20.
//  Copyright © 2020 todo-rename-this. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
  static let INITIAL_SLIDER: Double = 50.0
  @State var alertIsVisible: Bool = false
  @State var infoIsVisible: Bool = false
  @State var sliderValue: Double = INITIAL_SLIDER
  @State var score: Int = 0
  @State var round: Int = 1
  @State var target: Int = Int.random(in: 1...100)

  var body: some View {
    VStack {
      Spacer()
      //Target row
      HStack {
        Text("Put the bullseye as close as you can to:")
        Text("\(self.target)")
      }
      Spacer()
      //Slider row
      HStack {
        Text("1")
        Slider(value: $sliderValue, in: 1...100)
        Text("100")
      }
      Spacer()
      //Button row
      HStack {
        Button(action: {
          self.alertIsVisible = true
        }) {
          Text("Hit Me!")
        }.alert(isPresented: $alertIsVisible) { () -> Alert in
          let roundedValue: Int = Int(self.sliderValue.rounded())
          let currentScore: Int = self.pointsForCurrentRound(current: roundedValue, target: self.target)
          return Alert(title: Text("Hello There!"),
                       message: Text("The slider value is \(roundedValue). \n " +
                        "You scored  \(currentScore) points this round!"),
                       dismissButton: Alert.Button.default(
                           Text("Go to next round"), action: { self.updateView(currentScore) }
                       ))
        }
      }
      Spacer()
      
      //Score row
      HStack {
        Button(action: {
          self.resetView()
        }) {
          Text("Start over")
        }
        Spacer()
        Text("Score:")
        Text("\(self.score)")
        Spacer()
        Text("Round:")
        Text("\(self.round)")
        Spacer()
        Button(action: {
          self.infoIsVisible = true
        }) {
          Text("Info")
        }.alert(isPresented: $infoIsVisible) { () -> Alert in
          return Alert(title: Text("App Info"), message: Text("This is the app info."), dismissButton: .default(Text("Close")))
        }
      }.padding(.bottom, 20)
    }
  }
  
  func pointsForCurrentRound(current: Int, target: Int) -> Int {
    return 100 - abs(target - current)
  }

  func updateView(_ currentScore: Int) -> Void {
    //update score & round
    self.score += currentScore
    self.round += 1
    
    //reset target & slider
    self.target = Int.random(in: 1...100)
    self.sliderValue = ContentView.INITIAL_SLIDER
  }
  
  func resetView() -> Void {
    self.score = 0
    self.round = 1
    
    self.target = Int.random(in: 1...100)
    self.sliderValue = ContentView.INITIAL_SLIDER
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView().previewLayout(.fixed(width: 896, height: 414))
    }
}
