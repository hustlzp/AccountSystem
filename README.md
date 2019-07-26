# AccountSystem

Account system based on LeanCloud.

Features:

* Sign in & sign up by phone and password.
* Sign in by social accounts: Wechat/QQ/Weibo/Twitter/Facebook).
* Forgot password & reset password.
* Change avatar, nickname, phone, password.
* Support anonymous user.

## Copy files

Copy `Extensions/*`, `Models/*`, `Views/*`, `Controllers/*`, `Constants.swift`, `Utils.swift`, `MyError.swift` and `Assets.xcassets/account` to your project.

## CocoaPods setup

```
pod init
```

In `Podfile`, add sources:

```pod
source 'git@github.com:hustlzp/Specs.git'
source 'https://github.com/CocoaPods/Specs.git'
```

add pods:

```pod
pod 'AVOSCloud', '11.6.4.103'
pod 'SnapKit'
pod 'MBProgressHUD'
pod 'PromiseKit'
pod 'UMCCommon'
pod 'UMCSecurityPlugins'
pod 'UMCAnalytics'
pod 'UMCCommonLog'
pod 'UMCShare/Social/ReducedWeChat'
pod 'UMCShare/Social/ReducedQQ'
pod 'UMCShare/Social/ReducedSina'
pod 'UMCShare/Social/Facebook'
pod 'UMCShare/Social/Twitter'
pod 'RxSwift'
pod 'RxCocoa'
pod 'Localize-Swift'
pod 'ionicons'
```

then:

```
pod install
```

## Bridging header

Create file `YourProject-Bridging-Header.h` with content:

```objc
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
```

In `TARGETS` -> `Build Settings`, search `Objective-C Bridging Header`, fill in `YourProject/YourProject-Bridging-Header.h`.

Note: replace `YourProject` with your project name.

## UMeng setup

[UMeng documents](https://developer.umeng.com/docs/66632/detail/66825)

Add following codes to `AppDelegate.swift` with instructions from [docs](https://developer.umeng.com/docs/66632/detail/66825#h2-u521Du59CBu5316u8BBEu7F6E4):

```swift
UMConfigure.setLogEnabled(true)
UMConfigure.initWithAppkey("", channel: "App Store")
UMSocialManager.default().setPlaform(.wechatSession, appKey: "", appSecret: "", redirectURL: "")
UMSocialManager.default().setPlaform(.QQ, appKey: "", appSecret: nil, redirectURL: nil)
UMSocialManager.default().setPlaform(.sina, appKey: "", appSecret: "", redirectURL: "")
UMSocialManager.default().setPlaform(.facebook, appKey: "", appSecret: nil, redirectURL: nil)
UMSocialManager.default().setPlaform(.twitter, appKey: "", appSecret: "", redirectURL: nil)
```

Handle open url callback in `application(_:open:options:)` in `AppDelegate.swift`:

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    let result = UMSocialManager.default().handleOpen(url, options: options)
    
    if (!result) {
    }
    
    return result
}
```

Open `Info.plist` as source code, add followings to it:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>en</string>
    <string>wechat</string>
    <string>weixin</string>
    <string>sinaweibohd</string>
    <string>sinaweibo</string>
    <string>sinaweibosso</string>
    <string>weibosdk</string>
    <string>weibosdk2.5</string>
    <string>mqqapi</string>
    <string>mqq</string>
    <string>mqqOpensdkSSoLogin</string>
    <string>mqqconnect</string>
    <string>mqqopensdkdataline</string>
    <string>mqqopensdkgrouptribeshare</string>
    <string>mqqopensdkfriend</string>
    <string>mqqopensdkapi</string>
    <string>mqqopensdkapiV2</string>
    <string>mqqopensdkapiV3</string>
    <string>mqqopensdkapiV4</string>
    <string>mqzoneopensdk</string>
    <string>wtloginmqq</string>
    <string>wtloginmqq2</string>
    <string>mqqwpa</string>
    <string>mqzone</string>
    <string>mqzonev2</string>
    <string>mqzoneshare</string>
    <string>wtloginqzone</string>
    <string>mqzonewx</string>
    <string>mqzoneopensdkapiV2</string>
    <string>mqzoneopensdkapi19</string>
    <string>mqzoneopensdkapi</string>
    <string>mqqbrowser</string>
    <string>mttbrowser</string>
    <string>tim</string>
    <string>timapi</string>
    <string>timopensdkfriend</string>
    <string>timwpa</string>
    <string>timgamebindinggroup</string>
    <string>timapiwallet</string>
    <string>timOpensdkSSoLogin</string>
    <string>wtlogintim</string>
    <string>timopensdkgrouptribeshare</string>
    <string>timopensdkapiV4</string>
    <string>timgamebindinggroup</string>
    <string>timopensdkdataline</string>
    <string>wtlogintimV1</string>
    <string>timapiV1</string>
    <string>alipay</string>
    <string>alipayshare</string>
    <string>dingtalk</string>
    <string>dingtalk-open</string>
    <string>linkedin</string>
    <string>linkedin-sdk2</string>
    <string>linkedin-sdk</string>
    <string>laiwangsso</string>
    <string>yixin</string>
    <string>yixinopenapi</string>
    <string>instagram</string>
    <string>whatsapp</string>
    <string>line</string>
    <string>fbapi</string>
    <string>fb-messenger-api</string>
    <string>fbauth2</string>
    <string>fbshareextension</string>
    <string>twitter</string>
    <string>twitterauth</string>
    <string>kakaofa63a0b2356e923f3edd6512d531f546</string>
    <string>kakaokompassauth</string>
    <string>storykompassauth</string>
    <string>kakaolink</string>
    <string>kakaotalk-4.5.0</string>
    <string>kakaostory-2.9.0</string>
    <string>pinterestsdk.v1</string>
    <string>tumblr</string>
    <string>evernote</string>
    <string>en</string>
    <string>enx</string>
    <string>evernotecid</string>
    <string>evernotemsg</string>
    <string>youdaonote</string>
    <string>ynotedictfav</string>
    <string>com.youdao.note.todayViewNote</string>
    <string>ynotesharesdk</string>
    <string>gplus</string>
    <string>pocket</string>
    <string>readitlater</string>
    <string>pocket-oauth-v1</string>
    <string>fb131450656879143</string>
    <string>en-readitlater-5776</string>
    <string>com.ideashower.ReadItLaterPro3</string>
    <string>com.ideashower.ReadItLaterPro</string>
    <string>com.ideashower.ReadItLaterProAlpha</string>
    <string>com.ideashower.ReadItLaterProEnterprise</string>
    <string>vk</string>
    <string>vk-share</string>
    <string>vkauthorize</string>
</array>
```

Update URL Types in `TARGETS` -> `Info`, see [here](https://developer.umeng.com/docs/66632/detail/66825#h3--url-scheme).


## LeanCloud setup

Add following codes to `AppDelegate.swift`:

```swift
AVOSCloud.setApplicationId("", clientKey: "")
User.registerSubclass()
```

Add `didBindQQ`, `didBindWeibo`, `didBindWechat`, `didBindTwitter`, `didBindFacebook` to `_User` table in LeanCloud console.

Fill in IDs, keys and secrets in `组件` -> `社交` in LeanCloud console.

Uncheck `密码修改后，强制客户端重新登录` in `存储` -> `设置` in LeanCloud console.

Check `启用通用的短信验证码服务` in `消息` -> `短信` -> `设置` in LeanCloud console.

Apply for `短信签名` in `消息` -> `短信` -> `设置` in LeanCloud console.

Update `applicationName` in function `sendCode` in `Views/PhoneFieldWithSendCodeButton.swift`. 

Add two cloud functions:

```ts
/**
 * 检查手机号是否存在
 * @function checkPhoneExist
 * @param {string} phone
 * @return {boolean}
 */
const checkPhoneExist: AV.Cloud.CloudFunction = async (request) => {
    let phone = request.params.phone

    checkParameters(request, ["phone"])

    let query = new Query(User)
    query.equalTo('mobilePhoneNumber', phone)

    return (await query.count()) > 0
}
AV.Cloud.define('checkPhoneExist', checkPhoneExist)

/**
 * 重置密码
 * @function resetPassword
 * @param {string} phone
 * @param {string} password
 */
const resetPassword: AV.Cloud.CloudFunction = async (request) => {
    let phone = request.params.phone
    let password = request.params.password

    checkParameters(request, ["phone", "password"])

    let query = new Query(User)
    query.equalTo('mobilePhoneNumber', phone)

    let user = await query.first()

    if (!user) {
        throw new AV.Cloud.Error('用户不存在')
    }

    user.setPassword(password)

    return user.save()
}
AV.Cloud.define('resetPassword', resetPassword)
```

## Other

Add following to `Info.plist` as source code:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
<key>NSPhotoLibraryUsageDescription</key>
<string>上传头像</string>
```
