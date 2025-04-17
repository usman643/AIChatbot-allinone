//
//  ExploreAIContentView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 15/04/2025.
//

import SwiftUI

struct ExploreAIContentView: View {
    
    @StateObject var viewModel = ExploreAIContentViewModel()
    @State var showDetailScreen: ExploreAISubcategoryModel?
    @State var selectedCategory : ExploreAICategoryModel?
    
    
    var body: some View {

        VStack(alignment:.leading, spacing: 5) {
            
            VStack(alignment:.leading) {
                Text("Explore AI Tools")
                    .font(.mediumFont(18))
                    .foregroundStyle(Color.botPrimaryLight)
                    .padding(8)
                    
                
                ExploreCategoryView(selectedCategory: $selectedCategory, categories: viewModel.exploreModel)
                    .padding(.bottom)
                    .onAppear {
                        selectedCategory = viewModel.exploreModel.first
                    }
            }
            .padding(.leading, 12)

            VStack {
                ScrollViewReader { proxy in
                    
                    ScrollView(.vertical) {
                        VStack(spacing: 5) {
                            ForEach(viewModel.exploreModel) { model in
                                
                                ExploreSubCategoryView(category: model) { model in
                                    self.showDetailScreen = model
                                }
                                .id(model.id)
                                .padding(.bottom)
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .onChange(of: selectedCategory) {
                        if let id = selectedCategory?.id {
                            withAnimation {
                                proxy.scrollTo(id, anchor: .top)
                            }
                           
                        }
                    }
                    
                }
                
            }

        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .background(Color.chatbg)
        .navigationDestination(item: $showDetailScreen) { model in
            ExploreAIDetailView(selectedCategory: $showDetailScreen)
        }
        .navigationBarBackButtonHidden()
        
    }
}

fileprivate struct ExploreCategoryView: View {
    @Binding var selectedCategory: ExploreAICategoryModel?
    var categories: [ExploreAICategoryModel] = []
    
    var body: some View {
        HStack {
            ScrollView(.horizontal) {
                HStack(spacing:10) {
                    ForEach(categories) { model in
                        
                        Text(model.category)
                            .font(.mediumFont(15))
                            .foregroundStyle(Color.botPrimaryLight)
                            .padding(10)
                            .padding(.horizontal, 12)
                            .background(selectedCategory?.id == model.id ? Color.primaryGreen : Color.appGray)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .onTapGesture {
                                selectedCategory = model
                            }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(.leading,8)
    }
}


fileprivate struct ExploreSubCategoryView: View {
   
    var category: ExploreAICategoryModel
    
    var onSelectedCategory: ((ExploreAISubcategoryModel) -> Void)?
    
    
    var body: some View {
        
        VStack(alignment:.leading, spacing: 5) {
            Text(category.category)
                .font(.boldFont(16))
                .foregroundStyle(Color.primaryGreen)
                .padding(8)
                
            HStack {
                ScrollView(.horizontal) {
                    HStack(spacing:15) {
                        ForEach(category.subcategories) { model in
                            ExploreRectangleView(subCategory: model)
                                .onTapGesture {
                                    onSelectedCategory?(model)
                                }
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .padding(.leading,8)
            
        }
        .padding(.leading, 12)
    }
}

fileprivate struct ExploreRectangleView : View {
    
    var subCategory : ExploreAISubcategoryModel
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.appGray)
            .frame(width: 240, height: 190)
            .overlay {
                HStack {
                    VStack(alignment: .leading) {
                        
                        VStack(alignment: .leading) {
                            
                            Image(subCategory.toolIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            
                            Text(subCategory.toolTitle)
                                .font(.boldFont(15))
                                .foregroundStyle(Color.botPrimaryLight)
                                .padding(.top, 15)
                                .padding(.bottom, 7)
                                .lineLimit(1)
                        }
                        .padding(.top)
                        
                        
                        Text(subCategory.toolSubtitle)
                            .font(.regularFont(13))
                            .foregroundStyle(Color.botPrimaryLight)
                            .lineSpacing(5)
                            .lineLimit(2)
                        
                        Spacer()
                            
                    }
                    .padding(8)
                    .padding(.leading,5)
                    
                    Spacer()
                }
                
                
            }
        
    }
}
