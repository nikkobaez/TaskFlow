//
//  HomeView.swift
//  TaskFlow
//
//  Created by Nikko Baez on 8/16/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("user") var currentUser: Bool = false
    @AppStorage("name") var currentName: String?
    @AppStorage("profile") var currentProfileImage: String?
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    @State private var isEditing = false
    
    let categoryIcons: [String] = [
        "briefcase.fill",
        "graduationcap.fill",
        "building.2.fill",
        "creditcard.fill",
        "heart.fill",
        "person.fill"
    ]
    
    var body: some View {
        NavigationStack {
            List {
                homeHeader
                    .listRowSeparator(.hidden)
                homeCategories
                    .listRowSeparator(.hidden)
                
                Text("Ongoing Lists")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .listRowSeparator(.hidden)
                
                if listViewModel.lists.isEmpty {
                    Text("No todo lists... Good job! 🥳")
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowSeparator(.hidden)
                } else {
                    homeLists
                }
            }
            .listStyle(PlainListStyle())
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "list.bullet.clipboard.fill")
                            .font(.headline)
                            .foregroundColor(colorScheme == .light ? Color.blue.opacity(0.7) : Color.indigo)
                        Text("TaskFlow")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Group {
                        EditButton()
                            .onTapGesture {
                                isEditing.toggle()
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddView(listViewModel: listViewModel)
                    } label: {
                        Text("Add")
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// MARK: COMPONENTS
extension HomeView {
    private var homeHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Hi \(currentName ?? "John")")
                    .font(.title)
                    .fontWeight(.bold)
                Text(listViewModel.totalNumberOfTasks == 1 ? "\(listViewModel.totalNumberOfTasks) task pending" : "\(listViewModel.totalNumberOfTasks) tasks pending")
                    .foregroundColor(colorScheme == .light ? Color.blue.opacity(0.7) : Color.indigo)
                    .font(.callout)
                    .fontWeight(.bold)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 32.0)
                .fill(colorScheme == .light ? Color.white : Color.gray.opacity(0.3))
                .frame(width: 64, height: 64)
                .shadow(radius: 10.0)
                .overlay(
                    Image(currentProfileImage ?? "ProfileImage1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 45)
                )
        }
        .padding()
    }
    
    private var homeCategories: some View {
        VStack(alignment: .leading) {
            Text("Categories")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 25.0) {
                    ForEach(categoryIcons, id: \.self) { icon in
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(colorScheme == .light ? Color.white : Color.gray.opacity(0.3))
                            .frame(width: 150, height: 200)
                            .shadow(radius: 5.0)
                            .overlay(
                                VStack(alignment: .leading, spacing: 5.0) {
                                    Text(categoryName(icon: icon))
                                        .font(.title3)
                                    Text("\(categoryTasks(icon: icon)) Tasks")
                                        .foregroundColor(colorScheme == .light ? Color.blue.opacity(0.7) : Color.indigo)
                                        .font(.callout)
                                        .fontWeight(.bold)
                                    Spacer()
                                    VStack {
                                        Image(systemName: icon)
                                            .foregroundColor(colorScheme == .light ? Color.blue.opacity(0.7) : Color.indigo)
                                            .font(.largeTitle)
                                    }
                                    .frame(maxWidth: .infinity)
                                    Spacer()
                                    Spacer()
                                }
                                .padding()
                                , alignment: .topLeading
                            )
                            .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var homeLists: some View {
        ForEach(listViewModel.lists) { list in
            NavigationLink {
                ListView(listViewModel: listViewModel, list: list)
            } label: {
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(colorScheme == .light ? Color.white : Color.gray.opacity(0.3))
                    .frame(height: 175)
                    .shadow(radius: 5.0)
                    .overlay (
                        VStack {
                            HStack {
                                Text(list.title)
                                    .font(.headline)
                                Spacer()
                                Text(list.category)
                                    .font(.body)
                                    .padding(5)
                                    .padding(.horizontal, 5)
                                    .background(colorScheme == .light ? Color.blue.opacity(0.2) : Color.indigo.opacity(0.8))
                                    .clipShape(Capsule())
                            }
                            ZStack {
                                Circle()
                                    .stroke(Color.blue.opacity(0.2), lineWidth: 10)
                                Circle()
                                    .trim(from: 0, to: list.progress)
                                    .stroke(colorScheme == .light ? Color.blue.opacity(0.7) : Color.indigo, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                    .rotationEffect(.degrees(-90))
                                Text("\(list.progress * 100, specifier: "%.0f")%")
                                    .font(.headline)
                            }
                            Spacer()
                        }
                            .padding()
                        , alignment: .topLeading
                    )
                    .padding([.trailing, .bottom], 8)
                    .padding(.leading)
            }
            .listRowBackground(colorScheme == .light ? isEditing ? Color.clear : Color.white : isEditing ? Color.clear : Color.black)
            .listRowSeparator(.hidden)
        }
        .onDelete(perform: listViewModel.deleteList)
        .onMove(perform: listViewModel.moveList)
    }
}

// MARK: FUNCTIONS
extension HomeView {
    func categoryName(icon: String) -> String {
        switch icon {
        case "briefcase.fill":
            return "Work"
        case "graduationcap.fill":
            return "School"
        case "building.2.fill":
            return "Community"
        case "creditcard.fill":
            return "Financial"
        case "heart.fill":
            return "Health"
        default:
            return "Personal"
        }
    }
    
    func categoryTasks(icon: String) -> Int {
        switch icon {
        case "briefcase.fill":
            return listViewModel.numberOfWorkTasks
        case "graduationcap.fill":
            return listViewModel.numberOfSchoolTasks
        case "building.2.fill":
            return listViewModel.numberOfCommunityTasks
        case "creditcard.fill":
            return listViewModel.numberOfFinancialTasks
        case "heart.fill":
            return listViewModel.numberOfHealthTasks
        default:
            return listViewModel.numberOfPersonalTasks
        }
    }
}
