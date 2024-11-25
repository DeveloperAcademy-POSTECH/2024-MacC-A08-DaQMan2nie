//
//  CustomButtonStyle.swift
//  hearo
//
//  Created by 규북 on 11/25/24.
//

import SwiftUI

public struct CustomButtonStyle: ButtonStyle {
  var normalColor = Color(hex: "58D53C")
  var pressedColor = Color(hex: "22BA00")
    
  public func makeBody(configuration: Configuration) -> some View {
      let background = configuration.isPressed ? pressedColor : normalColor
      
      configuration.label
        .font(.headline)
        .foregroundColor(.white)
        .frame(width: 225, height: 58)
        .background(
          RoundedRectangle(cornerRadius: 92)
            .fill(background)
        )
      
    }
}
