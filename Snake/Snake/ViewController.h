//
//  ViewController.h
//  Snake
//
//  Created by Viktor Todorov on 8/12/14.
//  Copyright (c) 2014 Viktor Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import <MediaPlayer/MediaPlayer.h>
#import <CoreMotion/CoreMotion.h>

int SnakeX;
int SnakeY;
int FoodX;
int FoodY;
int snakeSize;
int diffFactor;
float baseSpeed;

@interface ViewController : UIViewController {
    
    IBOutlet UIImageView* _mainSquare;
    
    IBOutlet UIImageView *_snakeBlock1;
    IBOutlet UIImageView *_snakeBlock2;
    IBOutlet UIImageView *_snakeBlock3;
    IBOutlet UIImageView *_snakeBlock4;
    IBOutlet UIImageView *_snakeBlock5;
    
    IBOutlet UIImageView* _food;
    IBOutlet UIImageView* _food2;
    IBOutlet UIImageView* _food3;
    IBOutlet UIImageView* _food4;
    IBOutlet UIImageView* _food5;
    IBOutlet UIImageView* _food6;
    
    IBOutlet UIButton *_startGame;
    IBOutlet UIButton *_pauseGame;
    //IBOutlet UIButton *playButton;
    IBOutlet UIButton *quitButton;
    
    IBOutlet UILabel *gyroModeLabel;
    
    NSTimer* _snakeMovement;
    NSMutableArray* _snakeArray;
    
    BOOL _snakeSideMovement;
    BOOL _snakeUpDownMovement;
    BOOL _isGrowing;
    BOOL _isPaused;
    
    IBOutlet UIButton* _up;
    IBOutlet UIButton* _down;
    IBOutlet UIButton* _left;
    IBOutlet UIButton* _right;
    
    IBOutlet UILabel* _scoreLabel;
    int _scoreNumber;
    BOOL _isClassic;
    BOOL _isFlashActive;
    
    BOOL _isEaten;
    
    IBOutlet UIImageView* flashScreen;
    
    // for music library
    //MPMusicPlayerController *musicPlayer;
    
    // for core motion
    CMMotionManager *motionManager;
    NSOperationQueue *queue;
    
}

// for music library
//@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;
//-(void)registerMediaPlayerNotifications;

// for core motion
@property(nonatomic,retain)NSMutableArray * accelArray;

@property (strong, nonatomic) AVAudioPlayer* audioPlayer;
-(IBAction)moveUp:(id)sender;
-(IBAction)moveDown:(id)sender;
-(IBAction)moveLeft:(id)sender;
-(IBAction)moveRight:(id)sender;
-(void)placeFood;
-(void)snakeMoving;
-(void)setSpeed;
-(IBAction)start:(id)sender;
-(IBAction)pause:(id)sender;
-(IBAction)quit:(id)sender;
@end
