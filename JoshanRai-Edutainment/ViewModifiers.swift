//
//  ViewModifiers.swift
//  JoshanRai-Edutainment
//
//  Created by Joshan Rai on 3/4/22.
//

import Foundation
import SwiftUI

//  HomeView.swift View Modifiers

struct CapsuleButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 200)
            .padding(12)
            .foregroundColor(.black)
            .background(.orange)
            .overlay(
                Capsule()
                    .stroke(.black, lineWidth: 3)
                    .shadow(color: .black, radius: 6, x: 0, y: 4)
            )
            .cornerRadius(100)
    }
}

extension View {
    func capsuleButtonStyle() -> some View {
        modifier(CapsuleButton())
    }
}

//  GameView.swift View Modifiers

//  Shake effect made with help from https://www.objc.io/blog/2019/10/01/swiftui-shake-animation/
struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)), y: 0))
    }
}

struct MaterialUnderlay: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func materialUnderlayStyle() -> some View {
        modifier(MaterialUnderlay())
    }
}

struct HollowCapsuleButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 200)
            .padding(12)
            .foregroundColor(Color.white)
            .background(Color.accentColor)
            .overlay(
                Capsule()
                    .stroke(Color.white, lineWidth: 3)
                    .shadow(color: .black, radius: 6, x: 0, y: 4)
            )
            .cornerRadius(100)
    }
}

extension View {
    func hollowCapsuleButtonStyle() -> some View {
        modifier(HollowCapsuleButton())
    }
}

// Firework effects made with help from https://betterprogramming.pub/creating-confetti-particle-effects-using-swiftui-afda4240de6b
struct FireworkParticleGeometryEffect: GeometryEffect {
    var time: Double
    var speed = Double.random(in: 20...200)
    var direction = Double.random(in: -Double.pi...Double.pi)
    
    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let xTranslation = speed * cos(direction) * time
        let yTranslation = speed * sin(direction) * time
        let affineTranslation = CGAffineTransform(translationX: xTranslation, y: yTranslation)
        return ProjectionTransform(affineTranslation)
    }
}

struct ParticlesModifier: ViewModifier {
    @State var time = 0.0
    @State var scale = 0.1
    let duration = 5.0
    
    func body(content: Content) -> some View {
        ZStack {
            ForEach(0..<80, id: \.self) { index in
                content
                    .hueRotation(Angle(degrees: time * 80))
                    .scaleEffect(scale)
                    .modifier(FireworkParticleGeometryEffect(time: time))
                    .opacity(((duration - time) / duration))
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: duration)) {
                time = duration
                scale = 1.0
            }
        }
    }
}


//  TutorialView.swift View Modifiers

struct RoundedRectangleRegularMaterial: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func roundedRectangleRegularMaterial() -> some View {
        modifier(RoundedRectangleRegularMaterial())
    }
}

struct RoundedRectangleThickMaterial: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func roundedRectangleThickMaterial() -> some View {
        modifier(RoundedRectangleThickMaterial())
    }
}

struct BodyFontAndAutoPadding: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .padding()
    }
}

extension View {
    func bodyFontAndAutoPadding() -> some View {
        modifier(BodyFontAndAutoPadding())
    }
}

struct TitleFontAndAutoPadding: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .padding()
    }
}

extension View {
    func titleFontAndAutoPadding() -> some View {
        modifier(TitleFontAndAutoPadding())
    }
}
