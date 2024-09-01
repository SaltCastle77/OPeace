//
//  CardItemView.swift
//  DesignSystem
//
//  Created by 서원지 on 8/25/24.
//

import SwiftUI
import Model

public struct CardItemView: View {
    @State private var isRotated: Bool = false
    @State var isLikedTap: Bool = false
    @Binding var isTapAVote: Bool
    @Binding var isTapBVote: Bool
    @State private var answerRatio: (A: Int, B: Int)
    
    private var resultData: ResultData
    private var userLoginID: String
    private var isProfile: Bool
    private var isLogOut: Bool
    private var isLookAround: Bool
    private var isDeleteUser: Bool
    private var generationColor: Color
    
    private var editTapAction: () -> Void = { }
    private var likeTapAction: (String) -> Void = { _ in }
    private var choiceTapAction: () -> Void = { }
    
    public init(
        resultData: ResultData,
        isProfile: Bool,
        userLoginID: String,
        generationColor: Color,
        isTapAVote: Binding<Bool>,
        isTapBVote: Binding<Bool>,
        isLogOut: Bool,
        isLookAround: Bool,
        isDeleteUser: Bool,
        answerRatio: (A: Int, B: Int),
        editTapAction: @escaping () -> Void,
        likeTapAction: @escaping (String) -> Void,
        choiceTapAction: @escaping () -> Void
    ) {
        self.resultData = resultData
        self.isProfile = isProfile
        self.userLoginID = userLoginID
        self.generationColor = generationColor
        self._isTapAVote = isTapAVote
        self._isTapBVote = isTapBVote
        self.isLogOut = isLogOut
        self.isLookAround = isLookAround
        self.isDeleteUser = isDeleteUser
        self.editTapAction = editTapAction
        self.likeTapAction = likeTapAction
        self.choiceTapAction = choiceTapAction
        _answerRatio = State(initialValue: (Int(resultData.answerRatio?.a ?? .zero), Int(resultData.answerRatio?.b ?? .zero)))
        _isLikedTap = State(initialValue: isLikedTap)
    }
    
    private var isUserInteractionDisabled: Bool {
        return isLogOut || isLookAround || isDeleteUser
    }
    
    public var body: some View {
        if isProfile {
            profileCardView()
        } else {
            votingCardView()
        }
    }
}

extension CardItemView {
    
    @ViewBuilder
    private func profileCardView() -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.gray500)
                .frame(height: 520)
                .padding(.horizontal, 20)
                .overlay {
                    VStack {
                        cardHeaderView(
                            nickName: resultData.userInfo?.userNickname ?? "",
                            job: resultData.userInfo?.userJob ?? "",
                            generation: resultData.userInfo?.userGeneration ?? ""
                        )
                        cardEmojiView(emoji: resultData.emoji ?? "")
                        cardWriteAndAnswerView(
                            title: resultData.title ?? "",
                            choiceA: resultData.choiceA ?? "",
                            choiceB: resultData.choiceB ?? "",
                            isRoated: isRotated
                        )
                        isVotedResultView(
                            responseCount: resultData.answerCount ?? 0,
                            likeCount: resultData.likeCount ?? 0
                        )
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                }
        }
    }
    
    @ViewBuilder
    private func votingCardView() -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.gray500)
                .frame(height: 520)
                .padding(.horizontal, 20)
                .overlay {
                    VStack {
                        cardHeaderView(
                            nickName: resultData.userInfo?.userNickname ?? "",
                            job: resultData.userInfo?.userJob ?? "",
                            generation: resultData.userInfo?.userGeneration ?? ""
                        )
                        cardEmojiView(emoji: resultData.emoji ?? "")
                        
                        if isRotated {
                            cardWriteAndAnswerView(
                                title: resultData.title ?? "",
                                choiceA: resultData.choiceA ?? "",
                                choiceB: resultData.choiceB ?? "",
                                isRoated: isRotated
                            )
                            isVotedResultView(
                                responseCount: resultData.answerCount ?? 0,
                                likeCount: resultData.likeCount ?? 0
                            )
                        } else {
                            cardWriteAndAnswerView(
                                title: resultData.title ?? "",
                                choiceA: resultData.choiceA ?? "",
                                choiceB: resultData.choiceB ?? "",
                                isRoated: isRotated
                            )
                            questionChoiceVoteButton()
                        }
                        
                        Spacer()
                    }
                    .rotation3DEffect(
                        .degrees((isRotated ) ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0),
                        perspective: 0.5
                    )
                    .padding(.horizontal, 24)
                }
                .onTapGesture {
                    if !isUserInteractionDisabled {
                        isRotated.toggle()
                        isTapAVote = false
                        isTapBVote = false
                    } else {
                        isRotated.toggle()
                    }
                }
        }
        .rotation3DEffect(
            .degrees((isRotated ) ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
        .animation(.easeInOut(duration: 0.5), value: isRotated)
    }
    
    @ViewBuilder
    private func cardHeaderView(
        nickName: String,
        job: String,
        generation: String
    ) -> some View {
        VStack {
            Spacer()
                .frame(height: 32)
            
            HStack {
                Text(nickName)
                    .pretendardFont(family: .Bold, size: 20)
                    .foregroundStyle(Color.basicWhite)
                
                Spacer()
                
                Image(asset: .questionEdit)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .onTapGesture {
                        if !isUserInteractionDisabled {
                            if isProfile {
                                editTapAction()
                            } else {
                                if userLoginID != resultData.userInfo?.userID {
                                    editTapAction()
                                }
                            }
                        } else if isUserInteractionDisabled {
                            editTapAction()
                        }
                        else if isProfile == true {
                           editTapAction()
                       }
                    }
            }
            
            Spacer()
                .frame(height: 3)
            
            HStack {
                Text(job)
                    .pretendardFont(family: .Regular, size: 14)
                    .foregroundStyle(Color.gray200)
                
                Spacer()
                    .frame(width: 10)
                
                Rectangle()
                    .frame(width: 1, height: 10)
                    .foregroundStyle(Color.gray300)
                
                Spacer()
                    .frame(width: 10)
                
                let (generation, color) = CheckRegister.generatuionTextColor(generation: generation, color: generationColor)
                
                Text(generation)
                    .pretendardFont(family: .Bold, size: 14)
                    .foregroundStyle(color)
                
                Spacer()
            }
        }
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    private func cardEmojiView(emoji: String) -> some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 26)
            
            if let emojiImage = Image.emojiToImage(emoji: emoji.convertUnicodeToEmoji(unicodeString: emoji) ?? "") {
                emojiImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            }
        }
    }
    
    @ViewBuilder
    private func cardWriteAndAnswerView(
        title: String,
        choiceA: String,
        choiceB: String,
        isRoated: Bool
    ) -> some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(height: 16)
            
            Text(title)
                .pretendardFont(family: .Bold, size: 28)
                .foregroundStyle(Color.basicWhite)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Spacer()
                .frame(height: 16)
            
            choiceAnswerRoundView(choiceTitleA: choiceA, choiceTitleB: choiceB)
        }
    }
    
    @ViewBuilder
    private func choiceAnswerRoundView(
        choiceTitleA: String,
        choiceTitleB: String
    ) -> some View {
        VStack {
            Spacer()
                .frame(height: 16)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray400)
                .frame(height: 48)
                .overlay {
                    HStack {
                        Spacer()
                            .frame(width: 16)
                        
                        Text("A")
                            .pretendardFont(family: .Bold, size: 16)
                            .foregroundStyle(Color.gray200)
                            .onTapGesture {
                                if !isUserInteractionDisabled {
                                    handleVote(for: "A")
                                }
                            }
                        
                        Spacer()
                        
                        Text(choiceTitleA)
                            .pretendardFont(family: .Bold, size: 16)
                            .foregroundStyle(Color.gray200)
                        
                        Spacer()
                    }
                }
            
            Spacer()
                .frame(height: 8)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray400)
                .frame(height: 48)
                .overlay {
                    HStack {
                        Spacer()
                            .frame(width: 16)
                        
                        Text("B")
                            .pretendardFont(family: .Bold, size: 16)
                            .foregroundStyle(Color.gray200)
                            .onTapGesture {
                                if !isUserInteractionDisabled {
                                    handleVote(for: "B")
                                }
                            }
                        
                        Spacer()
                        
                        Text(choiceTitleB)
                            .pretendardFont(family: .Bold, size: 16)
                            .foregroundStyle(Color.gray200)
                        
                        Spacer()
                    }
                }
        }
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    private func isVotedResultView(
        responseCount: Int,
        likeCount: Int
    ) -> some View {
        VStack {
            Spacer()
                .frame(height: 36)
            
            HStack {
                Spacer()
                
                Image(asset: .resultRespond)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                
                Spacer()
                    .frame(width: 4)
                
                Text("응답")
                    .pretendardFont(family: .Bold, size: 16)
                    .foregroundStyle(Color.gray200)
                
                Spacer()
                    .frame(width: 4)
                
                if responseCount > 999 {
                    Text("\(responseCount)+")
                        .pretendardFont(family: .Medium, size: 16)
                        .foregroundStyle(Color.gray200)
                } else {
                    Text("\(responseCount)")
                        .pretendardFont(family: .Medium, size: 16)
                        .foregroundStyle(Color.gray200)
                }
                
                Spacer()
                    .frame(width: 12)
                
                Rectangle()
                    .fill(Color.gray200)
                    .frame(width: 1, height: 15)
                
                Spacer()
                    .frame(width: 12)
                
                if resultData.metadata?.liked == true {
                    HStack {
                        Image(asset: isLikedTap ? .isTapResultLike : .resultLike)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                        
                        Spacer()
                            .frame(width: 4)
                        
                        Text("공감")
                            .pretendardFont(family: .Bold, size: 16)
                            .foregroundStyle(isLikedTap ? Color.basicPrimary : Color.gray200)
                        
                        Spacer()
                            .frame(width: 4)
                        
                        if likeCount > 999 {
                            Text("\(likeCount)+")
                                .pretendardFont(family: .Medium, size: 16)
                                .foregroundStyle(isLikedTap ? Color.basicPrimary : Color.gray200)
                        } else {
                            Text("\(likeCount)")
                                .pretendardFont(family: .Medium, size: 16)
                                .foregroundStyle(isLikedTap ? Color.basicPrimary : Color.gray200)
                        }
                    }
                    .onTapGesture {
                        if !isUserInteractionDisabled {
                            if userLoginID != resultData.userInfo?.userID {
                                isLikedTap.toggle()
                                likeTapAction(String(resultData.id ?? 0))
                            }
                        } else if userLoginID == resultData.userInfo?.userID {
                            isLikedTap = false
                        } else if isUserInteractionDisabled {
                            likeTapAction("")
                        }
                    }
                    
                    .onAppear {
                        isLikedTap = true
                    }
                } else {
                    HStack {
                        Image(asset: isLikedTap ? .isTapResultLike : .resultLike)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                        
                        Spacer()
                            .frame(width: 4)
                        
                        Text("공감")
                            .pretendardFont(family: .Bold, size: 16)
                            .foregroundStyle(isLikedTap ? Color.basicPrimary : Color.gray200)
                        
                        Spacer()
                            .frame(width: 4)
                        
                        if likeCount > 999 {
                            Text("\(likeCount)+")
                                .pretendardFont(family: .Medium, size: 16)
                                .foregroundStyle(isLikedTap ? Color.basicPrimary : Color.gray200)
                        } else {
                            Text("\(likeCount)")
                                .pretendardFont(family: .Medium, size: 16)
                                .foregroundStyle(isLikedTap ? Color.basicPrimary : Color.gray200)
                        }
                    }
                    .onTapGesture {
                        if !isUserInteractionDisabled {
                            if userLoginID != resultData.userInfo?.userID {
                                isLikedTap.toggle()
                                likeTapAction(String(resultData.id ?? 0))
                            }
                        } else if userLoginID == resultData.userInfo?.userID {
                            isLikedTap = false
                        } else if isUserInteractionDisabled {
                            likeTapAction("")
                        }
                    }
                    
                }
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func questionChoiceVoteButton() -> some View {
        VStack {
            Spacer()
                .frame(height: 24)
            
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.basicPrimary)
                    .frame(width: 144, height: 64)
                    .clipShape(Capsule())
                    .overlay {
                        Text("A")
                            .pretendardFont(family: .SemiBold, size: 24)
                            .foregroundStyle(Color.gray600)
                    }
                    .onTapGesture {
                        handleVote(for: "A")
                    }
                
                Spacer()
                    .frame(width: 8)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.basicPrimary)
                    .frame(width: 144, height: 64)
                    .clipShape(Capsule())
                    .overlay {
                        Text("B")
                            .pretendardFont(family: .SemiBold, size: 24)
                            .foregroundStyle(Color.gray600)
                    }
                    .onTapGesture {
                        handleVote(for: "B")
                    }
            }
        }
    }
    
    private func handleVote(for choice: String) {
        if !isUserInteractionDisabled {
            if choice == "A" {
                if userLoginID != resultData.userInfo?.userID {
                    isTapAVote = true
                    if isTapAVote {
                        answerRatio.A += 1
                        isRotated = true
                    }
                    choiceTapAction()
                    isTapBVote = false
                } else if userLoginID == resultData.userInfo?.userID {
                    isRotated.toggle()
                }
            } else if choice == "B" {
                if userLoginID != resultData.userInfo?.userID {
                    isTapBVote = true
                    if isTapBVote {
                        answerRatio.B += 1
                        isRotated = true
                    }
                    choiceTapAction()
                    isTapAVote = false
                } else if userLoginID == resultData.userInfo?.userID {
                    isRotated.toggle()
                }
            } else if userLoginID == resultData.userInfo?.userID {
                isRotated.toggle()
            } else {
                isRotated = false
                choiceTapAction()
            }
        } else if isUserInteractionDisabled {
            choiceTapAction()
        }
    }
    
}


