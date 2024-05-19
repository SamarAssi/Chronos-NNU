//
//  TrackableScrollView.swift
//  Chronos
//
//  Created by Samar Assi on 18/05/2024.
//

import SwiftUI

struct TrackableScrollView<Header: View, Content: View>: View {
    @State private var isShowHeader = true
    let header: () -> Header
    let content: () -> Content

    var body: some View {
        VStack {
            if isShowHeader {
                VStack {
                    header()
                }
                .transition(
                    .asymmetric(
                        insertion: .push(from: .top),
                        removal: .push(from: .bottom)
                    )
                )
            }
            GeometryReader { outerGeo in
                let outerHeight = outerGeo.size.height
                ScrollView(.vertical) {
                    content()
                        .background {
                            GeometryReader { innnerGeo in
                                let contentHeight = innnerGeo.size.height
                                let minY = max(
                                    min(0, innnerGeo.frame(in: .named("ScrollView")).minY),
                                    outerHeight - contentHeight
                                )
                                Color.clear
                                    .onChange(of: minY) { oldVal, newVal in
                                        if (isShowHeader && newVal < oldVal) || !isShowHeader && newVal > oldVal {
                                            isShowHeader = newVal > oldVal
                                        }
                                    }
                            }
                        }
                }
                .coordinateSpace(name: "ScrollView")
            }
            .padding(.top, 1)
        }
        .animation(.easeInOut, value: isShowHeader)
    }
}
