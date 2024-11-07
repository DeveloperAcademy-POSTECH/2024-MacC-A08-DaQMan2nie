//
//  LottieView.swift
//  hearo
//
//  Created by 김준수(엘빈) on 11/7/24.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var animationName: String
    var animationScale: CGFloat // 애니메이션 크기 배율
<<<<<<< HEAD
=======
    var loopMode: LottieLoopMode = .loop // loopMode 추가, 기본값을 .loop로 설정
>>>>>>> develop
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView(frame: .zero)
        
        // Lottie 애니메이션 뷰 생성
        let animationView = LottieAnimationView(name: animationName)
        animationView.contentMode = .scaleAspectFit
<<<<<<< HEAD
        animationView.loopMode = .loop
=======
        animationView.loopMode = loopMode
>>>>>>> develop
        animationView.play()
        
        // 애니메이션 크기 조절 (배율 적용)
        animationView.transform = CGAffineTransform(scaleX: animationScale, y: animationScale)
        
        // 애니메이션 뷰를 컨테이너 뷰에 추가
        containerView.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
