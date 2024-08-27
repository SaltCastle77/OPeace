//
//  CardItemView.swift
//  DesignSystem
//
//  Created by 서원지 on 8/25/24.
//

import SwiftUI

public struct CardItemView: View {
    @State private var isRotated: Bool = false
    @State var isLikedTap: Bool = false
    @State private var answerRatio: (A: Int, B: Int)
    @Binding var isTapAVote: Bool
    @Binding var isTapBVote: Bool
    
    private var isProfile: Bool
    private var id: String
    private var userID: String
    private var nickName: String
    private var job: String
    private var generation: String
    private var generationColor: Color
    private var emoji: String
    private var title: String
    private var choiceA: String
    private var choiceB: String
    private var responseCount: Int
    private var likeCount: Int
    
    // New flags for user restrictions
    private var isLogOut: Bool
    private var isLookAround: Bool
    private var isDeleteUser: Bool
    
    private var editTapAction: () -> Void = { }
    private var likeTapAction: (String) -> Void = { _ in }
    private var choiceTapAction: () -> Void = { }

    public init(
        isProfile: Bool,
        id: String,
        userID: String,
        nickName: String,
        job: String,
        generation: String,
        generationColor: Color,
        emoji: String,
        title: String,
        choiceA: String,
        choiceB: String,
        responseCount: Int,
        likeCount: Int,
        isLikedTap: Bool,
        answerRatio: (A: Int, B: Int),
        isRotated: Bool,
        isTapAVote: Binding<Bool>,
        isTapBVote: Binding<Bool>,
        isLogOut: Bool,             // Pass the log out flag
        isLookAround: Bool,         // Pass the look around flag
        isDeleteUser: Bool,         // Pass the delete user flag
        editTapAction: @escaping () -> Void,
        likeTapAction: @escaping (String) -> Void,
        choiceTapAction: @escaping () -> Void
    ) {
        self.isProfile = isProfile
        self.id = id
        self.userID = userID
        self.nickName = nickName
        self.job = job
        self.generation = generation
        self.generationColor = generationColor
        self.emoji = emoji
        self.title = title
        self.choiceA = choiceA
        self.choiceB = choiceB
        self.responseCount = responseCount
        self.likeCount = likeCount
        _answerRatio = State(initialValue: answerRatio)
        _isLikedTap = State(initialValue: isLikedTap)
        _isRotated = State(initialValue: isRotated)
        self._isTapAVote = isTapAVote
        self._isTapBVote = isTapBVote
        self.isLogOut = isLogOut
        self.isLookAround = isLookAround
        self.isDeleteUser = isDeleteUser
        self.editTapAction = editTapAction
        self.likeTapAction = likeTapAction
        self.choiceTapAction = choiceTapAction
    }

    private var isUserInteractionDisabled: Bool {
        return isLogOut || isLookAround || isDeleteUser
    }

    public var body: some View {
        if isProfile {
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray500)
                    .frame(height: 520)
                    .padding(.horizontal, 20)
                    .overlay {
                        VStack {
                            cardHeaderView(nickName: nickName, job: job, generation: generation)
                                
                            cardEmojiView(emoji: emoji)
                                
                            cardWriteAndAnswerView(
                                title: title,
                                choiceA: choiceA,
                                choiceB: choiceB,
                                isRoated: isRotated)
                            
                            isVotedResultView(
                                responseCount: responseCount,
                                likeCount: likeCount
                            )
                            
                            Spacer()
                        }
                       
                        .padding(.horizontal, 24)
                    }
            }
        } else {
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray500)
                    .frame(height: 520)
                    .padding(.horizontal, 20)
                    .overlay {
                        VStack {
                            cardHeaderView(nickName: nickName, job: job, generation: generation)
                                
                            cardEmojiView(emoji: emoji)
                                
                            if isRotated {
                                cardWriteAndAnswerView(
                                    title: title,
                                    choiceA: choiceA,
                                    choiceB: choiceB,
                                    isRoated: isRotated)
                                
                                isVotedResultView(
                                    responseCount: responseCount,
                                    likeCount: likeCount
                                )
                                
                            } else {
                                cardWriteAndAnswerView(
                                    title: title,
                                    choiceA: choiceA,
                                    choiceB: choiceB,
                                    isRoated: isRotated)
                                
                                questionChoiceVoteButton()
                            }
                            
                            Spacer()
                        }
                        .rotation3DEffect(
                            .degrees(isRotated ? 180 : 0),
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
                        }
                    }
            }
            .rotation3DEffect(
                .degrees(isRotated ? 180 : 0),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.5
            )
            .animation(.easeInOut(duration: 0.5), value: isRotated)
        }
    }
}

extension CardItemView {
    
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
                                if id != userID {
                                    editTapAction()
                                }
                            }
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
            
            if let wirteAnswerEmoji = Image.emojiToImage(emoji: emoji.convertUnicodeToEmoji(unicodeString: emoji) ?? "") {
                wirteAnswerEmoji
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
            
            if isRoated {
                choiceAnswerRoundView(choiceTitleA: choiceA, choiceTitleB: choiceB)
            } else {
                choiceAnswerRoundView(choiceTitleA: choiceA, choiceTitleB: choiceB)
            }
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
                                    isTapAVote = true
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
                                    isTapBVote = true
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
                
                Text("웅답")
                    .pretendardFont(family: .Bold, size: 16)
                    .foregroundStyle(Color.gray200)
                
                Spacer()
                    .frame(width: 4)
                
                if responseCount > 999 {
                    Text("\(responseCount)+")
                        .pretendardFont(family: .Medium, size: 16)
                        .foregroundStyle(Color.gray200)
                } else {
                    Text(responseCount.description)
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
                        Text(likeCount.description)
                            .pretendardFont(family: .Medium, size: 16)
                            .foregroundStyle(isLikedTap ? Color.basicPrimary : Color.gray200)
                    }
                }
                .onTapGesture {
                    if !isUserInteractionDisabled {
                        isLikedTap.toggle()
                        likeTapAction(id)
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
                        if !isUserInteractionDisabled {
                            answerRatio.A += 1
                            isTapAVote.toggle()
                            if isTapAVote == true {
                                isRotated.toggle()
                            }
                            choiceTapAction()
                            isTapBVote = false
                        } else {
                            choiceTapAction()
                        }
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
                        if !isUserInteractionDisabled {
                            answerRatio.B += 1
                            isTapBVote.toggle()
                            if isTapBVote  == true {
                                isRotated.toggle()
                            }
                            choiceTapAction()
                            isTapAVote = false
                        } else {
                            choiceTapAction()
                        }
                    }
            }
        }
    }

}
