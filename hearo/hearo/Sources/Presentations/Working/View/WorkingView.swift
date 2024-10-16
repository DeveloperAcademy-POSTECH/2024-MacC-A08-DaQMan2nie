//
//  WorkingView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/5/24.
//
import SwiftUI

struct WorkingView: View {
    @ObservedObject var appRootManager: AppRootManager
    @ObservedObject var soundDetectorViewModel: SoundDetectorViewModel

    init(appRootManager: AppRootManager) {
            self.appRootManager = appRootManager
            self.soundDetectorViewModel = SoundDetectorViewModel(appRootManager: appRootManager)
        }

    var body: some View {
        VStack {
            Text("워킹 화면")
                .font(.largeTitle)
                .padding()

            // ML 작동 중인 내용을 보여주는 텍스트
            Text("분류 결과: \(soundDetectorViewModel.classificationResult)")
                .font(.title2)
                .foregroundColor(.white)
                .padding()

            Button(action: {
                appRootManager.currentRoot = .finish
                print("녹음 중지")
                soundDetectorViewModel.stopRecording() // 종료 시 녹음 중지
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
            soundDetectorViewModel.startRecording() // 뷰가 나타날 때 녹음 시작
            print("녹음 시작")
        }
        .onDisappear {
            soundDetectorViewModel.stopRecording() // 뷰가 사라질 때 녹음 중지
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 28/255, green: 34/255, blue: 46/255, opacity: 1))
        .edgesIgnoringSafeArea(.all)
    }
}
