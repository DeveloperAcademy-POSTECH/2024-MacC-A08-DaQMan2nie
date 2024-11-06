//
//  HomeView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    private var randomTip: String {
        let tips = TipMessage.allCases
        return tips.randomElement()?.message ?? ""
    }
    
    @State private var circleOffset: CGFloat = 0
    @State private var showTip: Bool = true // 주행 팁 텍스트 표시 여부
    @State private var showArrowAndText: Bool = false // 새로운 텍스트 및 애니메이션 표시 여부
    private let targetOffset: CGFloat = 274
    private let minimumOffset: CGFloat = 197
    
    var body: some View {
        ZStack{
            Color.white // 다크 모드에서도 흰색으로 고정
                .ignoresSafeArea()
            VStack {
                Spacer().frame(height: 89)
                
                HStack {
                    Spacer().frame(width: 16)
                    
                    Text("안녕하세요!\n오늘도 안전한 주행 되세요.")
                        .font(.mainTitle)
                        .foregroundColor(Color("MainFontColor"))
                        .frame(height: 70)
                    Spacer()
                }
                
                Spacer().frame(height: 149)
                // 원형 버튼을 드래그 가능하도록 설정
                Image("StartCircle")
                    .offset(y: circleOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // 원형 버튼을 누르는 순간 주행 팁 텍스트를 서서히 사라지게 설정
                                withAnimation(.easeOut(duration: 0.3)) {
                                    showTip = false
                                    showArrowAndText = false
                                }
                                let newOffset = value.translation.height
                                
                                if newOffset < 0 {
                                    circleOffset = 0
                                } else if newOffset > targetOffset {
                                    circleOffset = targetOffset
                                } else {
                                    circleOffset = newOffset
                                }
                            }
                            .onEnded { value in
                                if circleOffset >= minimumOffset {
                                    // 애니메이션을 사용하여 목표 오프셋으로 부드럽게 이동
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        circleOffset = targetOffset
                                    }
                                    viewModel.startWorking()
                                } else {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        circleOffset = 0
                                    }
                                }
                                // 드래그가 끝났을 때 주행 팁 다시 표시
                                withAnimation(.easeIn(duration: 0.3)) {
                                    showTip = true
                                    showArrowAndText = false
                                }
                            }
                    )
                ZStack{
                    if showArrowAndText {
                        VStack {
                            LottieView(animationName: "arrow GR", animationScale: 1)
                                .frame(height: 150 ,alignment: .top)
                                .offset(y: -90)
                                .padding()
                            Text("아이콘을 아래로 내리면 주행이 시작됩니다.")
                                .font(.title1)
                                .foregroundColor(Color("SubFontColor"))
                            
                        }
                        .transition(.opacity)
                        // 서서히 나타나는 애니메이션
                    }
                }
                
                Spacer().frame(height: 52)
                
                
                if showTip {
                    VStack {
                        Text("주행 Tip!")
                            .font(.title0)
                            .foregroundColor(Color("SubFontColor"))
                        
                        Text(randomTip)
                            .font(.title1)
                            .foregroundColor(Color("SubFontColor"))
                            .multilineTextAlignment(.center)
                            .frame(height: 50)
                            .padding(.horizontal, 20)
                    }
                    .opacity(showTip ? 1 : 0)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                viewModel.updateCurrentDate()
            }
        }
        .contentShape(Rectangle()) // 전체 화면을 터치 가능한 영역으로 설정
        .onLongPressGesture(minimumDuration: 0.1) { // 꾹 눌렀을 때 화살표와 텍스트 표시
            withAnimation(.easeOut(duration: 0.3)) {
                showTip = false
                showArrowAndText = true // 화면을 누를 때 화살표와 텍스트 표시
            }
        } onPressingChanged: { isPressing in
            if !isPressing {
                withAnimation(.easeIn(duration: 0.3)) {
                    showTip = true
                    showArrowAndText = false // 손가락을 떼면 화살표와 텍스트 숨김
                }
            }
        }
    }
}

//랜덤문구 정의
enum TipMessage: String, CaseIterable {
    case carefulObservation = "주변을 주의 깊게 살피며\n여유로운 주행을 즐겨보세요."
    case speedControl = "속도를 조절하며 주변 상황에 유의하세요.\n안전이 최우선입니다!"
    case warningCheck = "경고 알림이 울리면 한 번 뒤를 확인해 보세요.\n항상 안전이 우선이에요."
    case safeRoads = "안전한 주행을 위해 자전거 도로를 이용하고,\n교차로에서는 주의하세요."
    case stayCalm = "급한 상황에서도 여유를 잃지 마세요.\n제가 함께하고 있어요."
    case slipperyRoads = "주행 중 미끄러운 도로나 장애물에 유의하며\n편안히 주행하세요."
    case checkSurroundings = "주변 소리가 감지되면 잠시 속도를 줄이며\n상황을 확인해 보세요."
    
    var message: String {
        return self.rawValue
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(appRootManager: AppRootManager()))
}
