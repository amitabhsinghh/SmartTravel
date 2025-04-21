//
//  GeminiService.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/20/25.
//



//
//  GeminiService.swift
//  SmartTravel
//
//  Switched to chat‑bison‑001 + v1 path.
//
import Foundation

enum GeminiService {
    private static let apiKey = ""
    private static let model  = "gemini-2.0-flash"
    private static let url = URL(string:
      "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey)"
    )!

    // ── Request / Response ──
    private struct Request: Encodable {
        struct Message: Encodable {
            let parts: [Part]
        }
        struct Part: Encodable { let text: String }
        let contents: [Message]
    }

    private struct Response: Decodable {
        struct Candidate: Decodable {
            struct Content: Decodable { let parts: [Part] }
            struct Part: Decodable    { let text: String }
            let content: Content
        }
        let candidates: [Candidate]?
    }

    enum GeminiError: LocalizedError {
        case http(Int, String), empty
        var errorDescription: String? {
            switch self {
            case .http(let code, let body): return "HTTP \(code): \(body)"
            case .empty:                   return "No valid response from Gemini"
            }
        }
    }

    /// Sends a plain‑text prompt to Gemini and returns the raw text response.
    static func generateItinerary(
        prompt: String,
        debugPrint: Bool = false
    ) async throws -> String {
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = Request(contents: [
            .init(parts: [.init(text: prompt)])
        ])
        req.httpBody = try JSONEncoder().encode(body)

        let (data, resp) = try await URLSession.shared.data(for: req)

        if let http = resp as? HTTPURLResponse,
           !(200...299).contains(http.statusCode) {
            let bodyText = String(data: data, encoding: .utf8) ?? "<non‑UTF8>"
            throw GeminiError.http(http.statusCode, bodyText)
        }

        let decoded = try JSONDecoder().decode(Response.self, from: data)
        guard let txt = decoded
                .candidates?
                .first?
                .content
                .parts
                .first?
                .text
                .trimmingCharacters(in: .whitespacesAndNewlines),
              !txt.isEmpty
        else {
            throw GeminiError.empty
        }

        if debugPrint {
            print("✅ Gemini Raw Reply:\n\(txt)\n———")
        }
        return txt
    }
}

