//
//  OnboardingTabView.swift
//  hearo
//
//  Created by Pil_Gaaang on 11/23/24.
//

import SwiftUI

struct OnboardingTabView: View {
    @Environment(\.presentationMode) var presentationMode // 뒤로가기 동작을 위한 환경 변수
    @State private var currentTab = 0 // 현재 탭 인덱스를 관리하는 변수
    @State private var navigateToInfo = false // Info로 이동 여부를 관리하는 변수
    
    var body: some View {
        ZStack {
            Color("Background") // 전체 배경을 흰색으로 설정
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                
                // 우측 상단 페이지 인디케이터
                HStack {
                    Spacer()
                    HStack(spacing: 6) {
                        ForEach(0..<3) { index in
                            if currentTab == index {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 20, height: 8)
                                    .cornerRadius(4)
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.4))
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                    Spacer().frame(width: 33)
                }
                Spacer().frame(height:10)

                // 상단 타이틀 및 설명
                VStack(spacing: 8) {
                    if currentTab == 0 {
                        Text("정확한 소리 수집을 위해\n휴대폰을 거치해주세요.")
                        .font(.semiBold)
                            .multilineTextAlignment(.center)
                        
                    } else if currentTab == 1 {
                        Text("워치를 함께 사용하여\n소리를 진동으로 느껴보세요.")
                        .font(.semiBold)
                            .multilineTextAlignment(.center)
                    } else if currentTab == 2 {
                        Text("히어로드는 여러분의\n안전한 주행을 보조합니다.")
                        .font(.semiBold)
                            .multilineTextAlignment(.center)
                        
                        Text("피해 또는 상해를 입을 수 있는 상황, 고위험이나\n긴급 상황 중에는 알람에만 의존해서는 안됩니다.")
                            .font(.LiveActivitySub)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                    }
                }

                Spacer().frame(height: 10) // 여백 추가
                
                // 콘텐츠 슬라이드(TabView)
                TabView(selection: $currentTab) {
                    VStack {
 

                        LottieView(animationName: "phone", animationScale: 1, loopMode: .loop)
                            .frame(width: 200, height: 200)
                    }
                    .tag(0)
                    
                    VStack {


                        LottieView(animationName: "watch", animationScale: 1, loopMode: .loop)
                            .frame(width: 200, height: 200)
                    }
                    .tag(1)
                    
                    VStack {
                        Image("safeinfo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 300)
                    }
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // 페이지 인디케이터 숨기기
                .frame(height: 300)

                Spacer() // 콘텐츠와 버튼 간 여백
                
                // 버튼 영역
                Button(action: {
                    if currentTab < 2 {
                        // 다음 페이지로 이동
                        withAnimation {
                            currentTab += 1
                        }
                    } else {
                        // Info 화면으로 이동
                        navigateToInfo = true
                    }
                }) {
                    Text(currentTab == 2 ? "돌아가기" : "확인") // 버튼 텍스트
                }
                .buttonStyle(CustomButtonStyle())
                
                Spacer().frame(height: 63)
            }
            
            // NavigationLink로 Info 화면으로 이동
            NavigationLink(
                destination: Info(isHomeActive: .constant(false)),
                isActive: $navigateToInfo
            ) {
                EmptyView() // 버튼을 보이지 않게 설정
            }
        }
        .navigationBarBackButtonHidden(true) // 기본 뒤로가기 버튼 숨김
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // 이전 화면으로 복귀
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.gray) // 버튼 색상 설정
                }
            }
        }
    }
}

struct OnboardingTabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OnboardingTabView()
        }
    }
}
