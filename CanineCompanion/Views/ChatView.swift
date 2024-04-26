//
//  ChatView.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/1/24.
//

import SwiftUI
import ChatGPTSwift
import WebKit


struct ChatMessage: Hashable, Identifiable {
    var id = UUID()
    var sender: String
    var message: String
}

class ChatViewModel: ObservableObject {
    let apiKey = "ENTER-API-KEY-HERE"
    let api: ChatGPTAPI
    @Published var isDogRelated = false
    @Published var chatHistory: [ChatMessage] = [
        ChatMessage(sender: "DogBot", message: "Hello! 🐶\nI'm DogBot, your personal canine assistant. Please ask me any questions you may have about your furry friends.")
    ]
    @Published var isSendingMessage = false

    init() {
        api = ChatGPTAPI(apiKey: apiKey)
    }

    func sendMessage(_ message: String) async {
        guard !message.isEmpty else { return }
        chatHistory.append(ChatMessage(sender: "User", message: message))
        isSendingMessage = true
        
        await isDogRelated(query: message)

        if isDogRelated {
            queryDogFAQ(query: message)
        } else {
            queryChatGPT(query: message)
        }
    }

    
    private func isDogRelated(query: String) async {
        let prompt = "Analyze this query: \(query), is this a specific dog related question? Only respond with True or False"

        do {
            let response = try await api.sendMessage(text: prompt)

            if response.lowercased().contains("true") {
                self.isDogRelated = true
            } else {
                self.isDogRelated = false
            }
        } catch {
            print("Error: \(error)")
        }
    }

    private func queryDogFAQ(query: String) {
        guard let url = URL(string: "http://127.0.0.1:5000/query") else {
            print("Error: Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: String] = ["query": query]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("Error: Unable to serialize JSON body")
            return
        }
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("Error: No data received")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let message = json?["message"] as? String {
                    DispatchQueue.main.async {
                        self.chatHistory.append(ChatMessage(sender: "DogBot", message: message))
                        self.isSendingMessage = false // Hide loading indicator
                        
                        // Remove the GIF message from chatHistory
                        self.chatHistory.removeAll { $0.message.isEmpty }
                    }
                } else {
                    print("Error: Unable to parse response message")
                }
            } catch {
                print("Error: Unable to parse JSON response")
            }
        }.resume()
    }

    private func queryChatGPT(query: String) {
        let prompt = "Role: Dog chatbot. Now reply to this text message: \(query). Respond with one or two sentences only."

        Task {  
            do {
                // Send the query to the chatbot API
                let response = try await api.sendMessage(text: prompt)

                // Handle the response
                DispatchQueue.main.async {
                    self.chatHistory.append(ChatMessage(sender: "DogBot", message: response))
                    self.isSendingMessage = false // Hide loading indicator
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(url: url)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let url: URL

        init(url: URL) {
            self.url = url
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Reload the URL to create an endless loop
           

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                webView.load(URLRequest(url: self.url))
            }
        }
    }
}

struct ChatBubble: View {
    var sender: String
    var message: String
    
    var body: some View {
        HStack {
            if sender == "DogBot" {
                if message.isEmpty {
                    if let yourGifURL = URL(string: "https://giphy.com/embed/xULW8vRQrlIPRfiEog") {
                        WebView(url: yourGifURL)
                            .frame(width: 100, height: 100)
                            .padding(10)
                            .background(Color(#colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.horizontal)
                    }
                } else {
                    Text(message)
                        .padding(10)
                        .background(Color(#colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal)
                }
                Spacer()
            } else {
                Spacer()
                Text(message)
                    .padding(10)
                    .background(Color(hex: 0xFFB63C))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal)
            }
        }
    }
}

struct ChatView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = ChatViewModel()
    @State private var userInput = ""

    var body: some View {
        if let user = authViewModel.currentUser {
            VStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.chatHistory) { chat in
                            ChatBubble(sender: chat.sender, message: chat.message)
                        }
                    }
                    .padding()
                }

                HStack {
                    TextField("Type your message here...", text: $userInput)
                        //.textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(10)
                        .fontWeight(.semibold)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: 0xFFB63C), lineWidth: 4)
                        )
                    

                    Button(action: {
                        Task {
                            await viewModel.sendMessage(userInput)
                            userInput = ""
                        }
                    }) {
                        Text("Send")
                    }
                    .disabled(viewModel.isSendingMessage)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: 0xFFB63C))

                    if viewModel.isSendingMessage {
                        withAnimation {
                            ProgressView()
                                .frame(width: 10, height: 10)
                                .padding()
                                .transition(.opacity)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("DogBot Chat")
        }
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
