//
//  Info.swift
//  hearo
//
//  Created by Pil_Gaaang on 11/23/24.
//

import SwiftUI

struct Info: View {
    @Binding var isHomeActive: Bool // HomeView와의 연결 상태를 관리하는 바인딩 변수

    var body: some View {
        ZStack {
            Color.white // 전체 배경을 흰색으로 설정
                .ignoresSafeArea()

            VStack {
                Spacer().frame(height: 87)

                Rectangle()
                    .frame(width: 365, height: 0.5)
                    .foregroundColor(.gray)

                Spacer().frame(height: 16)

                HStack {
                    Spacer().frame(width: 18)
                    NavigationLink(destination: OnboardingTabView()) {
                        HStack {
                            Circle()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color(UIColor.lightGray))
                            Spacer().frame(width: 16)

                            Text("앱 사용시 고려할 사항")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    Spacer()
                }
                Spacer().frame(height: 16)
                Rectangle()
                    .frame(width: 365, height: 0.5)
                    .foregroundColor(Color(UIColor.lightGray))
                Spacer().frame(height: 16)

                HStack {
                    Spacer().frame(width: 18)
                    NavigationLink(destination: FeedBack()) {
                        HStack {
                            Circle()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color(UIColor.lightGray))
                            Spacer().frame(width: 16)
                            Text("유저 피드백")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    Spacer()
                }
                Spacer().frame(height: 16)
                Rectangle()
                    .frame(width: 365, height: 0.5)
                    .foregroundColor(Color(UIColor.lightGray))

                Spacer()

                Text("Copyright 2024. DaQman2ni in all rights reserved.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 16)
            }
        }
        .navigationBarBackButtonHidden(true) // 기본 네비게이션 바 숨김
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    isHomeActive = false // 홈 화면으로 복귀
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.gray)

                    }
                }
            }
        }
        .onAppear {
            // 기본 네비게이션 버튼 제거 확인 (디버깅용)
            print("Info 화면에서 기본 네비게이션 바 숨김 적용됨")
        }
    }
}

struct Info_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            Info(isHomeActive: .constant(true)) // 테스트용 홈 화면 연결
        }
    }
}
