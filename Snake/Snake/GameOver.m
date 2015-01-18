//
//  GameOver.m
//  Snake
//
//  Created by Viktor Todorov on 8/13/14.
//  Copyright (c) 2014 Viktor Todorov. All rights reserved.
//

#import "GameOver.h"
#import "ViewController.h"
#import "MainMenu.h"
#import "MobileBuilder.h"
#import <RevMobAds/RevMobAds.h>

@interface GameOver ()

@end

static int DistanceBetweenSquares = 20;

@implementation GameOver

@synthesize _scoreNumber;

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
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isPurchase"] == NO) {
        [[MobileBuilder startBuilding]initialiseRevMob:@"5490b1ee952976f713ec8099" testMode:NO];
        [[MobileBuilder startBuilding]revmobShowAd];
    }
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isPurchase"] == NO) {
        [[MobileBuilder startBuilding]iAdStart:self];
        [[MobileBuilder startBuilding]revmobShowBanner];
        //[[MobileBuilder startBuilding]loadAdMobIfiADFAILS:@"ca-app-pub-8136035264927639/8871461901" controller:self];
    }
    
    _isClassic = [[NSUserDefaults standardUserDefaults]boolForKey:@"isClassic"];
    // Do any additional setup after loading the view.
    _titleLabel.center = CGPointMake(_titleLabel.center.x, _titleLabel.center.y - 500);
    _titleLeftLine.center = CGPointMake(_titleLeftLine.center.x - 300, _titleLeftLine.center.y);
    _titleRightLine.center = CGPointMake(_titleRightLine.center.x + 300, _titleRightLine.center.y);
    _scoreLabel.hidden = YES;
    _bestScoreLabel.hidden = YES;
    _againLabel.hidden = YES;
    _menuLabel.hidden = YES;
    
    if(_isClassic == NO) {
        [[MobileBuilder startBuilding]reportScore:_scoreNumber forLeaderboardID:@"55077024"];
        
        if(_scoreNumber >= [[NSUserDefaults standardUserDefaults]integerForKey:@"bestScore"]) {
            [[NSUserDefaults standardUserDefaults]setInteger:_scoreNumber forKey:@"bestScore"];
        }
    }
    else {
        [[MobileBuilder startBuilding]reportScore:_scoreNumber forLeaderboardID:@"55077025"];
        
        if(_scoreNumber >= [[NSUserDefaults standardUserDefaults]integerForKey:@"bestScoreClassic"]) {
            [[NSUserDefaults standardUserDefaults]setInteger:_scoreNumber forKey:@"bestScoreClassic"];
        }
    }
    if([[NSUserDefaults standardUserDefaults]integerForKey:@"isButtons"] == 1) {
        [[MobileBuilder startBuilding]reportScore:_scoreNumber forLeaderboardID:@"55077027"];
        
        if(_scoreNumber >= [[NSUserDefaults standardUserDefaults]integerForKey:@"bestRotateScore"]) {
            [[NSUserDefaults standardUserDefaults]setInteger:_scoreNumber forKey:@"bestRotateScore"];
        }
    }
    [self loadTheComponents];
    
    //[[MobileBuilder startBuilding]authenticateLocalUserOnViewController:self setCallbackObject:nil withPauseSelector:nil];
    //[[MobileBuilder startBuilding]showLeaderboardOnViewController:self];
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
                         _titleLeftLine.center = CGPointMake(_titleLeftLine.center.x + 300, _titleLeftLine.center.y);
                         _titleRightLine.center = CGPointMake(_titleRightLine.center.x - 300, _titleRightLine.center.y);
                     }
                     completion:^(BOOL finished){
                         _scoreLabel.hidden = NO;
                         _bestScoreLabel.hidden = NO;
                         _scoreLabel.center = CGPointMake(_square1.center.x, _square1.center.y);
                         _bestScoreLabel.center = CGPointMake(_square2.center.x, _square2.center.y);
                         _scoreLabel.text = [NSString stringWithFormat:@"Score %i",_scoreNumber];
                         
                         if(_isClassic == NO) {
                             _bestScoreLabel.text = [NSString stringWithFormat:@"High Score %li", (long)[[NSUserDefaults standardUserDefaults]integerForKey:@"bestScore"]];
                         }
                         else {
                             _bestScoreLabel.text = [NSString stringWithFormat:@"High Score %li", (long)[[NSUserDefaults standardUserDefaults]integerForKey:@"bestScoreClassic"]];
                         }
                         //_square4.image = [UIImage imageNamed:@"menu.png"];
                         //_square3.image = [UIImage imageNamed:@"again.png"];
                         _againLabel.hidden = NO;
                         _menuLabel.hidden = NO;
                         _againLabel.center = CGPointMake(_square3.center.x, _square3.center.y);
                         _menuLabel.center = CGPointMake(_square4.center.x, _square4.center.y);
                         _square3.userInteractionEnabled = YES;
                         _square4.userInteractionEnabled = YES;
                         
                         UITapGestureRecognizer* playAgain = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(playAgain:)];
                         [playAgain setNumberOfTapsRequired:1];
                         [_square3 addGestureRecognizer:playAgain];
                         
                         UITapGestureRecognizer* backHome = [[UITapGestureRecognizer alloc]
                                     initWithTarget:self
                                     action:@selector(backHome:)];
                         [backHome setNumberOfTapsRequired:1];
                         [_square4 addGestureRecognizer:backHome];
                         
                     }];
}

-(void)playAgain: (UIGestureRecognizer*)recognizer {
    _scoreLabel.hidden = YES;
    _bestScoreLabel.hidden = YES;
    _againLabel.hidden = YES;
    _menuLabel.hidden = YES;
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
                         _titleLeftLine.center = CGPointMake(_titleLeftLine.center.x - 300, _titleLeftLine.center.y);
                         _titleRightLine.center = CGPointMake(_titleRightLine.center.x + 300, _titleRightLine.center.y);
                         
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
                                          completion:^(BOOL finished) {
                                              UIStoryboard *storyboard = self.storyboard;
                                              ViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"play"];
                                              [self presentViewController:svc animated:NO completion:nil];
                                          }];
                     }];

  }

-(void)backHome: (UIGestureRecognizer*)recognizer {
    
    _scoreLabel.hidden = YES;
    _bestScoreLabel.hidden = YES;
    _againLabel.hidden = YES;
    _menuLabel.hidden = YES;
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
                         _titleLeftLine.center = CGPointMake(_titleLeftLine.center.x - 300, _titleLeftLine.center.y);
                         _titleRightLine.center = CGPointMake(_titleRightLine.center.x + 300, _titleRightLine.center.y);
                         
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
                                          completion:^(BOOL finished) {
                                              UIStoryboard *storyboard = self.storyboard;
                                              MainMenu *svc = [storyboard instantiateViewControllerWithIdentifier:@"menu"];
                                              [self presentViewController:svc animated:NO completion:nil];
                                              
                                              if([[NSUserDefaults standardUserDefaults]boolForKey:@"isPurchase"] == NO) {
                                                  [[MobileBuilder startBuilding]initialiseRevMob:@"5490b1ee952976f713ec8099" testMode:NO];
                                                  [[MobileBuilder startBuilding]revmobShowAd];
                                              }
                                          }];
                     }];
}

@end
