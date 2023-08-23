//
//  OnboardingView.swift
//  TaskFlow
//
//  Created by Nikko Baez on 8/16/23.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("user") var currentUser: Bool = false
    @AppStorage("name") var currentName: String?
    @AppStorage("profile") var currentProfile: String?
    @FocusState private var nameIsFocused: Bool
    @State private var onboardingScreen: Int = 0
    @State var alertMessage: String = ""
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    @State private var name: String = ""
    @State private var profile: String = ""
    
    let profiles: [String] = [
        "ProfileImage1",
        "ProfileImage2",
        "ProfileImage3",
        "ProfileImage4",
        "ProfileImage5",
        "ProfileImage6",
    ]
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10, alignment: nil),
        GridItem(.flexible(), spacing: 10, alignment: nil),
    ]
    
    let transition: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading)
    )
    
    var body: some View {
        ZStack {
            ZStack {
                switch onboardingScreen {
                    case 0:
                        welcomeScreen
                            .transition(transition)
                    case 1:
                        addNameScreen
                            .transition(transition)
                    case 2:
                        addProfileScreen
                            .transition(transition)
                    default:
                        EmptyView()
                }
            }
            VStack {
                Spacer()
                nextButton
            }
        }
        .animation(Animation.spring(), value: onboardingScreen)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

// MARK: COMPONENTS
extension OnboardingView {
    private var nextButton: some View {
        Button {
            handleNextButtonPressed()
        } label: {
            Text(onboardingScreen == 0 ? "Get Started" : onboardingScreen == 2 ? "Finish" : "Next")
                .foregroundColor(Color.white)
                .font(.title3)
                .fontWeight(.bold)
                .frame(width: 250, height: 55)
                .background(colorScheme == . light ? Color.blue.opacity(0.7) : Color.indigo)
                .cornerRadius(30)
                .padding()
        }
    }
    
    private var welcomeScreen: some View {
        VStack {
            HStack {
                Image(systemName: "list.bullet.clipboard.fill")
                    .foregroundColor(colorScheme == . light ? Color.blue.opacity(0.7) : Color.indigo)
                    .font(.title)
                Text("TaskFlow")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .padding(.bottom)
            Text("Manage your weekly and daily tasks with ")
                .font(.title)
                .fontWeight(.bold)
            + Text("TaskFlow")
                .foregroundColor(colorScheme == . light ? Color.blue.opacity(0.7) : Color.indigo)
                .font(.title)
                .fontWeight(.bold)
            Image("HeroImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.height * 0.4)
            Text("When your overwhelmed by the amount of work you have on your plate, TaskFlow is here to provide the help you need. Say goodbye to stress and hello to productivity")
                .font(.headline)
                .fontWeight(.semibold)
                .opacity(0.5)
                .lineSpacing(8.0)
            Spacer()
        }
        .padding([.bottom, .leading, .trailing])
    }
    
    private var addNameScreen: some View {
        VStack {
            Spacer()
            Text("Enter your first name")
                .font(.title)
                .fontWeight(.bold)
            TextField("John", text: $name)
                .font(.headline)
                .frame(height: 55)
                .padding(.horizontal)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .focused($nameIsFocused)
            Spacer()
            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert, content: getAlert)
    }
    
    private var addProfileScreen: some View {
        ScrollView {
            Text("Pick a profile picture")
                .font(.title)
                .fontWeight(.bold)
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(profiles, id: \.self) { image in
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(colorScheme == .light ? profile == image ? Color.gray.opacity(0.1) : Color.white : profile == image ? Color.gray.opacity(0.5) : Color.gray.opacity(0.3))
                        .frame(height: 150)
                        .shadow(radius: 10.0)
                        .overlay(
                            Image(image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 100)
                        )
                        .onTapGesture {
                            profile = image
                        }
                }
            }
            .padding()
        }
        .padding()
        .alert(isPresented: $showAlert, content: getAlert)
    }
}

// MARK: FUNCTIONS
extension OnboardingView {
    func handleNextButtonPressed() {
        switch onboardingScreen {
            case 1:
                guard name.count >= 2 else {
                    alertMessage = "Hold on"
                    alertTitle = "Your name must be more than 2 characters long! 😥"
                    showAlert.toggle()
                    return
                }
            case 2:
                guard profile.count >= 1 else {
                    alertMessage = "Hold on"
                    alertTitle = "You must pick a profile picture! 😥 "
                    showAlert.toggle()
                    return
                }
            default:
                break
        }
        
        if onboardingScreen == 1 {
            nameIsFocused = false
        }
        
        if onboardingScreen == 2 {
            currentName = name
            currentProfile = profile
            currentUser = true
        } else {
            onboardingScreen += 1
        }
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertMessage), message: Text(alertTitle))
    }
}
