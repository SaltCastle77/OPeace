//
//  CardItemView.swift
//  DesignSystem
//
//  Created by 서원지 on 8/25/24.
//

import SwiftUI
import Model
import Collections

public struct CardItemView: View {
    @State private var isRotated: Bool = false
    @State var isLikedTap: Bool = false
    @Binding var isTapAVote: Bool
    @Binding var isTapBVote: Bool
    @State private var answerRatio: (A: Int, B: Int)
    @State  var currentOffset: CGFloat = 0
    @State private var statsUpdated: Bool = false
    
    private var statsData: QuestionStatusResponseModel?
    private var resultData: ResultData
    private var userLoginID: String
    private var isProfile: Bool
    private var isLogOut: Bool
    private var isLookAround: Bool
    private var isDeleteUser: Bool
    private var generationColor: Color
    
    private var editTapAction: () -> Void = { }
    private var appearStatusAction: () -> Void = { }
    private var likeTapAction: (String) -> Void = { _ in }
    private var choiceTapAction: () -> Void = { }
    
    public init(
        resultData: ResultData,
        statsData:QuestionStatusResponseModel?,
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
        appearStatusAction: @escaping () -> Void,
        choiceTapAction: @escaping () -> Void
    ) {
        self.resultData = resultData
        self.statsData = statsData
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
        self.appearStatusAction = appearStatusAction
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
                .frame(height: calculateVotingCardHeight())
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
            
            Spacer()
                .frame(height: 16)
        }
    }
    
    @ViewBuilder
    private func votingCardView() -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.gray500)
                .frame(height: calculateVotingCardHeight())
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
                        updateStatusOnFlip()
                    }
                }
            
            Spacer()
                .frame(height: 16)
        }
        .rotation3DEffect(
            .degrees((isRotated ) ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
        .animation(.easeInOut(duration: 0.5), value: isRotated)
    }
    
    private func calculateVotingCardHeight() -> CGFloat {
        let titleHeight = calculateTextHeight(text: resultData.title ?? "", width: UIScreen.main.bounds.width - 88)
        
        if resultData.title?.count ?? 0 < 12 {
            return 520
        } else if resultData.title?.count ?? 0 > 50 {
            let baseHeight: CGFloat = 440
            return baseHeight + titleHeight
        } else if  resultData.title?.count ?? 0 > 12 {
            let baseHeight: CGFloat = 450
            return baseHeight + titleHeight
        }
        else {
            return 520
        }
    }

    private func calculateTextHeight(text: String, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 28, weight: .bold)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        let constraintBox = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = attributedText.boundingRect(with: constraintBox, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height) + 20
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
    
    private func updateStatusOnFlip() {
        if !isUserInteractionDisabled {
            appearStatusAction()
            statsUpdated = false
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
                if let stats = statsData?.stats {
                    choiceAnswerRoundViewProfile(
                        choiceTitleA: choiceA,
                        choiceTitleB: choiceB,
                        percentageA: Int(statsData?.overallRatio?.a ?? .zero),
                        percentageB: Int(statsData?.overallRatio?.b ?? .zero),
                        stats: stats
                    )
                }
            } else if isProfile {
                if let stats = statsData?.stats {
                    choiceAnswerRoundViewProfile(
                        choiceTitleA: choiceA,
                        choiceTitleB: choiceB,
                        percentageA: Int(statsData?.overallRatio?.a ?? .zero),
                        percentageB: Int(statsData?.overallRatio?.b ?? .zero),
                        stats: stats
                    )
                }
            } else {
                choiceAnswerRoundView(choiceTitleA: choiceA, choiceTitleB: choiceB)
            }
        }
        .onAppear {
            updateStatusOnFlip()
        }
        .onDisappear {
            statsUpdated = false
        }
    }
    
    
    @ViewBuilder
    private func choiceAnswerRoundViewProfile(
        choiceTitleA: String,
        choiceTitleB: String,
        percentageA: Int,
        percentageB: Int,
        stats: Stats
    ) -> some View {
        let colorMapping: [String: Color] = [
            "Z세대": .basicPrimary,
            "M세대": .basicYellow,
            "X세대": .basicLightBlue,
            "베이비붐세대": .basicPurple,
            "기타세대": .gray300
        ]
        
        VStack {
            Spacer()
                .frame(height: 16)
            
            if (stats.a?.isEmpty ?? true) && (stats.b?.isEmpty ?? true) {
                makeDefaultRoundedView(
                    label: "A",
                    title: choiceTitleA,
                    percentageLabel: String(percentageA)
                )
                Spacer()
                    .frame(height: 8)
                makeDefaultRoundedView(
                    label: "B",
                    title: choiceTitleB,
                    percentageLabel: String(percentageB)
                )
            } else {
                if let percentagesA = stats.a {
                    renderSegmentedView(
                        choiceLabel: "A",
                        choiceTitle: choiceTitleA,
                        percentageLabel: String(percentageA),
                        percentages: percentagesA,
                        colorMapping: colorMapping
                    )
                }
                Spacer()
                    .frame(height: 8)
                
                if let percentagesB = stats.b {
                    renderSegmentedView(
                        choiceLabel: "B",
                        choiceTitle: choiceTitleB,
                        percentageLabel: String(percentageB),
                        percentages: percentagesB,
                        colorMapping: colorMapping
                    )
                }
            }
        }
        .padding(.horizontal, 24)

    }

    @ViewBuilder
    private func makeDefaultRoundedView(
        label: String,
        title: String,
        percentageLabel: String
    ) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.gray400)
            .frame(height: 48)
            .overlay {
                HStack {
                    Spacer().frame(width: 16)
                    
                    Text(label)
                        .pretendardFont(family: .SemiBold, size: 16)
                        .foregroundStyle(label == "A" ? Color.gray600 : Color.gray200)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Spacer()
                    
                    Text(title)
                        .pretendardFont(family: .SemiBold, size: 16)
                        .foregroundStyle(label == "A" ? Color.gray600 : Color.gray200)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Spacer()
                    
                    Text("\(percentageLabel)%")
                        .pretendardFont(family: .SemiBold, size: 16)
                        .foregroundStyle(label == "A" ? Color.gray600 : Color.gray200)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Spacer()
                        .frame(width: 12)
                }
            }
            .clipShape(Capsule())
    }

    @ViewBuilder
    private func renderSegmentedView(
        choiceLabel: String,
        choiceTitle: String,
        percentageLabel: String,
        percentages: [String: Double],
        colorMapping: [String: Color]
    ) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray400)
                    .frame(height: 48)
                
                let totalWidth = geometry.size.width
                let orderedDict = sortedOrderedDictionary(from: percentages)
                let combinedSegments = combineSegments(orderedDict: orderedDict, totalWidth: totalWidth)
                
                ForEach(combinedSegments.indices, id: \.self) { index in
                    let segment = combinedSegments[index]
                    let key = segment.key
                    var width = segment.width
                    let offset = combinedSegments.prefix(index).reduce(0) { $0 + $1.width }
                    
                    
                    let corners: UIRectCorner = {
                        if index == 0 {
                            return [.topLeft, .bottomLeft]
                        } else if index == combinedSegments.count - 1 {
                            return [.topRight, .bottomRight]
                        } else {
                            return []
                        }
                    }()
                    
                    AnimatedRectangle(
                        key: key,
                        color: colorMapping[key] ?? .gray400,
                        targetWidth: width,
                        offset: offset,
                        corners: corners
                    )
                }
                
                HStack {
                    Spacer()
                        .frame(width: 16)
                    
                    Text(choiceLabel)
                        .pretendardFont(family: .SemiBold, size: 16)
                        .foregroundStyle(choiceLabel == "A" ? Color.gray600 : Color.gray200)
                        .frame(alignment: .leading)
                    
                    Spacer()
                    
                    Text(choiceTitle)
                        .pretendardFont(family: .SemiBold, size: 16)
                        .foregroundStyle(choiceLabel == "A" ? Color.gray600 : Color.gray200)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                    
                    Text("\(percentageLabel)%")
                        .pretendardFont(family: .SemiBold, size: 16)
                        .foregroundStyle(choiceLabel == "A" ? Color.gray600 : Color.gray200)
                        .frame(alignment: .trailing)
                    
                    Spacer().frame(width: 12)
                }
            }
        }
        .frame(height: 48)
        .clipShape(Capsule())
    }

    private func sortedOrderedDictionary(from percentages: [String: Double]) -> OrderedDictionary<String, Double> {
        let desiredOrder = ["Z세대", "M세대", "X세대", "베이비붐세대", "기타세대"]
        
        var completeDict: [String: Double] = [:]
        for key in desiredOrder {
            completeDict[key] = percentages[key] ?? 0.0
        }
        
        let orderedDict = OrderedDictionary(uniqueKeysWithValues: completeDict)
        
        let sortedElements = orderedDict.elements.sorted { first, second in
            let firstIndex = desiredOrder.firstIndex(of: first.key) ?? Int.max
            let secondIndex = desiredOrder.firstIndex(of: second.key) ?? Int.max
            return firstIndex < secondIndex
        }
        
        return OrderedDictionary(uniqueKeysWithValues: sortedElements)
    }

    private func combineSegments(
        orderedDict: OrderedDictionary<String, Double>,
        totalWidth: CGFloat) -> [(key: String, width: CGFloat)] {
        var combinedSegments: [(key: String, width: CGFloat)] = []
        var currentSegment: (key: String, width: CGFloat)? = nil
        
        for element in orderedDict.elements {
            let key = element.key
            let value = element.value
            let width = totalWidth * CGFloat(value / 100.0)
            
            if width == 0 {
                continue
            }
            
            if currentSegment == nil {
                currentSegment = (key, width)
            } else if currentSegment!.key == "기타세대" || key == "기타세대" {
                currentSegment!.width += width
            } else {
                combinedSegments.append(currentSegment!)
                currentSegment = (key, width)
            }
        }
        
        if let segment = currentSegment {
            combinedSegments.append(segment)
        }
        
        return combinedSegments
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
                        
                        
                        Spacer()
                        
                        Text(choiceTitleA)
                            .pretendardFont(family: .Bold, size: 16)
                            .foregroundStyle(Color.gray200)
                        
                        Spacer()
                    }
                }
                .clipShape(Capsule())
            
            
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
                        
                        
                        Spacer()
                        
                        Text(choiceTitleB)
                            .pretendardFont(family: .Bold, size: 16)
                            .foregroundStyle(Color.gray200)
                        
                        Spacer()
                    }
                }
                .clipShape(Capsule())
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
                choiceTapAction()
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




