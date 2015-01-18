//
//  MobileBuilder.h
//  MobileBuilder
//
//  Created by Viktor Todorov on 7/24/14.
//  Copyright (c) 2014 Viktor Todorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>
#import "Chartboost.h"
#import <VungleSDK/VungleSDK.h>
#import <RevMobAds/RevMobAds.h>
#import "Reachability.h"
#import <AVFoundation/AVFoundation.h>
#import <iAd/iAd.h>
#import "GADBannerView.h"
#import "ALSdk.h"
#import "ALInterstitialAd.h"

UIKIT_EXTERN NSString *const IAUtilsProductPurchasedNotification;
UIKIT_EXTERN NSString *const IAUtilsFailedProductPurchasedNotification;

@interface MobileBuilder : NSObject <GKGameCenterControllerDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate,MFMailComposeViewControllerDelegate, ChartboostDelegate,VungleSDKDelegate,RevMobAdsDelegate, AVAudioPlayerDelegate,ADBannerViewDelegate, GADBannerViewDelegate, UIAlertViewDelegate> {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    UIViewController* temporaryController;
    NSString* admobID;
    UIImageView* imageView;
    NSString* customPopUpURL;
    NSString* appid;
    UIActivityIndicatorView *hLoadingActivityView;
    UIView *hLoadingView;
    UILabel *hLoadingLabel;

}
@property (assign, readonly) BOOL gameCenterAvailable;
@property (nonatomic, strong) NSArray* leaderboards;
@property (nonatomic, strong) NSMutableDictionary *achievementsDictionary;
@property (strong, nonatomic) AVAudioPlayer *soundPlayer;
@property (nonatomic, strong) ADBannerView *bannerView;
@property (nonatomic, strong) GADBannerView *admobBannerView;
@property (nonatomic, retain) MPMoviePlayerController* player;

+ (MobileBuilder*)startBuilding;

//**********************************************************//
//************ SOCIAL FACEBOOK & TWITTER & MAIL ************//
//**********************************************************//

//Show Twitter
- (void)ShowTwitter: (int) yourScore viewControoler:(UIViewController*)controller image:(NSString*)image url:(NSString*)url message:(NSString*)message;

//Show Facebook
- (void)ShowFacebook: (int) yourScore viewControoler:(UIViewController*)controller image:(NSString*)image url:(NSString*)url message:(NSString*)message;

//Show Email
- (void)ShowMail: (int) yourScore viewControoler:(UIViewController*)controller;

//**********************************************************//
//********************* GAME CENTER ************************//
//**********************************************************//

//Authenticate the Game Center (MUST PUT IT ON YOUR MAIN MENU)
- (void)authenticateLocalUserOnViewController:(UIViewController*)viewController
                            setCallbackObject:(id)obj
                            withPauseSelector:(SEL)selector;
//--------------------------------------------------------------------------------//

//Report your score in game center
- (void)reportScore:(int64_t)score forLeaderboardID:(NSString*)identifier;
//--------------------------------------------------------------------------------//

//Show the leaderboard
- (void)showLeaderboardOnViewController:(UIViewController*)viewController;
//--------------------------------------------------------------------------------//

- (void)reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent;
- (GKAchievement*)getAchievementForIdentifier: (NSString*) identifier;
- (void)resetAchievements;
- (void)completeMultipleAchievements:(NSArray*)achievements;
- (void)registerListener:(id<GKLocalPlayerListener>)listener;

//**********************************************************//
//********************* IN-APP PURCHASES *******************//
//**********************************************************//

-(void)removeAds:(NSString*)inAppID;
-(void)restorePurchase;

//**********************************************************//
//********************* ADVERTISEMENT **********************//
//**********************************************************//

//AppLovin
-(void)initialiseAppLovin;
-(void)appLovinShowInterstitial;

//Chartboost
-(void)initialiseChartboost: (NSString*)appID appSignute:(NSString*)appSigniture;
-(void)chartboostShowAd;
-(void)chartboostshowMoreApps;

//Revmob
-(void)initialiseRevMob: (NSString*)appID testMode:(BOOL)testModeEnable;
-(void)revmobShowBanner;
-(void)revmobShowAd;
-(void)revmobShowPopUp;

//Admob
//put it in app delegate !
-(void)loadAdMobIfiADFAILS:(NSString*)appID controller:(UIViewController*)controller;
-(void)admobStart:(NSString*)appID controller:(UIViewController*)controller;

//iAD
-(void)iAdStart: (UIViewController*)controller;

//Vungle
-(void)initialiseVungle: (NSString*)appID;
-(void)vunglePlayVideoAd: (UIViewController*)controller;

//********************************************************//
//********************* SOUND EFFECTS ********************//
//********************************************************//
-(void)playSound :(NSString*)soundName type:(NSString*)soundType;

//**********************************************************************//
//********************* GRAPHICAL ANIMATION EFFECTS ********************//
//**********************************************************************//

// 0 - Slide -> From left or right or top or bottom
// 1 - Fade In
// 2 - Fade Out
// 3 - Fade Out and when finish fade In
// 4 - Bounce
// 5 - Slide and Shake
// 6 - Fade in and Bounce
// 7 - Shake
// 8 - Rotate
// 9 - Jump

//0-
-(void)move:(UIView *)image duration:(NSTimeInterval)duration curve:(int)curve x:(CGFloat)x y:(CGFloat)y;

//1-
-(void)fadeIn: (UIView*)theView duration:(float)duration delay:(float)delay;

//2-
-(void)fadeOut: (UIView*)theView duration:(float)duration delay:(float)delay;

//3-
-(void)fadeOutIn: (UIView*)theView duration:(float)duration delay:(float)delay;

//4-
-(void)bounce: (UIView*)theView repeat:(int)repeats duration:(int)duration distance:(int)distance horizontal:(BOOL)horizontal vertical:(BOOL)vertical;

//5-
-(void)moveAndShake:(UIView *)image duration:(NSTimeInterval)duration curve:(int)curve x:(CGFloat)x y:(CGFloat)y;

//6-
-(void)fadeInAndBounce: (UIView*)theView duration:(float)duration delay:(float)delay numberOfBounces:(int)bounces;

//7-
-(void)shake: (UIView*)theView;

//8-
-(void)runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;

//9-
-(void)jump: (UIView*)view_ duration:(float)duration distance:(int)distance;


//****************************************************//
//********************* UTILITIES ********************//
//****************************************************//

//Read From Plist File and return NSDictionary
-(NSMutableDictionary*)readFromPlist: (NSString*)plistFile;

//Radio Stream -> just place the radio URL or Load one from plist
-(void)playRadioStream: (NSString*)url;
-(void)stopRadioStream;
-(void)continueRadioStream;

//Play YouTube Video
-(void)playYouTubeVideo: (NSString*)link webView:(UIWebView*)webView;

//Rate the App
-(void)rateTheApp: (NSString*)url;
-(void)rateTheAppMessage: (NSString*)appID gameName:(NSString*)gameName;

//Switch The ViewController
-(void)switchFromToViewController:(UIViewController*)controller toViewConttroller:(UIViewController*)toController id:(NSString*)controllerID;

//Activity Indicator
-(void)startTheLoadingActivityView: (UIViewController*)controller;
-(void)removeTheLoadingView;

//****************************************************//
//********************* POP UPS **********************//
//****************************************************//

-(void)createCustomPopUpInterstitial: (NSString*)imageName viewController:(UIViewController*)controller appID:(NSString*)appID_;
-(void)createCustomPopUpInterstitialWithURL: (NSString*)imageName viewController:(UIViewController*)controller url:(NSString*)url_;

//****************************************************//
//*************** Local Notifications ****************//
//****************************************************//
-(void)createLocalNotification: (NSString*)message minutes:(float)minutes;


@end
