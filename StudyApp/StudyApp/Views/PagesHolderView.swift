//
//  PagesHolderView.swift
//  StudyApp
//
//  Created by Shriram Vasudevan on 4/9/24.
//

import SwiftUI

struct PagesHolderView: View {
    @State var pageType: PageType
    
    var body: some View {
        switch pageType {
        case .authentication:
            LoginView(pageType: $pageType)
        case .main:
            Home(pageType: $pageType)
        }
    }
}

#Preview {
    PagesHolderView(pageType: .authentication)
}
