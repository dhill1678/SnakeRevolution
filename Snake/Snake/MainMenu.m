//
//  MainMenu.m
//  Snake
//
//  Created by Viktor Todorov on 8/13/14.
//  Copyright (c) 2014 Viktor Todorov. All rights reserved.
//

#import "MainMenu.h"
#import "MobileBuilder.h"
#import "ViewController.h"
#import <RevMobAds/RevMobAds.h>

@interface MainMenu ()

@end

static int DistanceBetweenSquares = 20;

@implementation MainMenu

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _playGame.hidden = YES;
    _gameSettings.hidden = YES;
    _gameCenter.hidden = YES;
    
    //Chartboost ads
    //if([[NSUserDefaults standardUserDefaults]boolForKey:@"isPurchase"] == NO) {
        //[[MobileBuilder startBuilding]initialiseChartboost:@"213123" appSignute:@"s123c123c12"];
        //[[MobileBuilder startBuilding]chartboostShowAd];
    //}
     
    // Do any additional setup after loading the view.
    
    [[MobileBuilder startBuilding]authenticateLocalUserOnViewController:self setCallbackObject:nil withPauseSelector:nil];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isPurchase"] == NO) {
        [[MobileBuilder startBuilding]iAdStart:self];
        [[MobileBuilder startBuilding]revmobShowBanner];
        //[[MobileBuilder startBuilding]loadAdMobIfiADFAILS:@"ca-app-pub-8136035264927639/8871461901" controller:self];
    }
    
    _homeButton.hidden = YES;
    _homeButton.center = CGPointMake(_homeButton.center.x, _homeButton.center.y + 200);
    
    _titleLabel.center = CGPointMake(_titleLabel.center.x, _titleLabel.center.y - 500);
    //_titleLeftLine.center = CGPointMake(_titleLeftLine.center.x - 300, _titleLeftLine.center.y);
    //_titleRightLine.center = CGPointMake(_titleRightLine.center.x + 300, _titleRightLine.center.y);
    
    _square1.userInteractionEnabled = YES;
    _square2.userInteractionEnabled = YES;
    _square3.userInteractionEnabled = YES;
    _square4.userInteractionEnabled = YES;
    _homeButton.userInteractionEnabled = YES;
    self.view.userInteractionEnabled = YES;
    
    openSettings = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(switchToSettings:)];
    [openSettings setNumberOfTapsRequired:1];
    [_gameSettings addGestureRecognizer:openSettings];
    
    backHome = [[UITapGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(backHome:)];
    [backHome setNumberOfTapsRequired:1];
    [_homeButton addGestureRecognizer:backHome];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isClassic"] == YES) {
        classic = [[UITapGestureRecognizer alloc]
                   initWithTarget:self
                   action:@selector(launchClassic:)];
        [classic setNumberOfTapsRequired:1];
        [_playGame addGestureRecognizer:classic];
    }
    else {
        nowalls = [[UITapGestureRecognizer alloc]
                   initWithTarget:self
                   action:@selector(launchNoWalls:)];
        [nowalls setNumberOfTapsRequired:1];
        [_playGame addGestureRecognizer:nowalls];
    }
    
    gameCenter = [[UITapGestureRecognizer alloc]
               initWithTarget:self
               action:@selector(openGameCenter:)];
    [gameCenter setNumberOfTapsRequired:1];
    [_gameCenter addGestureRecognizer:gameCenter];

    
    [self loadTheComponents];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadTheComponents {
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _square1.center = CGPointMake(_square1.center.x - DistanceBetweenSquares, _square1.center.y - DistanceBetweenSquares);
                         _square2.center = CGPointMake(_square2.center.x + DistanceBetweenSquares, _square2.center.y - DistanceBetweenSquares);
                         _square3.center = CGPointMake(_square3.center.x - DistanceBetweenSquares, _square3.center.y + DistanceBetweenSquares);
                         _square4.center = CGPointMake(_square4.center.x + DistanceBetweenSquares, _square4.center.y + DistanceBetweenSquares);
                         
                     }
                     completion:^(BOOL finished){
                     }];
    
    [UIView animateWithDuration:0.8
                          delay:0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _titleLabel.center = CGPointMake(_titleLabel.center.x, _titleLabel.center.y + 500);
                         //_titleLeftLine.center = CGPointMake(_titleLeftLine.center.x + 300, _titleLeftLine.center.y);
                         //_titleRightLine.center = CGPointMake(_titleRightLine.center.x - 300, _titleRightLine.center.y);
                     }
                     completion:^(BOOL finished){
                         //_square1.image = [UIImage imageNamed:@"classic.png"];
                         //_square2.image = [UIImage imageNamed:@"nowalls.png"];
                         //_square3.image = [UIImage imageNamed:@"settings.png"];
                         //_square4.image = [UIImage imageNamed:@"gamecenter.png"];
                         
                         // ADDED FOR NEW HOME SCREEN
                         _square1.image = nil;
                         _square2.image = nil;
                         _square3.image = nil;
                         _square4.image = nil;
                         
                         _square1.backgroundColor = [UIColor blackColor];
                         _square2.backgroundColor = [UIColor blackColor];
                         _square3.backgroundColor = [UIColor blackColor];
                         _square4.backgroundColor = [UIColor blackColor];
                         
                         _playGame.hidden = NO;
                         _gameSettings.hidden = NO;
                         _gameCenter.hidden = NO;
                     }
     ];

}

-(void)switchToSettings: (UIGestureRecognizer*)recognizer {
    _playGame.hidden = YES;
    _gameSettings.hidden = YES;
    _gameCenter.hidden = YES;
    
    [self switchGestureRecognizers:NO];
    _homeButton.hidden = NO;
    _square1.image = nil;
    _square2.image = nil;
    _square3.image = nil;
    _square4.image = nil;
    
    _square1.backgroundColor = [UIColor blackColor];
    _square2.backgroundColor = [UIColor blackColor];
    _square3.backgroundColor = [UIColor blackColor];
    _square4.backgroundColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _square1.center = CGPointMake(_square1.center.x + DistanceBetweenSquares, _square1.center.y + DistanceBetweenSquares);
                         _square2.center = CGPointMake(_square2.center.x - DistanceBetweenSquares, _square2.center.y + DistanceBetweenSquares);
                         _square3.center = CGPointMake(_square3.center.x + DistanceBetweenSquares, _square3.center.y - DistanceBetweenSquares);
                         _square4.center = CGPointMake(_square4.center.x - DistanceBetweenSquares, _square4.center.y - DistanceBetweenSquares);
                         
                         [[RevMobAds session] hideBanner];
                         
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.5
                                               delay:0
                                             options: UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              _square1.center = CGPointMake(_square1.center.x - DistanceBetweenSquares, _square1.center.y - DistanceBetweenSquares);
                                              _square2.center = CGPointMake(_square2.center.x + DistanceBetweenSquares, _square2.center.y - DistanceBetweenSquares);
                                              _square3.center = CGPointMake(_square3.center.x - DistanceBetweenSquares, _square3.center.y + DistanceBetweenSquares);
                                              _square4.center = CGPointMake(_square4.center.x + DistanceBetweenSquares, _square4.center.y + DistanceBetweenSquares);
                                              
                                          }
                                          completion:^(BOOL finished){
                                              if([[NSUserDefaults standardUserDefaults]integerForKey:@"isButtons"] == 2) {
                                                  _square1.image = [UIImage imageNamed:@"buttons.png"];
                                              } else if([[NSUserDefaults standardUserDefaults]integerForKey:@"isButtons"] == 3) {
                                                  _square1.image = [UIImage imageNamed:@"swipe.png"];
                                              } else {
                                                  _square1.image = [UIImage imageNamed:@"gyro.png"];
                                              }
                                              if([[NSUserDefaults standardUserDefaults]boolForKey:@"isMusicOn"] == YES) {
                                                  _square2.image = [UIImage imageNamed:@"musicOn.png"];
                                              }
                                              else {
                                                  _square2.image = [UIImage imageNamed:@"musicOff.png"];
                                              }
                                              if([[NSUserDefaults standardUserDefaults]boolForKey:@"isClassic"] == YES) {
                                                  _square3.image = [UIImage imageNamed:@"classic.png"];
                                              }
                                              else {
                                                  _square3.image = [UIImage imageNamed:@"nowalls.png"];
                                              }
                                              //_square3.image = [UIImage imageNamed:@"removeads.png"];
                                              //_square4.image = [UIImage imageNamed:@"restore.png"];
                                              if([[NSUserDefaults standardUserDefaults]integerForKey:@"DifficultyLevel"] == 2) {
                                                  _square4.image = [UIImage imageNamed:@"normal.png"];
                                              } else if([[NSUserDefaults standardUserDefaults]integerForKey:@"DifficultyLevel"] == 3) {
                                                  _square4.image = [UIImage imageNamed:@"hard.png"];
                                              } else if([[NSUserDefaults standardUserDefaults]integerForKey:@"DifficultyLevel"] == 4) {
                                                  _square4.image = [UIImage imageNamed:@"hardest.png"];
                                              } else {
                                                  _square4.image = [UIImage imageNamed:@"easy.png"];
                                              }
                                              
                                              [UIView animateWithDuration:0.5
                                                                    delay:0
                                                                  options: UIViewAnimationOptionBeginFromCurrentState
                                                               animations:^{
                                                                   _homeButton.center = CGPointMake(_homeButton.center.x, _homeButton.center.y - 200);
                                                                   
                                                                   if([[NSUserDefaults standardUserDefaults]boolForKey:@"isPurchase"] == NO) {
                                                                       [[MobileBuilder startBuilding]iAdStart:self];
                                                                       [[MobileBuilder startBuilding]revmobShowBanner];
                                                                       //[[MobileBuilder startBuilding]loadAdMobIfiADFAILS:@"ca-app-pub-8136035264927639/8871461901" controller:self];
                                                                   }
                                                               }
                                                               completion:^(BOOL finished){
                                                               }];
                                          }];

                     }];

}

-(void)backHome: (UIGestureRecognizer*)recognizer {
    [self switchGestureRecognizers:YES];
    _homeButton.hidden = NO;
    _square1.image = nil;
    _square2.image = nil;
    _square3.image = nil;
    _square4.image = nil;
    
    _square1.backgroundColor = [UIColor blackColor];
    _square2.backgroundColor = [UIColor blackColor];
    _square3.backgroundColor = [UIColor blackColor];
    _square4.backgroundColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _homeButton.center = CGPointMake(_homeButton.center.x, _homeButton.center.y + 200);
                         
                         [[RevMobAds session] hideBanner];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.5
                                               delay:0
                                             options: UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              _square1.center = CGPointMake(_square1.center.x + DistanceBetweenSquares, _square1.center.y + DistanceBetweenSquares);
                                              _square2.center = CGPointMake(_square2.center.x - DistanceBetweenSquares, _square2.center.y + DistanceBetweenSquares);
                                              _square3.center = CGPointMake(_square3.center.x + DistanceBetweenSquares, _square3.center.y - DistanceBetweenSquares);
                                              _square4.center = CGPointMake(_square4.center.x - DistanceBetweenSquares, _square4.center.y - DistanceBetweenSquares);
                                              
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.5
                                                                    delay:0
                                                                  options: UIViewAnimationOptionBeginFromCurrentState
                                                               animations:^{
                                                                   _square1.center = CGPointMake(_square1.center.x - DistanceBetweenSquares, _square1.center.y - DistanceBetweenSquares);
                                                                   _square2.center = CGPointMake(_square2.center.x + DistanceBetweenSquares, _square2.center.y - DistanceBetweenSquares);
                                                                   _square3.center = CGPointMake(_square3.center.x - DistanceBetweenSquares, _square3.center.y + DistanceBetweenSquares);
                                                                   _square4.center = CGPointMake(_square4.center.x + DistanceBetweenSquares, _square4.center.y + DistanceBetweenSquares);
                                                                   
                                                               }
                                                               completion:^(BOOL finished){
                                                                   //_square1.image = [UIImage imageNamed:@"classic.png"];
                                                                   //_square2.image = [UIImage imageNamed:@"nowalls.png"];
                                                                   //_square3.image = [UIImage imageNamed:@"settings.png"];
                                                                   //_square4.image = [UIImage imageNamed:@"gamecenter.png"];
                                                                   
                                                                   // ADDED FOR NEW HOME SCREEN
                                                                   _square1.image = nil;
                                                                   _square2.image = nil;
                                                                   _square3.image = nil;
                                                                   _square4.image = nil;
                                                                   
                                                                   _square1.backgroundColor = [UIColor blackColor];
                                                                   _square2.backgroundColor = [UIColor blackColor];
                                                                   _square3.backgroundColor = [UIColor blackColor];
                                                                   _square4.backgroundColor = [UIColor blackColor];
                                                                   
                                                                   _playGame.hidden = NO;
                                                                   _gameSettings.hidden = NO;
                                                                   _gameCenter.hidden = NO;
                                                                   
                                                                   if([[NSUserDefaults standardUserDefaults]boolForKey:@"isPurchase"] == NO) {
                                                                       [[MobileBuilder startBuilding]iAdStart:self];
                                                                       [[MobileBuilder startBuilding]revmobShowBanner];
                                                                       //[[MobileBuilder startBuilding]loadAdMobIfiADFAILS:@"ca-app-pub-8136035264927639/8871461901" controller:self];
                                                                   }
                                                               }];
                                              
                                          }];

                     }];
    
}

/*
-(void)removeAds: (UIGestureRecognizer*)recognizer {
    NSLog(@"Remove Ads");
    [[MobileBuilder startBuilding]removeAds:@"IN-APP ID"];
}

-(void)restore: (UIGestureRecognizer*)recognizer {
    NSLog(@"Restore");
    [[MobileBuilder startBuilding]restorePurchase];
}
 */

-(void)difficulty: (UIGestureRecognizer*)recognizer {
    NSLog(@"Difficulty");
    if([[NSUserDefaults standardUserDefaults]integerForKey:@"DifficultyLevel"] == 1) {
        _square4.image = [UIImage imageNamed:@"normal.png"];
        [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:@"DifficultyLevel"];
    } else if([[NSUserDefaults standardUserDefaults]integerForKey:@"DifficultyLevel"] == 2) {
        _square4.image = [UIImage imageNamed:@"hard.png"];
        [[NSUserDefaults standardUserDefaults]setInteger:3 forKey:@"DifficultyLevel"];
    } else if([[NSUserDefaults standardUserDefaults]integerForKey:@"DifficultyLevel"] == 3) {
        _square4.image = [UIImage imageNamed:@"hardest.png"];
        [[NSUserDefaults standardUserDefaults]setInteger:4 forKey:@"DifficultyLevel"];
    } else {
        _square4.image = [UIImage imageNamed:@"easy.png"];
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"DifficultyLevel"];
    }
}

-(void)changeControlls: (UIGestureRecognizer*)recognizer {
    NSLog(@"Controls");
    if([[NSUserDefaults standardUserDefaults]integerForKey:@"isButtons"] == 1) {
        _square1.image = [UIImage imageNamed:@"buttons.png"];
        [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:@"isButtons"];
    } else if([[NSUserDefaults standardUserDefaults]integerForKey:@"isButtons"] == 2) {
        _square1.image = [UIImage imageNamed:@"swipe.png"];
        [[NSUserDefaults standardUserDefaults]setInteger:3 forKey:@"isButtons"];
    } else {
        _square1.image = [UIImage imageNamed:@"gyro.png"];
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"isButtons"];
    }
}

-(void)changeMusic: (UIGestureRecognizer*)recognizer {
    NSLog(@"Music");
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isMusicOn"] == YES) {
        _square2.image = [UIImage imageNamed:@"musicOff.png"];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isMusicOn"];
        //[self.audioPlayer stop];
    }
    else {
        _square2.image = [UIImage imageNamed:@"musicOn.png"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isMusicOn"];
        //[self.audioPlayer play];
    }
    
}

-(void)changeClassic: (UIGestureRecognizer*)recognizer {
    NSLog(@"Classic");
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isClassic"] == YES) {
        _square3.image = [UIImage imageNamed:@"nowalls.png"];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isClassic"];
    }
    else {
        _square3.image = [UIImage imageNamed:@"classic.png"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isClassic"];
    }
    
}

-(void)openGameCenter: (UIGestureRecognizer*)recognizer {
    NSLog(@"Open Game Center");
    [[RevMobAds session] hideBanner];
    [[MobileBuilder startBuilding]showLeaderboardOnViewController:self];
}

-(void)launchClassic: (UIGestureRecognizer*)recognizer {
    NSLog(@"Classic");
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isClassic"];
    [self startTheGame];
}

-(void)launchNoWalls: (UIGestureRecognizer*)recognizer {
    NSLog(@"No Walls");
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isClassic"];
    [self startTheGame];
}

-(void)switchGestureRecognizers: (BOOL)isHome {
    
    if(isHome == YES) {
        [_square1 removeGestureRecognizer:controlls];
        [_square2 removeGestureRecognizer:music];
        //[_square3 removeGestureRecognizer:removeads];
        [_square3 removeGestureRecognizer:classChange];
        //[_square4 removeGestureRecognizer:restore];
        [_square4 removeGestureRecognizer:difficulty];
        
        openSettings = [[UITapGestureRecognizer alloc]
                        initWithTarget:self
                        action:@selector(switchToSettings:)];
        [openSettings setNumberOfTapsRequired:1];
        [_gameSettings addGestureRecognizer:openSettings];
        
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"isClassic"] == YES) {
            classic = [[UITapGestureRecognizer alloc]
                       initWithTarget:self
                       action:@selector(launchClassic:)];
            [classic setNumberOfTapsRequired:1];
            [_playGame addGestureRecognizer:classic];
        } else {
            nowalls = [[UITapGestureRecognizer alloc]
                       initWithTarget:self
                       action:@selector(launchNoWalls:)];
            [nowalls setNumberOfTapsRequired:1];
            [_playGame addGestureRecognizer:nowalls];
        }
        
        gameCenter = [[UITapGestureRecognizer alloc]
                      initWithTarget:self
                      action:@selector(openGameCenter:)];
        [gameCenter setNumberOfTapsRequired:1];
        [_gameCenter addGestureRecognizer:gameCenter];

        
    }
    else {
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"isClassic"] == YES) {
            [_playGame removeGestureRecognizer:classic];
        } else {
            [_playGame removeGestureRecognizer:nowalls];
        }
        [_gameSettings removeGestureRecognizer:openSettings];
        [_gameCenter removeGestureRecognizer:gameCenter];
        
        /*
        removeads = [[UITapGestureRecognizer alloc]
                        initWithTarget:self
                        action:@selector(removeAds:)];
        [removeads setNumberOfTapsRequired:1];
        [_square3 addGestureRecognizer:removeads];
         */
        
        controlls = [[UITapGestureRecognizer alloc]
                   initWithTarget:self
                   action:@selector(changeControlls:)];
        [controlls setNumberOfTapsRequired:1];
        [_square1 addGestureRecognizer:controlls];
        
        music = [[UITapGestureRecognizer alloc]
                   initWithTarget:self
                   action:@selector(changeMusic:)];
        [music setNumberOfTapsRequired:1];
        [_square2 addGestureRecognizer:music];
        
        classChange = [[UITapGestureRecognizer alloc]
                     initWithTarget:self
                     action:@selector(changeClassic:)];
        [classChange setNumberOfTapsRequired:1];
        [_square3 addGestureRecognizer:classChange];
        
        /*
        restore = [[UITapGestureRecognizer alloc]
                      initWithTarget:self
                      action:@selector(restore:)];
        [restore setNumberOfTapsRequired:1];
        [_square4 addGestureRecognizer:restore];
         */
        
        difficulty = [[UITapGestureRecognizer alloc]
                   initWithTarget:self
                   action:@selector(difficulty:)];
        [difficulty setNumberOfTapsRequired:1];
        [_square4 addGestureRecognizer:difficulty];

    }
    
}

-(void)startTheGame {
    
    _playGame.hidden = YES;
    _gameSettings.hidden = YES;
    _gameCenter.hidden = YES;
    
    _square1.image = nil;
    _square2.image = nil;
    _square3.image = nil;
    _square4.image = nil;
    
    _square1.backgroundColor = [UIColor blackColor];
    _square2.backgroundColor = [UIColor blackColor];
    _square3.backgroundColor = [UIColor blackColor];
    _square4.backgroundColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _titleLabel.center = CGPointMake(_titleLabel.center.x, _titleLabel.center.y - 500);
                         //_titleLeftLine.center = CGPointMake(_titleLeftLine.center.x - 300, _titleLeftLine.center.y);
                         //_titleRightLine.center = CGPointMake(_titleRightLine.center.x + 300, _titleRightLine.center.y);
                         
                         [[RevMobAds session] hideBanner];
                     }
                     completion:^(BOOL finished){
                     }];
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _homeButton.center = CGPointMake(_homeButton.center.x, _homeButton.center.y + 200);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.5
                                               delay:0
                                             options: UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              _square1.center = CGPointMake(_square1.center.x + DistanceBetweenSquares, _square1.center.y + DistanceBetweenSquares);
                                              _square2.center = CGPointMake(_square2.center.x - DistanceBetweenSquares, _square2.center.y + DistanceBetweenSquares);
                                              _square3.center = CGPointMake(_square3.center.x + DistanceBetweenSquares, _square3.center.y - DistanceBetweenSquares);
                                              _square4.center = CGPointMake(_square4.center.x - DistanceBetweenSquares, _square4.center.y - DistanceBetweenSquares);
                                              
                                          }
                                          completion:^(BOOL finished) {
                                              UIStoryboard *storyboard = self.storyboard;
                                              ViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"play"];
                                              [self presentViewController:svc animated:NO completion:nil];
                                          }];
                     }];
}

@end
