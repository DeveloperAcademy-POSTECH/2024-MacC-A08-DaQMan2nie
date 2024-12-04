//
//  FeedBack.swift
//  hearo
//
//  Created by Pil_Gaaang on 11/23/24.
//

import SwiftUI

struct FeedBack: View {
    @Environment(\.presentationMode) var presentationMode // 뒤로가기 동작을 위한 환경 변수
    
    var body: some View {
        ZStack {
            Color.radish // 배경 흰색
                .ignoresSafeArea()
            
            VStack {
                Spacer().frame(height: 30)
                VStack(spacing: 8) {
                    Text("더 나은 앱서비스를 위해\n목소리를 들려주세요!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
                    Text("히어로드 웹사이트를 통해 저희 앱의\n개선 사항을 말씀해 주세요")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                }
                .padding(.top, 24)
                
                Spacer().frame(height: 70)
                
                // 중앙 원
                ZStack {
                    
                    Image("Ellipse 60")
                        .resizable()
                        .frame(width: 208, height: 208)
                        .overlay(
                            Circle()
                                .stroke(
                                    Color(red: 0.35, green: 0.84, blue: 0.24).opacity(0.6),
                                    lineWidth: 3
                                )
                        )
                        .rotationEffect(Angle(degrees: -94.05))
                    
                    
                    // 첫 번째 원
                    Circle()
                        .fill(Color(red: 0.35, green: 0.84, blue: 0.24)) // 원 내부를 채움
                        .frame(width: 155, height: 155) // 크기 설정

                   
                    // 세 번째 바깥 원
                    Circle()
                        .frame(width: 260, height: 260)
                        .foregroundColor(.clear)
                        .overlay(
                            Circle()
                                .stroke(
                                    Color(red: 0.35, green: 0.84, blue: 0.24).opacity(0.3),
                                    lineWidth: 3
                                )
                        )
                    
                }
                
                Spacer()
                
                // 바로가기 버튼
                Button(action: {
                    if let url = URL(string: "https://slashpage.com/hearoad") {
                           UIApplication.shared.open(url, options: [:], completionHandler: nil)
                       }
                    print("바로가기 버튼 클릭됨")
                }) {
                    Text("바로가기")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 225, height: 58)
                        .background(
                            RoundedRectangle(cornerRadius: 92)
                                .fill(Color(red: 0.35, green: 0.84, blue: 0.24))
                        )
                }
                .padding(.bottom, 32)
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

struct FeedBack_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FeedBack()
        }
    }
}
