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
    .package(url: "https://github.com/whopio/whopsdk-elements-swift.git", exact: "0.1.16")
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
| **BalanceElement** | Token Provider | Backend-generated tokens for your company |
| **ListElement** | Token Provider | Backend-generated tokens for your company |
| **ActivityElement** | Token Provider | Backend-generated tokens for your company |
| **AddressElement** | None | Collects an address locally; nothing is read from Whop |
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

## Wallet Components

Three views onto a company ledger: the total-balance chart, the balance list, and the
activity feed. They authenticate the same way as `WhopPayoutsView` — a company access token
supplied through `WhopSDK.configure(tokenProvider:)` — and compose freely, so you can build a
full balance screen or drop in a single piece.

### Example

```swift
import SwiftUI
import WhopElements

struct WalletExample: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                BalanceElement(accountId: "biz_xxxxxxxx")

                ListElement(accountId: "biz_xxxxxxxx") { balance in
                    print(balance.displayName, balance.amountUsd)
                }

                ActivityElement(accountId: "biz_xxxxxxxx") { activity in
                    print(activity.title, activity.amount)
                }
            }
            .padding(16)
        }
        .task {
            await WhopSDK.configure(tokenProvider: WalletTokenProvider())
        }
    }
}
```

### BalanceElement

Total balance over time, with the headline value, period delta, and 1D/1W/1M/1Y/ALL range
pills. Press and hold the chart to scrub; the headline follows the bucket under your finger.

| Parameter | Description |
|-----------|-------------|
| `accountId` | Whose money the view reads: a company's `biz_…` tag or a user's own `user_…` tag |
| `currency` | Currency code, defaults to "usd" |

### ListElement

The ledger's fiat and crypto balances, sorted by USD value.

| Parameter | Description |
|-----------|-------------|
| `accountId` | Whose money the view reads: a company's `biz_…` tag or a user's own `user_…` tag |
| `onBalanceSelected` | Called with the tapped `WalletBalance`. Omit it to render the list non-interactively |

### ActivityElement

The company's posted activity, paged as it scrolls. Loading, empty and error states are built in.

| Parameter | Description |
|-----------|-------------|
| `accountId` | A company's `biz_…` tag or a user's own `user_…` tag |
| `showsTitle` | Renders the "Activity" heading, defaults to `true` |
| `onActivitySelected` | Called with the tapped `WalletActivity` |

---

## AddressElement

Collects a billing or shipping address. Which fields appear, in what order, which of them are
required and how the postal code is validated all follow the selected country's format — a
German address asks for a postal code then a city, a Japanese one for a prefecture, an Irish one
for an Eircode. The street field suggests addresses as the buyer types; picking one fills the rest.
The country picker sits at the bottom, where every address form in the app already keeps it, and
starts on the device's region.

It needs no token, so it renders before (or entirely without) `WhopSDK.configure`.

### Example

```swift
import SwiftUI
import WhopElements

struct AddressExample: View {
    @State private var address = AddressElementManager()

    var body: some View {
        VStack(spacing: 24) {
            AddressElement(manager: address) { snapshot in
                print(snapshot.isComplete, snapshot.address.postalCode ?? "")
            }

            Button("Continue") {
                let result = address.validate()
                guard result.isComplete else { return }
                submit(result.address)
            }
            .disabled(!address.isComplete)
        }
    }
}
```

### Parameters

| Parameter | Description |
|-----------|-------------|
| `manager` | An `AddressElementManager` to read and validate the address from outside the element |
| `layout` | `.full` (default) labels every field; `.compact` moves the labels into placeholders |
| `scope` | `.full` (default) collects the country's whole format; `.minimal` collects country and postal code only |
| `name` | `.combined` (default) one full-name field, `.split` first and last, or `.none` |
| `organization` | `.none` (default), `.name`, or `.nameWithType` for a business/individual select |
| `line2` | `.always` (default), `.toggle` to reveal it with a button, or `.never` |
| `defaultValues` | A `WhopAddress` to start from; its `country` is ISO2 and beats country detection |
| `detectCountry` | Start on the device's region, defaults to `true`. Falls back to `countryHint`, then US |
| `allowedCountries` | Restrict the country picker to these ISO2 codes |
| `countryHint` | ISO2 fallback for the country chain, e.g. derived from a checkout currency |
| `autocomplete` | Street suggestions as the buyer types, from MapKit, defaults to `true`. With it on, the city, subdivision and postal-code fields wait until the buyer leaves the street field, picks a suggestion, or taps "Enter address manually"; with it off they are all shown from the start |
| `onChange` | Called on every edit with a `WhopAddressSnapshot` |

### AddressElementManager

| Member | Description |
|--------|-------------|
| `validate()` | Validates every field, reveals the errors inline, and returns the snapshot. Never throws |
| `address` | The current `WhopAddress` |
| `isComplete` | Whether every field the selected country requires is filled and valid |
| `snapshot` | The latest `WhopAddressSnapshot`: the address, `isComplete`, and the errors |

`WhopAddress` encodes to the same JSON keys as the web `AddressElement` (`postal_code`,
`first_name`, ISO2 `country`), so one payload shape works on both platforms.

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
                case let .profileTap(username, userId):
                    print("Profile tapped: \(username), userId: \(userId)")
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
    case profileTap(username: String, userId: String)  // User tapped a profile
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

- iOS 18.0+
- Xcode 16.4+
- Swift 5.10+
