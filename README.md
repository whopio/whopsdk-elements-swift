# WhopPayments

The WhopPayments SDK provides a simple way to integrate Whop's payouts functionality into your iOS application.

## Integration Example

```swift
import SwiftUI
import WhopPayments

class MyTokenProvider: WhopTokenProvider {
    func getToken() async -> WhopTokenResponse {
        // Fetch your access token from your backend
        let token = await fetchAccessToken()
        return WhopTokenResponse(accessToken: token)
    }
}

@main
struct MyApp: App {
    let tokenProvider = MyTokenProvider()

    var body: some Scene {
        WindowGroup {
            WhopPayoutsView(
                tokenProvider,
                companyId: "company_id",
                ledgerAccountId: "ledger_account_id"
            )
        }
    }
}
```

## Requirements

- iOS 17.0+
- Xcode 16.4+
- Swift 5.10+