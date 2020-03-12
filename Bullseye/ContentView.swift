//
//  ContentView.swift
//  Bullseye
//
//  Created by Matt Hill on 3/5/20.
//  Copyright © 2020 todo-rename-this. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
  static let INITIAL_SLIDER = 50.0
  @State var alertIsVisible = false
  @State var infoIsVisible = false
  @State var sliderValue = INITIAL_SLIDER
  @State var score = 0
  @State var round = 1
  @State var target = Int.random(in: 1...100)
  let midnightBlue = Color(red: 0.0 / 255.0, green: 51.0 / 255.0, blue: 102.0 / 255.0)
  
  struct LabelStyle: ViewModifier {
    func body(content: Content) -> some View {
      content.modifier(Shadow())
      .foregroundColor(.white)
      .font(Font.custom("Arial Rounded MT Bold", size: 18))
    }
  }
  
  struct ValueStyle: ViewModifier {
    func body(content: Content) -> some View {
      content.modifier(Shadow())
      .foregroundColor(.yellow)
      .font(Font.custom("Arial Rounded MT Bold", size: 24))
    }
  }
  
  struct ButtonLargeTextStyle: ViewModifier {
    func body(content: Content) -> some View {
      content
      .foregroundColor(.black)
      .font(Font.custom("Arial Rounded MT Bold", size: 18))
    }
  }
  
  struct ButtonSmallTextStyle: ViewModifier {
    func body(content: Content) -> some View {
      content
      .foregroundColor(.black)
      .font(Font.custom("Arial Rounded MT Bold", size: 12))
    }
  }
  
  struct Shadow: ViewModifier {
    func body(content: Content) -> some View {
      content
      .shadow(color: Color.black, radius: 5, x: 2, y: 2)
    }
  }
  
  var body: some View {
    VStack {
      Spacer()
      //Target row
      HStack {
        Text("Put the bullseye as close as you can to:").modifier(LabelStyle())
        Text("\(target)").modifier(ValueStyle())
      }
      Spacer()
      //Slider row
      HStack {
        Text("1").modifier(LabelStyle())
        Slider(value: $sliderValue, in: 1...100)
        Text("100").modifier(LabelStyle())
      }
      Spacer()
      //Button row
      HStack {
        Button(action: {
          self.alertIsVisible = true
        }) {
          Text("Hit Me!").modifier(ButtonLargeTextStyle())
        }.alert(isPresented: $alertIsVisible) { () -> Alert in
          return Alert(title: Text(alertTitle()),
                       message: Text("The slider value is \(sliderValueRounded()). \n " +
                        "You scored  \(pointsForCurrentRound()) points this round!"),
                       dismissButton: Alert.Button.default(
                        Text("Go to next round"), action: { self.updateView() }
                       ))
          }.background(Image("Button")).modifier(Shadow())
      }
      Spacer()
      
      //Score row
      HStack {
        Button(action: {
          self.startNewGame()
        }) {
          HStack {
//            Image("StartOver")
            Text("Start over").modifier(ButtonSmallTextStyle())
          }
        }.background(Image("Button")).modifier(Shadow())
        Spacer()
        Text("Score:").modifier(LabelStyle())
        Text("\(score)").modifier(ValueStyle())
        Spacer()
        Text("Round:").modifier(LabelStyle())
        Text("\(round)").modifier(ValueStyle())
        Spacer()
        Button(action: {
          self.infoIsVisible = true
        }) {
          HStack {
//            Image("Info")
            Text("Info").modifier(ButtonSmallTextStyle())
          }
        }.alert(isPresented: $infoIsVisible) { () -> Alert in
          return Alert(title: Text("App Info"), message: Text("This is the app info."), dismissButton: .default(Text("Close")))
        }.background(Image("Button")).modifier(Shadow())
      }.padding(.bottom, 20)
    }
    .accentColor(midnightBlue)
    .background(Image("Background"), alignment: .center)
  }
  
  func sliderValueRounded() -> Int {
    Int(sliderValue.rounded())
  }
  
  func amountOff() -> Int {
    abs(target - sliderValueRounded())
  }
  
  func pointsForCurrentRound() -> Int {
    let maximumScore = 100
    let difference = amountOff()
    let bonus: Int
    if difference == 0 {
      bonus = 100
    } else if difference == 1 {
      bonus = 50
    } else {
      bonus = 0
    }
    return maximumScore - difference + bonus
  }
  
  func alertTitle() -> String {
    let difference = amountOff()
    let title: String
    if difference == 0 {
      title = "Perfect!"
    } else if difference < 5 {
      title = "You almost had it!"
    } else if difference <= 10 {
      title = "Not bad."
    } else {
      title = "Are you even trying?"
    }
    return title
  }

  func updateView() -> Void {
    //update score & round
    score += pointsForCurrentRound()
    round += 1
    
    //reset target & slider
    sliderValue = ContentView.INITIAL_SLIDER
    target = Int.random(in: 1...100)
  }
  
  func startNewGame() -> Void {
    score = 0
    round = 1
    
    sliderValue = ContentView.INITIAL_SLIDER
    target = Int.random(in: 1...100)

  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView().previewLayout(.fixed(width: 896, height: 414))
    }
}
