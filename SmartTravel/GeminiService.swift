//
//  GeminiService.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/20/25.
//


import Foundation

enum GeminiService {

    private static let apiKey = ""
    private static let model  = "gemini-2.0-flash"          // or “…-pro”
    private static let url = URL(string:
        "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey)"
    )!

    // ── Request / Response structs ──
    private struct Request: Encodable {
        struct Message: Encodable {
            let parts: [Part]          // ⚠️  NO "role" FIELD
        }
        struct Part: Encodable { let text: String }
        let contents: [Message]
    }
    private struct Response: Decodable {
        struct Candidate: Decodable {
            struct Content: Decodable { let parts: [Part] }
            struct Part: Decodable { let text: String }
            let content: Content
        }
        let candidates: [Candidate]?
    }

    enum GeminiError: LocalizedError {
        case http(Int,String), empty
        var errorDescription: String? {
            switch self {
            case .http(let c, let body): return "HTTP \(c) – \(body)"
            case .empty:                 return "Empty response"
            }
        }
    }

    // ── Public call ──
    static func generateItinerary(prompt: String,
                                  debugPrint: Bool = false) async throws -> String {

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(
            Request(contents: [.init(parts: [.init(text: prompt)])])
        )

        let (data, resp) = try await URLSession.shared.data(for: req)

        // HTTP status check
        if let http = resp as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            let body = String(data: data, encoding: .utf8) ?? "<non‑UTF8>"
            throw GeminiError.http(http.statusCode, body)
        }

        // decode JSON
        let decoded = try JSONDecoder().decode(Response.self, from: data)
        guard let txt = decoded.candidates?.first?.content.parts.first?.text,
              !txt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { throw GeminiError.empty }

        if debugPrint { print("🔵 Gemini reply\n\(txt)\n———") }
        return txt
    }
}

