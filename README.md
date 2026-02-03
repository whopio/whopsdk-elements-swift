# WhopElements

The `WhopElements SDK` provides a simple way to integrate Whop's features into your iOS application:

- **WhopPayoutsView** - Payouts and withdrawal management
- **WhopChatView** - Real-time chat messaging
- **WhopDMsListView** - Direct messages list

For full documentation, visit [docs.whop.com](https://docs.whop.com/developer/guides/ios/installation#whopelements-embedded-chat-payouts).

## Install

Add `WhopElements` to your Swift Package Manager dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/whopio/whopsdk-elements-swift.git", exact: "0.0.16")
]
```

## Info.plist Requirements

The SDK requires the following usage descriptions for KYC and media features:

```xml
<key>NSCameraUsageDescription</key>
<string>We use your camera to let you take photos, record videos, and ID verification.</string>
<key>NSMicrophoneUsageDescription</key>
<string>We use your microphone so you can record and share audio, and ID verification.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We use your photo library so you can select and share photos or videos from your library.</string>
```

## Authentication

The SDK supports two authentication methods depending on which features you use:

| Feature | Auth Method | Use Case |
|---------|-------------|----------|
| **WhopPayoutsView** | Token Provider | Backend-generated tokens for your company |
| **WhopChatView** | OAuth | User authentication via Whop login |
| **WhopDMsListView** | OAuth | User authentication via Whop login |

---

## WhopPayoutsView

Displays the payouts management interface for withdrawals and earnings.

### Setup

1. Generate an access token from your backend using the [Create Access Token API](https://docs.whop.com/api-reference/access-tokens/create-access-token)
2. Create a token provider that returns the token
3. Configure the SDK before displaying the view

### Example

```swift
import SwiftUI
import WhopElements

class PayoutsTokenProvider: WhopTokenProvider {
    /// For Payouts and Checkout, you can use a token linked to your company.
    /// Fetch it in your backend using https://docs.whop.com/api-reference/access-tokens/create-access-token
    func getToken() async -> WhopTokenResponse {
        let token = await fetchAccessToken()
        return WhopTokenResponse(accessToken: token)
    }
}

struct WhopPayoutsExample: View {
    var body: some View {
        WhopPayoutsView(
            thirdPartyClient: "My Company Name",
            companyId: "biz_xxxxxxxx",
            ledgerAccountId: "ldgr_xxxxxxxx"
        )
        .task {
            // Ideally initialize as early as possible so views don't wait
            await WhopSDK.configure(tokenProvider: PayoutsTokenProvider())
        }
    }
}
```

### Parameters

| Parameter | Description |
|-----------|-------------|
| `thirdPartyClient` | Your company name displayed in the UI |
| `companyId` | Your Whop company ID (biz_xxx) |
| `ledgerAccountId` | The ledger account ID (ldgr_xxx) |
| `currency` | Currency code, defaults to "usd" |

---

## WhopChatView

Displays a real-time chat interface with support for different visual styles.

### Setup

1. Register your app in your company's dashboard to get an app ID: `https://whop.com/dashboard/biz_XXXXXXXXXXXXXX/developer/`
2. Inside the app you created, go to OAuth and add the required scopes: `https://whop.com/dashboard/biz_XXXXXXXXXXXXXX/developer/apps/app_XXXXXXXXXXXXXX/`
3. In the same page, add a redirect URL with your bundle ID: `com.yourapp://oauth/callback`
4. In your code, call `WhopSDK.configureWithOAuth(...)` as soon as possible

### Example

```swift
import SwiftUI
import WhopElements

struct WhopChatExample: View {
    var body: some View {
        WhopChatView(
            channelId: "chat_xxxxxxxxxxxxxxxxx",
            style: .imessage,
            onEvent: { event in
                switch event {
                case let .profileTap(username):
                    print("Profile tapped: \(username)")
                case let .urlTap(url):
                    print("URL tapped: \(url)")
                case let .messageSent(content):
                    print("Message sent: \(content)")
                }
            }
        )
        .task {
            // Ideally initialize as early as possible so views don't wait
            await WhopSDK.configureWithOAuth(appId: "app_XXXXXXXXXXXXXX")
        }
    }
}
```

### Parameters

| Parameter | Description |
|-----------|-------------|
| `channelId` | Chat channel ID (chat_xxx) or DM feed ID (feed_xxx) |
| `deeplinkToPostId` | Optional post ID to scroll to |
| `style` | `.imessage` or `.discord` visual style |
| `onEvent` | Callback for chat events |

### Chat Events

```swift
public enum ChatEvent {
    case profileTap(username: String)  // User tapped a profile
    case urlTap(url: URL)              // User tapped a link
    case messageSent(content: String)  // User sent a message
}
```

### Chat Styles

| Style | Description |
|-------|-------------|
| `.imessage` | Bubble-style messages (default) |
| `.discord` | Discord-style compact messages |

---

## WhopDMsListView

Displays a list of direct message conversations.

### Example

```swift
import SwiftUI
import WhopElements

struct WhopDMsListExample: View {
    @State private var selectedChannel: DMChannel?

    var body: some View {
        WhopDMsListView { event in
            switch event {
            case let .channelSelected(channel):
                selectedChannel = channel
            }
        }
        .navigationTitle("Messages")
        .navigationDestination(item: $selectedChannel) { channel in
            WhopChatView(channelId: channel.id, style: .imessage)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(channel.name)
        }
        .task {
            // Ideally initialize as early as possible so views don't wait
            await WhopSDK.configureWithOAuth(appId: "app_XXXXXXXXXXXXXX")
        }
    }
}
```

### DMChannel Properties

```swift
public struct DMChannel: Identifiable, Hashable {
    public let id: String
    public let name: String
    public let isGroup: Bool
    public let isUnread: Bool
    public let lastMessageText: String?
    public let lastMessageCreatedAt: Date
    public let isSupportTicket: Bool
}
```

---

## OAuth Authentication

For Chat and DMs features, configure OAuth at app launch. When the user navigates to an authenticated view (like Chat or DMs), the SDK automatically triggers the OAuth flow if not already authenticated.

```swift
// At app launch
await WhopSDK.configureWithOAuth(appId: "app_XXXXXXXXXXXXXX")

// Check authentication state
if WhopSDK.isAuthenticated {
    // User is logged in
}

// Manual sign in (optional - all chat components will open the OAuth flow if not authenticated)
try await WhopSDK.signIn()

// Sign out
WhopSDK.signOut()
```

### Track Authentication State

```swift
@State private var isAuthenticated = false

var body: some View {
    MyView()
        .whopAuthState($isAuthenticated)
}
```

### OAuth Setup Checklist

1. Register your app in your company's dashboard: `https://whop.com/dashboard/biz_XXXXXXXXXXXXXX/developer/`
2. Inside the app > OAuth, add the required scopes: `https://whop.com/dashboard/biz_XXXXXXXXXXXXXX/developer/apps/app_XXXXXXXXXXXXXX/`
3. Add a redirect URL with your bundle ID: `com.yourapp://oauth/callback`
4. Call `WhopSDK.configureWithOAuth(appId:)` as early as possible in your app

---

## Requirements

- iOS 17.0+
- Xcode 16.4+
- Swift 5.10+
