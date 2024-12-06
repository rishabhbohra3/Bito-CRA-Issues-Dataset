#import <Foundation/Foundation.h>

// Hardcoded OpenAI API Key (not recommended)
NSString *apiKey = @"sk-utRJzHluRSPOljnDhnORT4BlbkFJkPSHrIf2MqUIs2rAfUY7";

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Ensure API key is set
        if (apiKey == nil || [apiKey length] == 0) {
            NSLog(@"Error: OpenAI API key is not set.");
            return 1;
        }

        // API Endpoint
        NSURL *url = [NSURL URLWithString:@"https://api.openai.com/v1/completions"];

        // Data to send in the API request
        NSDictionary *requestData = @{
            @"model": @"text-davinci-003",
            @"prompt": @"Once upon a time",
            @"max_tokens": @50
        };

        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:&error];
        if (!jsonData) {
            NSLog(@"Error serializing JSON: %@", error);
            return 1;
        }

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", apiKey];
        [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];

        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                if (!json) {
                    NSLog(@"Error parsing JSON: %@", jsonError);
                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"Response: %@", responseString);
                } else {
                    NSArray *choices = json[@"choices"];
                    if (choices.count > 0) {
                        NSString *text = choices[0][@"text"];
                        NSLog(@"Response from OpenAI:\n%@", text);
                    } else {
                        NSLog(@"No choices found in response.");
                    }
                }
            }
            dispatch_semaphore_signal(semaphore);
        }];

        [task resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    return 0;
}
