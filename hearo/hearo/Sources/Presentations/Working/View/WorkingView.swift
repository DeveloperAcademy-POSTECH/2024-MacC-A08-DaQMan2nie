//
//  WorkingView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/5/24.
//

import SwiftUI

struct WorkingView: View {
    @ObservedObject var viewModel: WorkingViewModel
       @State private var circleOffset: CGFloat = 0
    @State private var showArrowAndText: Bool = false
       @State private var overlayOpacity: Double = 1.0 // 처음에 화면을 덮는 흰색 오버레이 불투명도
    @State private var isWatchConnected: Bool = false // 워치 연동 상태 관리

       private let targetOffset: CGFloat = 274
       private let minimumOffset: CGFloat = 197
    

       init(viewModel: WorkingViewModel) {
           self.viewModel = viewModel
       }
       
       var body: some View {
           ZStack {
               Color.white // 다크 모드에서도 흰색 배경
                   .ignoresSafeArea()
               ZStack{
                   Text("소리수집중")
                    .font(Font.custom("Pretendard", size: 44))
                    .foregroundColor(Color("MainFontColor"))
                   .offset(y:-307)
                   
                   // 워치 연동 상태에 따른 이미지 변경
                                 Image(isWatchConnected ? "Watch_Enable" : "Watch_Disable")
                                     .offset(x: 160, y: -307)
                   
               }
               // Lottie 애니메이션과 원형 버튼
               LottieView(animationName: "sound_collection", animationScale: 1)
                   .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                   .offset(x: -1.4 ,y: 60)
                   .edgesIgnoringSafeArea(.all)
                 
               
               Image("StartCircle")
                   .offset(y: circleOffset)
                   .gesture(
                       DragGesture()
                           .onChanged { value in
                               withAnimation(.easeOut(duration: 0.3)) {
                                   showArrowAndText = false
                               }
                               let newOffset = value.translation.height
                               
                               if newOffset < 0 {
                                   circleOffset = 0
                               } else if newOffset > targetOffset {
                                   circleOffset = targetOffset
                               } else {
                                   circleOffset = newOffset
                                   triggerHapticFeedback(for: newOffset, targetOffset: targetOffset) // Haptic 피드백 트리거

                               }
                           }
                           .onEnded { value in
                               if circleOffset >= minimumOffset {
                                   withAnimation(.easeOut(duration: 0.3)) {
                                       circleOffset = targetOffset
                                   }
                                   triggerFinalHaptic() // 강한 진동 트리거
                                   viewModel.finishRecording() // 녹음 중지 및 FinishView로 전환
                               } else {
                                   withAnimation(.easeOut(duration: 0.3)) {
                                       circleOffset = 0
                                   }
                               }
                               withAnimation(.easeIn(duration: 0.3)) {
                                   showArrowAndText = false
                               }
                           }
                   )
               
               if showArrowAndText {
                   VStack {
                       LottieView(animationName: "arrow_WH", animationScale: 1)
                           .frame(height: 150, alignment: .top)
                           .offset(y: -120)
                           .padding()
                       Text("아이콘을 아래로 내리면 주행이 종료됩니다.")
                           .font(.light)
                           .foregroundColor(Color("SubFontColor"))
                   }
                   .padding(.top, 400)
                   .transition(.opacity)
               }
               
               // 흰색 오버레이 (초기 불투명도 1.0에서 0으로 서서히 감소)
               Color.white
                   .opacity(overlayOpacity)
                   .ignoresSafeArea()
                   .onAppear {
                       withAnimation(.easeIn(duration: 1.0)) {
                           overlayOpacity = 0.0 // 1초에 걸쳐 서서히 투명해짐
                       }
                   }
           }
           .contentShape(Rectangle())
           .onAppear {
               viewModel.startRecording()
           }
           .onDisappear {
               viewModel.stopRecording()
           }
           .onLongPressGesture(minimumDuration: 0) { // 터치 시 즉시 실행
               withAnimation(.easeOut(duration: 0.3)) {
                   showArrowAndText = true
               }
           } onPressingChanged: { isPressing in
               if !isPressing { // 터치가 끝난 경우
                   DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // 3초 동안 유지
                       withAnimation(.easeIn(duration: 0.3)) {
                           showArrowAndText = false
                       }
                   }
               }
           }
       }
   }

#Preview {
    WorkingView(viewModel: WorkingViewModel(appRootManager: AppRootManager()))
}
