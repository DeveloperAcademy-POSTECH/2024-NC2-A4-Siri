//
//  GifImage.swift
//  kkusu
//
//  Created by sungkug_apple_developer_ac on 6/18/24.
//
import SwiftUI
import WebKit

struct GifView: UIViewRepresentable {
    private let name: String

    init(_ name: String) {
        self.name = name
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()

        if let url = Bundle.main.url(forResource: name, withExtension: "gif") {
            if let data = try? Data(contentsOf: url) {
                webView.load(
                    data,
                    mimeType: "image/gif",
                    characterEncodingName: "UTF-8",
                    baseURL: url.deletingLastPathComponent()
                )
            }
        }

        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.translatesAutoresizingMaskIntoConstraints = false

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}

struct AontentView: View {
    var body: some View {
        GifView("mainBackground")
            .frame(width: .infinity, height: 995)
        
//            .edgesIgnoringSafeArea(.all) // Safe Area를 무시하고 전체 화면을 덮도록 설정
    }
}

struct AontentView_Previews: PreviewProvider {
    static var previews: some View {
        AontentView()
    }
}
