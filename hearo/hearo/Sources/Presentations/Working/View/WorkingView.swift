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

    @State private var isTransitioningToNextView: Bool = false

//    @State private var isWatchConnected: Bool = false // 워치 연동 상태 관리
    

    @State private var backgroundOpacity: Double = 0.0 // 전환 중 흰색 배경 불투명도
    @State private var isTransitioning: Bool = false // 전환 상태 관리



    private let targetOffset: CGFloat = 274
    private let minimumOffset: CGFloat = 197

    init(viewModel: WorkingViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color("Radish")
                .ignoresSafeArea()


            // Lottie 애니메이션과 원형 버튼

            LottieView(animationName: "sound_collection", animationScale: 1)
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height
                )
                .offset(x: -1.4, y: 60)
                .edgesIgnoringSafeArea(.all)

               
            HStack{
                Text("소리 수집중")
                    .font(Font.custom("Pretendard", size: 44))
                    .foregroundColor(Color("MainFontColor"))
                    .offset(x:10, y:-307)
                       

                // 워치 연동 상태에 따른 이미지 변경
              Image(viewModel.isWatchConnected ? "WatchOn" : "WatchOff")
                    .offset(x: 40, y: -307)
            }

            Image("StartCircle")
                .offset(y: circleOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation(.easeOut(duration: 0.3)) {
                                showArrowAndText = false
                            }
                            let newOffset = value.translation.height
                            circleOffset = max(0, min(targetOffset, newOffset))
                        }
                        .onEnded { value in
                            if circleOffset >= minimumOffset {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    circleOffset = targetOffset
                                }
                                triggerFinalHaptic() // 강한 진동 트리거

                                
                                // 2초간 애니메이션 후 뷰 전환
                                withAnimation(.easeOut(duration: 2.0)) {
                                    overlayOpacity = 1.0 // 화면 덮기 애니메이션
                                }
                                triggerFinalHaptic()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    viewModel.finishRecording() // 녹음 중지 및 다음 뷰로 전환
                                    isTransitioningToNextView = true // 전환 상태 업데이트

                                }
                            } else {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    circleOffset = 0
                                }
                            }
                        }
                )

            if showArrowAndText {
                VStack {
                    LottieView(animationName: "arrow_GR", animationScale: 1)
                        .frame(height: 150, alignment: .top)
                        .scaleEffect(x: 1.1, y: 1.0)
                        .offset(y: -120)
                        .padding()
                    Text("아이콘을 아래로 내리면 주행이 종료됩니다.")
                        .font(Font.hint)
                        .foregroundColor(Color("SubFontColor"))
                }
                .padding(.top, 400)
                .transition(.opacity)
                .allowsHitTesting(false) // 터치 이벤트 차단 방지
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

            // 전환 중 흰색 배경 오버레이
            if isTransitioning {
                Color.white
                    .opacity(backgroundOpacity)
                    .ignoresSafeArea()
            }
        }
        .contentShape(Rectangle())
        .onAppear {
            viewModel.startRecording()
        }
        .onDisappear {
            viewModel.stopRecording()
        }
        .onLongPressGesture(minimumDuration: 0) {
            withAnimation(.easeOut(duration: 0.3)) {
                showArrowAndText = true
            }
        } onPressingChanged: { isPressing in
            if !isPressing {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
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
