//
//  MobileBuilder.m
//  MobileBuilder
//
//  Created by Viktor Todorov on 7/24/14.
//  Copyright (c) 2014 Viktor Todorov. All rights reserved.
//

#import "MobileBuilder.h"
#import "Reachability.h"
#import <Social/Social.h>
#define IS_IPHONE5 (fabs ( (double) [ [UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

static MobileBuilder *_shared = NULL;
NSString *kLeaderBoardIdentifier = @"55077026";

NSString *const IAUtilsProductPurchasedNotification = @"IAUtilsProductPurchasedNotification";
NSString *const IAUtilsFailedProductPurchasedNotification = @"IAUtilsFailedProductPurchasedNotification";

@implementation MobileBuilder {
    bool _transactionGoing;
}
@synthesize gameCenterAvailable;
@synthesize bannerView = _bannerView;
@synthesize admobBannerView = _admobBannerView;
@synthesize player = _player;

+ (MobileBuilder*)startBuilding {
    if (_shared == NULL)
    {
        _shared = [[MobileBuilder alloc] init];
    }
    
    return _shared;
}
#pragma mark SOCIAL
- (void)ShowTwitter: (int) yourScore viewControoler:(UIViewController*)controller image:(NSString*)image url:(NSString*)url message:(NSString*)message {
    
    NSLog(@"Starting Twitter.....");
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        NSLog(@"There IS NO internet connection");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"No internet connection. Please try again later!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    } else {
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            NSString *_myTweetMsg = [NSString stringWithFormat:@"%@ %d",message,yourScore];
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:_myTweetMsg];
            [tweetSheet addImage:[UIImage imageNamed:image]];
            [tweetSheet addURL:[NSURL URLWithString:url]];
            //[self.view.window.rootViewController  presentViewController:tweetSheet animated:YES completion:nil]; - for SpriteKit & Cocos2d
            [controller presentViewController:tweetSheet animated:YES completion:nil];
            
            
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry"
                                      message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
    
}
- (void)ShowFacebook: (int) yourScore viewControoler:(UIViewController*)controller image:(NSString*)image url:(NSString*)url message:(NSString*)message{
    NSLog(@"Starting Facebook..... ");
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"No internet connection. Please try again later!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    } else {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *controllera = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            NSString *_myFacebookMsg = [NSString stringWithFormat:@"%@ %d",message,yourScore];
            
            [controllera setInitialText:_myFacebookMsg];
            [controllera addURL:[NSURL URLWithString:url]];
            [controllera addImage:[UIImage imageNamed:image]];
            
            
            //[self.view.window.rootViewController  presentViewController:controller animated:YES completion:nil]; - for SpriteKit & Cocos2d
            [controller presentViewController:controllera animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry"
                                      message:@"You can't share to Facebook right now, make sure you have set up at least 1 Facebook Account from Settigns!"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
        
        
    }
    
    
}
- (void)ShowMail: (int) yourScore viewControoler:(UIViewController*)controller{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"No internet connection. Please try again later!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    } else {
        // Email Subject
        NSString *emailTitle = @"Camelemento Image";
        // Email Content
        NSString *score = [NSString stringWithFormat:@"Check out my score: %d", yourScore];
        NSString *messageBody = score;
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:@"EMAIL TO?"];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        //[mc addAttachmentData:UIImageJPEGRepresentation(myImage, 1) mimeType:@"image/jpeg" fileName:@"MyFile.jpeg"];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        //[self.view.window.rootViewController  presentViewController:mc animated:YES completion:nil]; - for SpriteKit & Cocos2d
        [controller presentViewController:mc animated:YES completion:nil];
    }
    
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [controller dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark GAME CENTER
#pragma mark -
- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        
        if (gameCenterAvailable) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
            _transactionGoing = false;
            [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
        }
    }
    return self;
}

- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

#pragma mark Authentication

- (void)authenticationChanged {
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;
        
        [self loadLeaderBoardInfo];
        [self loadAchievements];
        
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated.");
        userAuthenticated = FALSE;
    }
}

- (void)authenticateLocalUserOnViewController:(UIViewController*)viewController
                            setCallbackObject:(id)obj
                            withPauseSelector:(SEL)selector
{
    if (!gameCenterAvailable) return;
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    NSLog(@"Authenticating local user...");
    if (localPlayer.authenticated == NO) {
        [localPlayer setAuthenticateHandler:^(UIViewController* authViewController, NSError *error) {
            if (authViewController != nil) {
                if (obj) {
                    [obj performSelector:selector withObject:nil afterDelay:0];
                }
                
                [viewController presentViewController:authViewController animated:YES completion:^ {
                }];
            } else if (error != nil) {
                // process error
            }
        }];
    }
    else {
        NSLog(@"Already authenticated!");
    }
}

#pragma mark Leaderboards

- (void)loadLeaderBoardInfo
{
    [GKLeaderboard loadLeaderboardsWithCompletionHandler:^(NSArray *leaderboards, NSError *error) {
        self.leaderboards = leaderboards;
    }];
}

- (void)reportScore:(int64_t)score forLeaderboardID:(NSString*)identifier
{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
        if (error == nil) {
            NSLog(@"Score reported successfully!");
        } else {
            NSLog(@"Unable to report score!");
        }
    }];
}

- (void)showLeaderboardOnViewController:(UIViewController*)viewController
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil) {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.leaderboardIdentifier = kLeaderBoardIdentifier;
        
        [viewController presentViewController: gameCenterController animated: YES completion:nil];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark Achievements

- (void)reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent
{
    GKAchievement *achievement = [self getAchievementForIdentifier:identifier];
    if (achievement && achievement.percentComplete != 100.0) {
        achievement.percentComplete = percent;
        achievement.showsCompletionBanner = YES;
        
        [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Error while reporting achievement: %@", error.description);
            }
        }];
    }
}

- (void)loadAchievements
{
    self.achievementsDictionary = [[NSMutableDictionary alloc] init];
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        if (error != nil) {
            // Handle the error.
            NSLog(@"Error while loading achievements: %@", error.description);
        }
        else if (achievements != nil) {
            // Process the array of achievements.
            for (GKAchievement* achievement in achievements)
                self.achievementsDictionary[achievement.identifier] = achievement;
        }
    }];
}

- (GKAchievement*)getAchievementForIdentifier: (NSString*) identifier
{
    GKAchievement *achievement = [self.achievementsDictionary objectForKey:identifier];
    if (achievement == nil) {
        achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        self.achievementsDictionary[achievement.identifier] = achievement;
    }
    return achievement;
}

- (void)resetAchievements
{
    // Clear all locally saved achievement objects.
    self.achievementsDictionary = [[NSMutableDictionary alloc] init];
    // Clear all progress saved on Game Center.
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
     {
         if (error != nil) {
             // handle the error.
             NSLog(@"Error while reseting achievements: %@", error.description);
             
         }
     }];
}

- (void)completeMultipleAchievements:(NSArray*)achievements
{
    [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error while reporting achievements: %@", error.description);
        }
    }];
}

#pragma mark Challenges

- (void)registerListener:(id<GKLocalPlayerListener>)listener
{
    [[GKLocalPlayer localPlayer] registerListener:listener];
}

#pragma mark In-app Purchases
#pragma mark -
-(void)removeAds:(NSString *)inAppID{
    if (!_transactionGoing) {
        SKProductsRequest *request= [[SKProductsRequest alloc]
                                     initWithProductIdentifiers: [NSSet setWithObject:inAppID]];
        request.delegate = self;
        [request start];
        _transactionGoing = true;
    }
}
-(void)restorePurchase{
    if (!_transactionGoing) {
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        _transactionGoing = true;
    }
}
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *myProduct = response.products;
    if ([myProduct count] > 0) {
        NSLog(@"%@",[[myProduct objectAtIndex:0] productIdentifier]);
        
        NSDecimalNumber *price = [[myProduct objectAtIndex:0] price];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:[[myProduct objectAtIndex:0] priceLocale]];
        NSString *formattedString = [numberFormatter stringFromNumber:price];
        NSLog(@"Price: %@",formattedString);
        if ([SKPaymentQueue canMakePayments]) {
            SKPayment *newPayment = [SKPayment paymentWithProduct:[myProduct objectAtIndex:0]];
            [[SKPaymentQueue defaultQueue] addPayment:newPayment];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Your Device Limited" message:@"we have noticed that you device restrictions setting are currently limited. you can change it ny going to Settings -> General -> Restrictions and turn it off" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
            
        }
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Notification" message:@"In app purchases comming soon!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }
}
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"Transaction Completed");
    
    // You can create a method to record the transaction.
    // [self recordTransaction: transaction];
    NSLog(@"Identifier %@",transaction.transactionIdentifier);
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    _transactionGoing = false;
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isPurchase"];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAUtilsProductPurchasedNotification object:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Successful"
                                                    message:@"Enjoy without Ads."
                                                   delegate:self
                                          cancelButtonTitle:@"Sweet"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    _transactionGoing = false;
    [[NSNotificationCenter defaultCenter] postNotificationName:IAUtilsProductPurchasedNotification object:nil];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isPurchase"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restore Successful"
                                                    message:@"Enjoy without Ads."
                                                   delegate:self
                                          cancelButtonTitle:@"Sweet"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Unsuccessful"
                                                        message:@"Your purchase failed. Please try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    _transactionGoing = false;
    [[NSNotificationCenter defaultCenter]postNotificationName:IAUtilsFailedProductPurchasedNotification object:nil];
}
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    _transactionGoing = false;
    [[NSNotificationCenter defaultCenter]postNotificationName:IAUtilsFailedProductPurchasedNotification object:nil];
}
- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    if (queue.transactions.count > 0) {
        return;
    }
    else {
        [[NSNotificationCenter defaultCenter]postNotificationName:IAUtilsFailedProductPurchasedNotification object:nil];
        _transactionGoing = false;
    }
}
#pragma mark AD NETWORKS
#pragma mark -

//Applovin
-(void)initialiseAppLovin {
    [ALSdk initializeSdk];
}
-(void)appLovinShowInterstitial {
    [ALInterstitialAd showOver:[[UIApplication sharedApplication] keyWindow]];
}

//Chartboost
-(void)initialiseChartboost: (NSString*)appID appSignute:(NSString*)appSigniture {
     [Chartboost startWithAppId:appID appSignature:appSigniture delegate:self];
}
-(void)chartboostShowAd {
    [[Chartboost sharedChartboost] showInterstitial:CBLocationHomeScreen];
}
-(void)chartboostshowMoreApps {
    [[Chartboost sharedChartboost] showMoreApps:CBLocationHomeScreen];
}

//Vungle
-(void)initialiseVungle: (NSString*)appID {
    
    VungleSDK* sdk = [VungleSDK sharedSDK];
    [sdk startWithAppId:appID];
    
    [[VungleSDK sharedSDK] setDelegate:self];
    
}
-(void)vunglePlayVideoAd: (UIViewController*)controller {
    NSLog(@"Video is loading");
    VungleSDK* sdk = [VungleSDK sharedSDK];
    [sdk setIncentivizedAlertText:@"Done"];

    NSDictionary* options = @{@"orientations": @(UIInterfaceOrientationMaskPortrait),
                              @"incentivized": @(YES),
                              @"userInfo": @{@"user": @""},
                              @"showClose": @(YES)};
    
    [sdk playAd:controller withOptions:options];

}
- (void)vungleSDKwillShowAd {
    
}

/**
 * If implemented, this will get called when the SDK closes the ad view, but that doesn't always mean
 * the ad experience is complete. There might be a product sheet that will be presented.
 * This point might be a good place to resume your game if there's no product sheet being presented.
 * If the product sheet will be shown, we recommend waiting for it to close before you resume,
 * show a reward confirmation to the user, etc. The viewInfo dictionary will contain the following keys:
 * - "completedView": NSNumber representing a BOOL whether or not the video can be considered a
 *                full view.
 * - "playTime": NSNumber representing the time in seconds that the user watched the video.
 * - "didDownlaod": NSNumber representing a BOOL whether or not the user clicked the download
 *                  button.
 */
- (void)vungleSDKwillCloseAdWithViewInfo:(NSDictionary*)viewInfo willPresentProductSheet:(BOOL)willPresentProductSheet {
    
}

/**
 * If implemented, this will get called when the product sheet is about to be closed.
 * It will only be called if the product sheet was shown.
 */
- (void)vungleSDKwillCloseProductSheet:(id)productSheet {
    
}
-(void)initialiseRevMob: (NSString*)appID testMode:(BOOL)testModeEnable {
    
    if(testModeEnable == YES) {
        [RevMobAds startSessionWithAppID:appID];
        [RevMobAds session].testingMode = RevMobAdsTestingModeWithAds;
    }
    else {
        [RevMobAds startSessionWithAppID:appID];
    }
}
-(void)revmobShowBanner {
    [[RevMobAds session] showBanner];
}
-(void)revmobShowAd {
    [[RevMobAds session] showFullscreen];
}
-(void)revmobShowPopUp {
    [[RevMobAds session] showPopup];
}
-(void)revmobAdDidFailWithError:(NSError *)error {
    if(error) {
        NSLog(@"%@",error);
    }
}
-(void)playSound :(NSString*)soundName type:(NSString*)soundType{
    NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:soundName
                                               ofType:soundType]];
    NSError *error;
    self.soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:&error];
    self.soundPlayer.numberOfLoops = 0;
    self.soundPlayer.delegate = self;
    [self.soundPlayer prepareToPlay];
    [self.soundPlayer play];
}
-(void)iAdStart: (UIViewController*)controller {
    self.bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [self.bannerView setDelegate:self];
    [controller.view addSubview:self.bannerView];
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
    // 1
    [self.bannerView removeFromSuperview];
    
    // 2
    _admobBannerView = [[GADBannerView alloc]
                        initWithFrame:CGRectMake(0.0,0.0,
                                                 GAD_SIZE_320x50.width,
                                                 GAD_SIZE_320x50.height)];
    
    // 3
    self.admobBannerView.adUnitID = admobID;
    self.admobBannerView.delegate = self;
    
    // 4
    [temporaryController.view addSubview:self.admobBannerView];
    [self.admobBannerView loadRequest:[GADRequest request]];
}
-(void)loadAdMobIfiADFAILS:(NSString*)appID controller:(UIViewController*)controller {
    temporaryController = controller;
    admobID = appID;
}
-(void)admobStart:(NSString*)appID controller:(UIViewController*)controller {
    [self.bannerView removeFromSuperview];
    
    // 2
    _admobBannerView = [[GADBannerView alloc]
                        initWithFrame:CGRectMake(0.0,0.0,
                                                 GAD_SIZE_320x50.width,
                                                 GAD_SIZE_320x50.height)];
    
    // 3
    [self.admobBannerView loadRequest:[GADRequest request]];
    self.admobBannerView.adUnitID = appID;
    self.admobBannerView.delegate = self;
    
    // 4
    [controller.view addSubview:self.admobBannerView];
   

}
#pragma mark GRAPHICAL ANIMATIONS
#pragma mark -
- (void)move:(UIView *)image duration:(NSTimeInterval)duration curve:(int)curve x:(CGFloat)x y:(CGFloat)y
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
    
}
-(void)fadeIn: (UIView*)theView duration:(float)duration delay:(float)delay {
    theView.alpha = 0;
    
    [UIView animateWithDuration:duration
                          delay:delay
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         theView.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"[Mobile Builder]---> Fade In Finished");
                     }];
}
-(void)fadeOut: (UIView*)theView duration:(float)duration delay:(float)delay {
    
    [UIView animateWithDuration:duration
                          delay:delay
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         theView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"[Mobile Builder]---> Fade Out Finished");
                     }];
    
    
}
-(void)fadeOutIn: (UIView*)theView duration:(float)duration delay:(float)delay {
    
    [UIView animateWithDuration:duration
                          delay:delay
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         theView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"[Mobile Builder]---> Fade Out Finished");
                         [UIView animateWithDuration:duration
                                               delay:delay
                                             options: UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              theView.alpha = 1;
                                          }
                                          completion:^(BOOL finished){
                                              NSLog(@"[Mobile Builder]---> Fade In Finished");
                                          }];

                     }];
    
    
}

-(void)bounce: (UIView*)theView repeat:(int)repeats duration:(int)duration distance:(int)distance horizontal:(BOOL)horizontal vertical:(BOOL)vertical {
    if(horizontal == YES) {
        CGPoint origin = theView.center;
        CGPoint target = CGPointMake(theView.center.x- distance, theView.center.y);
        CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"]; //Animations for y axis
        bounce.duration = duration;
        bounce.fromValue = [NSNumber numberWithInt:origin.x];
        bounce.toValue = [NSNumber numberWithInt:target.x];
        bounce.repeatCount = repeats;
        bounce.autoreverses = YES; // undo changes after Animations.
        [theView.layer addAnimation: bounce forKey:@"position"];
    }
    if(vertical == YES) {
        CGPoint origin = theView.center;
        CGPoint target = CGPointMake(theView.center.x, theView.center.y-distance);
        CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.y"]; //Animations for y axis
        bounce.duration = duration;
        bounce.fromValue = [NSNumber numberWithInt:origin.y];
        bounce.toValue = [NSNumber numberWithInt:target.y];
        bounce.repeatCount = repeats;
        bounce.autoreverses = YES; // undo changes after Animations.
        [theView.layer addAnimation: bounce forKey:@"position"];
    }
}
- (void)moveAndShake:(UIView *)image duration:(NSTimeInterval)duration curve:(int)curve x:(CGFloat)x y:(CGFloat)y
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.1];
    [shake setRepeatCount:4];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:
                         CGPointMake(image.center.x - 5,image.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:
                       CGPointMake(image.center.x + 5, image.center.y)]];
    [image.layer addAnimation:shake forKey:@"position"];
}
-(void)fadeInAndBounce: (UIView*)theView duration:(float)duration delay:(float)delay numberOfBounces:(int)bounces {
    theView.alpha = 0;
    
    [UIView animateWithDuration:duration
                          delay:delay
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         theView.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         CGPoint origin = theView.center;
                         CGPoint target = CGPointMake(theView.center.x- 5, theView.center.y);
                         CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"]; //Animations for y axis
                         bounce.duration = 0.1;
                         bounce.fromValue = [NSNumber numberWithInt:origin.x];
                         bounce.toValue = [NSNumber numberWithInt:target.x];
                         bounce.repeatCount = bounces;
                         bounce.autoreverses = YES; // undo changes after Animations.
                         [theView.layer addAnimation: bounce forKey:@"position"];

                     }];
}
-(void)shake: (UIView*)theView {
    CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 2.0f ;
    anim.duration = 0.07f ;
    
    [ theView.layer addAnimation:anim forKey:nil ] ;
}
- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
-(void)jump: (UIView*)view_ duration:(float)duration distance:(int)distance {
    NSTimeInterval durationUp = duration;
    
    [UIView animateWithDuration:durationUp delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect f = view_.frame;
                         f.origin.y -= distance;
                         view_.frame = f;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:durationUp delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              CGRect f = view_.frame;
                                              f.origin.y += distance;
                                              view_.frame = f;
                                          }
                                          completion:nil];
  
                     
     }];
    
}

#pragma mark UTILITIES
#pragma mark -

-(NSMutableDictionary*)readFromPlist: (NSString*)plistFile {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",plistFile]]; //3
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:plistFile ofType:@"plist"]; //5
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    NSMutableDictionary* dic = [NSMutableDictionary new];
    dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    return dic;
}
-(void)playRadioStream: (NSString*)url {
    _player = [[MPMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:url]];
    _player.movieSourceType = MPMovieSourceTypeStreaming;
    _player.view.hidden = YES;
    [_player prepareToPlay];
    [_player play];
}
-(void)stopRadioStream {
    [_player stop];
}
-(void)continueRadioStream {
    [_player play];
}
-(void)playYouTubeVideo: (NSString*)link webView:(UIWebView*)webView{
    NSURL *url = [NSURL URLWithString:link];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}
-(void)rateTheApp: (NSString*)appID_ {
    
    NSString* iTunesLink = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appID_];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    
}
-(void)rateTheAppMessage: (NSString*)appID gameName:(NSString*)gameName {
    
    appid = appID;
    NSString* game = [NSString stringWithFormat:@"Do you like %@ ?",gameName];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:game message:@"Please take a moment and rate us." delegate:self cancelButtonTitle:@"No, Thanks" otherButtonTitles:@"RATE", nil];
    [alert show];
    alert.tag = 1;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag == 1) {
        if(buttonIndex == 0) {
            NSLog(@"Closing Rate Option.. Done");
        }
        else {
            NSString* iTunesLink = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appid];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        }
    }
}
-(void)createCustomPopUpInterstitial: (NSString*)imageName viewController:(UIViewController*)controller appID:(NSString*)appID_ {
        
        appid = appID_;
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(0, 0, 300, 470);
        imageView.center = controller.view.center;
        [controller.view addSubview:imageView];
        
        UIImageView* xButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xButton.png"]];
        xButton.frame = CGRectMake(imageView.frame.size.width - 30, -20, 40, 40);
        [imageView addSubview: xButton];
        
        UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCustomInterstitials:)];
        gestureRecognizer.numberOfTapsRequired = 1;
        [xButton addGestureRecognizer:gestureRecognizer];
        
        UITapGestureRecognizer* openURLGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openURL:)];
        openURLGesture.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:openURLGesture];
        
        xButton.userInteractionEnabled = YES;
        imageView.userInteractionEnabled = YES;
        NSLog(@"%f %f",imageView.frame.origin.x, imageView.frame.origin.y);
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options: UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                              imageView.transform=CGAffineTransformMakeScale(1.2, 1.2);
                         }
                         completion:^(BOOL finished){
                             imageView.transform=CGAffineTransformMakeScale(1.0, 1.0);
                         }];
}
-(void)openURL: (UITapGestureRecognizer*)recognizer {
    imageView.userInteractionEnabled = NO;
    NSString* iTunesLink = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appid];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    

    
    [UIView animateWithDuration:0.1
                          delay:0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         imageView.transform=CGAffineTransformMakeScale(1.2, 1.2);
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.2
                                               delay:0
                                             options: UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              imageView.transform=CGAffineTransformMakeScale(0, 0);
                                          }
                                          completion:^(BOOL finished){
                                          }];
                     }];

}
-(void)hideCustomInterstitials: (UITapGestureRecognizer*)recognizer {
    imageView.userInteractionEnabled = NO;
    NSLog(@"Custom Interstitials Closed");
    [UIView animateWithDuration:0.1
                          delay:0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         imageView.transform=CGAffineTransformMakeScale(1.2, 1.2);
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.2
                                               delay:0
                                             options: UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              imageView.transform=CGAffineTransformMakeScale(0, 0);
                                          }
                                          completion:^(BOOL finished){
                                          }];
                     }];

}
-(void)createCustomPopUpInterstitialWithURL: (NSString*)imageName viewController:(UIViewController*)controller url:(NSString*)url_ {
    
    customPopUpURL = url_;
    
    imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = CGRectMake(0, 0, 300, 470);
    imageView.center = controller.view.center;
    [controller.view addSubview:imageView];
    
    UIImageView* xButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xButton.png"]];
    xButton.frame = CGRectMake(imageView.frame.size.width - 30, -20, 40, 40);
    [imageView addSubview: xButton];
    
    UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCustomInterstitials2:)];
    gestureRecognizer.numberOfTapsRequired = 1;
    [xButton addGestureRecognizer:gestureRecognizer];
    
    UITapGestureRecognizer* openURLGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openURL2:)];
    openURLGesture.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:openURLGesture];
    
    xButton.userInteractionEnabled = YES;
    imageView.userInteractionEnabled = YES;
    NSLog(@"%f %f",imageView.frame.origin.x, imageView.frame.origin.y);
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         imageView.transform=CGAffineTransformMakeScale(1.2, 1.2);
                     }
                     completion:^(BOOL finished){
                         imageView.transform=CGAffineTransformMakeScale(1.0, 1.0);
                     }];

}
-(void)openURL2: (UITapGestureRecognizer*)recognizer {
    
    imageView.userInteractionEnabled = NO;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customPopUpURL]];
    
    [UIView animateWithDuration:0.1
                          delay:0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         imageView.transform=CGAffineTransformMakeScale(1.2, 1.2);
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.2
                                               delay:0
                                             options: UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              imageView.transform=CGAffineTransformMakeScale(0, 0);
                                          }
                                          completion:^(BOOL finished){
                                          }];
                     }];
    
}
-(void)hideCustomInterstitials2: (UITapGestureRecognizer*)recognizer {
    imageView.userInteractionEnabled = NO;
    NSLog(@"Custom Interstitials Closed");
    [UIView animateWithDuration:0.1
                          delay:0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         imageView.transform=CGAffineTransformMakeScale(1.2, 1.2);
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.2
                                               delay:0
                                             options: UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              imageView.transform=CGAffineTransformMakeScale(0, 0);
                                          }
                                          completion:^(BOOL finished){
                                          }];
                     }];
    
}

-(void)createLocalNotification: (NSString*)message minutes:(float)minutes {
    
    int time = minutes * 60;
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:time];
    localNotification.alertBody = message;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}
-(void)switchFromToViewController:(UIViewController*)controller toViewConttroller:(UIViewController*)toController id:(NSString*)controllerID {
    
    UIStoryboard *storyboard = controller.storyboard;
    toController = [storyboard instantiateViewControllerWithIdentifier:controllerID];
    [controller presentViewController:toController animated:NO completion:nil];

}
-(void)startTheLoadingActivityView: (UIViewController*)controller {
   
    int x = 0;
    int y = 0;
    int height = 0;
    int width = 0;
    if(IS_IPAD) {
        x = 215; y = 330; width = 340; height = 340;
        hLoadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 230, 260, 45)];
    }
    else {
        x = 75; y = 155; width = 170; height = 170;
        hLoadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    }
    
    hLoadingView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    hLoadingActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    hLoadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    hLoadingView.clipsToBounds = YES;
    hLoadingView.layer.cornerRadius = 10.0;
    hLoadingActivityView.frame = CGRectMake((IS_IPAD)?150 : 65,(IS_IPAD)?150:40, (IS_IPAD)?hLoadingActivityView.bounds.size.width+15:hLoadingActivityView.bounds.size.width,(IS_IPAD)?hLoadingActivityView.bounds.size.height+15:hLoadingActivityView.bounds.size.height);
    [hLoadingView addSubview:hLoadingActivityView];
    hLoadingLabel.backgroundColor = [UIColor clearColor];
    hLoadingLabel.textColor = [UIColor whiteColor];
    hLoadingLabel.adjustsFontSizeToFitWidth = YES;
    hLoadingLabel.textAlignment = NSTextAlignmentCenter;
    if(IS_IPAD)
        [hLoadingLabel setFont:[UIFont systemFontOfSize:30]];
    
    hLoadingLabel.text = @"Loading";
    
    [hLoadingView addSubview:hLoadingLabel];
    [controller.view addSubview:hLoadingView];
    [hLoadingActivityView startAnimating];
    
}
-(void)removeTheLoadingView {
    [hLoadingActivityView stopAnimating];
    [hLoadingView removeFromSuperview];
}
@end
