import Foundation

// Hardcoded OpenAI API Key (not recommended)
let apiKey = "sk-utRJzHluRSPOljnDhnORT5BlbkFJkPSHrIf6MqUIs1rAfUY0"

// API Endpoint
let url = URL(string: "https://api.openai.com/v1/completions")!

// Data to send in the API request
let requestData: [String: Any] = [
    "model": "text-davinci-003",
    "prompt": "Once upon a time",
    "max_tokens": 50
]

// Serialize request data to JSON
guard let jsonData = try? JSONSerialization.data(withJSONObject: requestData, options: []) else {
    print("Error: Unable to serialize request data.")
    exit(1)
}

// Prepare the URLRequest
var request = URLRequest(url: url)
request.httpMethod = "POST"
request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpBody = jsonData

// Create a semaphore to wait for the async task
let semaphore = DispatchSemaphore(value: 0)

// Perform the request
let task = URLSession.shared.dataTask(with: request) { data, response, error in
    defer { semaphore.signal() }

    if let error = error {
        print("Error: \(error)")
        return
    }

    guard let data = data else {
        print("No data received")
        return
    }

    // Decode and print the response
    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let choices = json["choices"] as? [[String: Any]],
           let text = choices.first?["text"] as? String {
            print("Response from OpenAI:")
            print(text)
        } else {
            print("Unexpected response format")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
        }
    } catch {
        print("Error decoding response: \(error)")
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)")
        }
    }
}

task.resume()

// Wait for the request to complete
semaphore.wait()
