//
//  WatchWorkingView.swift
//  HearoadWatch Watch App
//
//  Created by 규북 on 12/5/24.
//

import SwiftUI

struct WatchWorkingView: View {
    @State private var currentImageIndex = 0
    let images: [UIImage] = {
        var loadedImages = [UIImage]()
        for i in 0...105 {
            if let image = UIImage(named: "30049edb3b6349defd49d650efeacf33EfCf9qvpQqqmGXY4-\(i)") {
                loadedImages.append(image)
            }
        }
        return loadedImages
    }()
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea(.all)
            
            Text("소리 수집중")
                .font(Font.custom("Pretendard", size: 26).weight(.medium))
                .foregroundColor(Color("SubFontColor"))
                .multilineTextAlignment(.center)
                .offset(y:-90)
            
            Image(uiImage: images[currentImageIndex])
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160, alignment: .center)
                .offset(y:10)
                .onAppear {
                    animateImages()
                }
        }
    }
    
    private func animateImages() {
        // Timer를 사용하여 이미지 시퀀스를 변경
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            currentImageIndex = (currentImageIndex + 1) % images.count
        }
    }
}

#Preview {
    WatchWorkingView()
}
