//
//  IntroductionView.swift
//  TaskFlow
//
//  Created by Nikko Baez on 8/16/23.
//

import SwiftUI

struct IntroductionView: View {
    @AppStorage("user") var currentUser: Bool = false
    
    let transition: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading)
    )
    
    var body: some View {
        ZStack {
            if currentUser {
                HomeView()
                    .transition(transition)
            } else {
                OnboardingView()
                    .transition(transition)
            }
        }
        .animation(Animation.spring(), value: currentUser)
    }
}

struct IntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionView()
    }
}
