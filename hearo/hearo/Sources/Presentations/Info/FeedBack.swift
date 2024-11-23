//
//  FeedBack.swift
//  hearo
//
//  Created by Pil_Gaaang on 11/23/24.
//

import SwiftUI

struct FeedBack: View {
    var body: some View {
        VStack {
            Text("이곳은 피드백입니다!")
                .font(.largeTitle)
                .padding()

            Spacer()
        }
        .navigationTitle("Info")
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        FeedBack()
    }
}
