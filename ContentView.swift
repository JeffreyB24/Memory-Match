//
//  ContentView.swift
//  CodePath-HW4
//
//  Created by Jeffrey Berdeal on 10/2/25.
//

import SwiftUI

struct Card: Identifiable, Equatable {
    let id: UUID = UUID()
    let symbol: String
    var isFaceUp: Bool = false
    var isMatched: Bool = false
}

struct ContentView: View {
    @State private var availablePairCounts: [Int] = [2, 4, 6, 8]
    @State private var selectedPairCount: Int = 4

    @State private var cards: [Card] = []
    @State private var firstIndex: Int? = nil
    @State private var isEvaluating: Bool = false
    @State private var moves: Int = 0
    @State private var matches: Int = 0

    private let emojiPool = ["🍎","🚗","🐶","🌟","🎈","🍩","🎧","🧩","⚽️","🦋","🎮","🌈","🍀","🛼","🍕","📸","🧸","🪄","🪁","🎲"]

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(.systemGray6), Color(.systemGray5)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                header
                controls

                ScrollView {
                    LazyVGrid(columns: gridColumns, spacing: 12) {
                        ForEach(Array(cards.enumerated()), id: \.1.id) { index, card in
                            CardView(card: card)
                                .onTapGesture { handleTap(at: index) }
                                .disabled(card.isMatched || isEvaluating)
                                .animation(.spring(), value: card.isFaceUp)
                                .animation(.spring(), value: card.isMatched)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }
                .animation(.easeInOut, value: cards)

                footer
            }
            .padding(.top, 12)
        }
        // Extra safety: ensure we start even if .onAppear doesn’t fire
        .task {
            if cards.isEmpty { startNewGame() }
        }
        .onAppear {
            if cards.isEmpty { startNewGame() }
        }
    }

    private var gridColumns: [GridItem] {
        [GridItem(.adaptive(minimum: 80), spacing: 12)]
    }

    private var header: some View {
        VStack(spacing: 4) {
            Text("Memory Match")
                .font(.system(size: 34, weight: .bold))
                .tracking(0.5)
            Text("Find all the pairs!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var controls: some View {
        VStack(spacing: 10) {
            HStack(spacing: 16) {
                Menu {
                    Picker("Pairs", selection: $selectedPairCount) {
                        ForEach(availablePairCounts, id: \.self) { count in
                            Text("\(count) Pairs").tag(count)
                        }
                    }
                } label: {
                    labelCapsule(title: "\(selectedPairCount) Pairs", systemName: "square.grid.3x3")
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
                .onChange(of: selectedPairCount) { _ in startNewGame() }
                
                Button(action: startNewGame) {
                    labelCapsule(title: "New Game", systemName: "arrow.clockwise")
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
                .buttonStyle(.plain)
                
            }
            
            
            statsPill
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, 16)
    }

    private var footer: some View {
        Group {
            if isGameOver {
                Text("🎉 You matched all pairs in \(moves) moves!")
                    .font(.headline)
                    .padding(.vertical, 8)
                    .transition(.opacity)
            }
        }
    }

    private func statChip(title: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(value)
                .font(.callout).bold()
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private var isGameOver: Bool {
        matches == selectedPairCount && selectedPairCount > 0
    }
    
    // --- shared building blocks ---
    private func labelCapsule(title: String, systemName: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: systemName).imageScale(.medium)
            Text(title)
                .font(.callout.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.85) // shrink slightly instead of wrapping
                .allowsTightening(true)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: Capsule())
    }

    private var statsPill: some View {
        HStack(spacing: 12) {
            Label { Text("\(moves)") } icon: { Image(systemName: "shoeprints.fill") }
            Divider().frame(height: 14)
            Label { Text("\(matches)/\(selectedPairCount)") } icon: { Image(systemName: "checkmark.seal.fill") }
        }
        .font(.callout.weight(.semibold))
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: Capsule())
        .lineLimit(1)
        .fixedSize(horizontal: true, vertical: false)
    }


    private func startNewGame() {
        moves = 0
        matches = 0
        firstIndex = nil
        isEvaluating = false

        // Safety: never allow zero pairs
        let pairs = max(2, selectedPairCount)
        let picked = Array(emojiPool.shuffled().prefix(pairs))
        let pairCards = picked.flatMap { sym in [Card(symbol: sym), Card(symbol: sym)] }
        cards = pairCards.shuffled()
    }

    private func handleTap(at index: Int) {
        guard !cards[index].isMatched, !cards[index].isFaceUp, !isEvaluating else { return }
        cards[index].isFaceUp = true

        if firstIndex == nil {
            firstIndex = index
            return
        }

        let secondIndex = index
        guard let first = firstIndex else { return }
        moves += 1
        isEvaluating = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
            if cards[first].symbol == cards[secondIndex].symbol {
                cards[first].isMatched = true
                cards[secondIndex].isMatched = true
                matches += 1
            } else {
                cards[first].isFaceUp = false
                cards[secondIndex].isFaceUp = false
            }
            firstIndex = nil
            isEvaluating = false
        }
    }
}

struct CardView: View {
    let card: Card

    var body: some View {
        ZStack {
            if card.isMatched {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.clear)
                    .frame(height: 110)
                    .opacity(0)
            } else if card.isFaceUp {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(.primary.opacity(0.2), lineWidth: 1.5)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
                    .overlay(
                        Text(card.symbol)
                            .font(.system(size: 44))
                    )
                    .frame(height: 110)
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.blue.opacity(0.85), Color.indigo.opacity(0.85)],
                                         startPoint: .topLeading,
                                         endPoint: .bottomTrailing))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.white.opacity(0.35), lineWidth: 2)
                    )
                    .frame(height: 110)
                    .overlay(
                        Image(systemName: "questionmark")
                            .font(.title.weight(.bold))
                            .foregroundStyle(.white)
                    )
            }
        }
    }
}

#Preview {
    ContentView()
}


