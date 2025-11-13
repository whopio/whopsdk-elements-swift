# WhopPayments

The `WhopPayments SDK` provides a simple way to integrate Whop's payouts functionality into your iOS application.

## Install

Add `WhopPayments` to your Swift Package Manager dependencies and pin it to the latest release.

```swift
dependencies: [
    .package(url: "https://github.com/whopio/whopsdk-payments-swift.git", exact: "0.0.6")
]
```

## Add the following usage descriptions

To allow native KYC, the SDK requires your app to add the following usage descriptions to `Info.plist`. Without them the SDK will not work.

```
<key>NSCameraUsageDescription</key>
<string>We use your camera to let you take photos, record videos, and ID verification.</string>
<key>NSMicrophoneUsageDescription</key>
<string>We use your microphone so you can record and share audio, and ID verification.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We use your photo library so you can select and share photos or videos from your library.</string>
```

## Integration Example

```swift
import SwiftUI
import WhopPayments

class MyTokenProvider: WhopTokenProvider {
    /// return an access token fetched from your
    /// backend.
    ///
    /// called when `WhopPayoutsView` appears and
    /// before expiration (within 60 seconds).
    ///
    /// the SDK handles caching and retries with
    /// exponential backoff on failure.
    func getToken() async -> WhopTokenResponse {
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