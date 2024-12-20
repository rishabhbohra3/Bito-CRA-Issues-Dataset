 <?php
// Load API key from environment variable
$apiKey = getenv('OPENAI_API_KEY') ?: die('OPENAI_API_KEY environment variable is not set');
 
// API Endpoint
$url = "https://api.openai.com/v1/completions";

// Data to send in the API request
$data = array(
    "model" => "text-davinci-003",
    "prompt" => "Once upon a time",
    "max_tokens" => 50
);

// Initialize cURL
$ch = curl_init($url);

// Set cURL options
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
curl_setopt($ch, CURLOPT_HTTPHEADER, array(
    "Content-Type: application/json",
    "Authorization: Bearer $apiKey"
));

// Execute cURL request
$response = curl_exec($ch);

// Check for errors
if ($response === FALSE) {
    $error = curl_error($ch);
    error_log("OpenAI API Error: " . $error);
    throw new Exception("Failed to call OpenAI API: " . $error);
}

// Close cURL
curl_close($ch);

// Decode and print the response
$responseData = json_decode($response, true);
if (isset($responseData['choices'][0]['text'])) {
    echo $responseData['choices'][0]['text'];
} else {
    echo 'No valid response text received';
}
?>
