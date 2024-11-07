//
//  WorkingView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/5/24.
//

import SwiftUI
struct WorkingView: View {
    @ObservedObject var viewModel: WorkingViewModel
    
    init(viewModel: WorkingViewModel) {
           self.viewModel = viewModel
       }


    var body: some View {
        VStack {
            Text("워킹 화면")
                .font(.largeTitle)
                .padding()
            
            ForEach(0..<4, id: \.self) { index in
                            Text("마이크 \(index + 1): \(viewModel.soundDetectorViewModel.classificationResults[index])")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                        }

            Button(action: {
                viewModel.finishRecording()
            }) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 361, height: 58)
                        .background(Color.white)
                        .cornerRadius(10)
                        .opacity(0.28)
                    
                    Text("종료하기")
                        .font(Font.custom("Spoqa Han Sans Neo", size: 18).weight(.medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            print("WorkingView: onAppear 호출됨 - 녹음 시작 시도")
            viewModel.startRecording() // 뷰가 나타날 때 녹음 시작
        }
//        .onDisappear {
//            print("WorkingView: onDisappear 호출됨 - 녹음 중지 시도")
//            viewModel.stopRecording() // 뷰가 사라질 때 녹음 중지
//        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 28/255, green: 34/255, blue: 46/255, opacity: 1))
        .edgesIgnoringSafeArea(.all)
    }
}
#Preview {
    WorkingView(viewModel: WorkingViewModel(appRootManager: AppRootManager()))
}
