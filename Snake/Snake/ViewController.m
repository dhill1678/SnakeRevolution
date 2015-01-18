//
//  ViewController.m
//  Snake
//
//  Created by Viktor Todorov on 8/12/14.
//  Copyright (c) 2014 Viktor Todorov. All rights reserved.
//
//  Modified by David Hill

#import "ViewController.h"
#import "GameOver.h"
#import "MobileBuilder.h"
#import "MainMenu.h"
#import <AVFoundation/AVFoundation.h>
//#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()

@end

#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

//Activate FLASH When Point number is:
static int pointsToActivateFlash1 = 25;
static int pointsToActivateFlash2 = 50;
static int pointsToActivateFlash3 = 100;
static int pointsToActivateFlash4 = 150;
static int pointsToActivateFlash5 = 200;
static int pointsToActivateFlash6 = 300;
static int pointsToActivateFlash7 = 450;
static int pointsToActivateFlash8 = 600;
static int pointsToActivateFlash9 = 750;
static int pointsToActivateFlash10 = 1000;

@implementation ViewController

// synthesize variables
@synthesize audioPlayer;
//@synthesize musicPlayer;
@synthesize accelArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isPurchase"] == NO) {
        [[MobileBuilder startBuilding]iAdStart:self];
        //[[MobileBuilder startBuilding]loadAdMobIfiADFAILS:@"ca-app-pub-8136035264927639/8871461901" controller:self];
    }
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isPurchase"] == NO) {
        [[MobileBuilder startBuilding]initialiseRevMob:@"5490b1ee952976f713ec8099" testMode:NO];
        [[MobileBuilder startBuilding]revmobShowBanner];
        [[MobileBuilder startBuilding]revmobShowAd];
    }
    
    // Load Difficulty Level
    if([[NSUserDefaults standardUserDefaults]integerForKey:@"DifficultyLevel"] == 2) {
        diffFactor = 2;
        snakeSize = 20; // for changing snake size
        baseSpeed = 0.2;
    } else if([[NSUserDefaults standardUserDefaults]integerForKey:@"DifficultyLevel"] == 3) {
        diffFactor = 3;
        snakeSize = 20; // for changing snake size
        baseSpeed = 0.1;
    } else if([[NSUserDefaults standardUserDefaults]integerForKey:@"DifficultyLevel"] == 4) {
        diffFactor = 4;
        snakeSize = 10; // for changing snake size
        baseSpeed = 0.03;
    } else {
        diffFactor = 1;
        snakeSize = 30; // for changing snake size
        baseSpeed = 0.5;
    }
    
    // For Music Import
    //musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    //[self registerMediaPlayerNotifications];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self prepareToStart];
    
    gyroModeLabel.hidden = YES;
    
    // initialize snake size
    //snakeSize = 20; // for changing snake size
    _snakeBlock1.frame = CGRectMake(0, 0, snakeSize, snakeSize); //resize snake blocks
    _snakeBlock2.frame = CGRectMake(0, 0, snakeSize, snakeSize);
    _snakeBlock3.frame = CGRectMake(0, 0, snakeSize, snakeSize);
    _snakeBlock4.frame = CGRectMake(0, 0, snakeSize, snakeSize);
    _snakeBlock5.frame = CGRectMake(0, 0, snakeSize, snakeSize);
    _snakeBlock3.center = CGPointMake(_startGame.center.x, _startGame.center.y + 50); // reposition snake - this order necessary
    _snakeBlock2.center = CGPointMake(_snakeBlock3.center.x + snakeSize, _snakeBlock3.center.y);
    _snakeBlock1.center = CGPointMake(_snakeBlock2.center.x + snakeSize, _snakeBlock3.center.y);
    _snakeBlock4.center = CGPointMake(_snakeBlock3.center.x - snakeSize, _snakeBlock3.center.y);
    _snakeBlock5.center = CGPointMake(_snakeBlock4.center.x - snakeSize, _snakeBlock3.center.y);
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"isButtons"] == 2) {
        SnakeX = snakeSize;
        SnakeY = 0;
        
        gyroModeLabel.text = @"Use Buttons Below to Control Snake Movement";
        gyroModeLabel.hidden = NO;
    } else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"isButtons"] == 3) {
        SnakeX = snakeSize;
        SnakeY = 0;
        
        gyroModeLabel.text = @"Swipe to Control Snake Movement";
        gyroModeLabel.hidden = NO;
    } else {
        SnakeX = 0;
        SnakeY = snakeSize;
        _snakeUpDownMovement = YES;
        _snakeSideMovement = NO;
        
        gyroModeLabel.text = @"Rotate Phone to Control Snake Movement ***Please Hold Phone Upright***";
        gyroModeLabel.hidden = NO;
    }
    
    // hide food on load
    _food.hidden = YES;
    _food2.hidden = YES;
    _food3.hidden = YES;
    _food4.hidden = YES; // Added for more food
    _food5.hidden = YES; // Added for more food
    _food6.hidden = YES; // Added for more food
    
    // hide & initialize flash screen on load
    flashScreen.alpha = 0;
    _isFlashActive = NO;
    
    // show start button
    _startGame.hidden = YES;
    
    // added for pause
    _isPaused = NO;
    _pauseGame.hidden = YES;
    
    // initialize play and quit buttons
    //playButton.hidden = YES;
    quitButton.hidden = YES;
    //CALayer *btnLayer = [playButton layer];
    //[btnLayer setMasksToBounds:YES];
    //[btnLayer setCornerRadius:10.0f];
    CALayer *btnLayer2 = [quitButton layer];
    [btnLayer2 setMasksToBounds:YES];
    [btnLayer2 setCornerRadius:30.0f];

    
    // initialize snake array
    _isGrowing = NO;
    //_isShrinking = NO;
    _snakeArray = [NSMutableArray new];
    [_snakeArray addObject:_snakeBlock1];
    [_snakeArray addObject:_snakeBlock2];
    [_snakeArray addObject:_snakeBlock3];
    [_snakeArray addObject:_snakeBlock4];
    [_snakeArray addObject:_snakeBlock5];
    
    // initialize scissors
    _isEaten = YES;
    
    // initialize score
    _scoreNumber = 0;
    NSString* score = [NSString stringWithFormat:@"Points: %i", _scoreNumber];
    _scoreLabel.text = score;
    [[_scoreLabel superview] bringSubviewToFront:_scoreLabel]; //bring to front
    
    // determine game type
    _isClassic = [[NSUserDefaults standardUserDefaults]boolForKey:@"isClassic"];
    
    // initialize swipe actions or direction button appearance
    [self.view setUserInteractionEnabled:YES];
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"isButtons"] == 2) {
        _up.hidden = NO;
        _down.hidden = NO;
        _left.hidden = NO;
        _right.hidden = NO;
        
        //if ([motionManager isAccelerometerActive] == YES) {
            //[motionManager stopAccelerometerUpdates];
        //}
    } else if ([[NSUserDefaults standardUserDefaults]integerForKey:@"isButtons"] == 3) {
        UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(oneFingerSwipeLeft:)];
        [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [[self view] addGestureRecognizer:oneFingerSwipeLeft];
        
        UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]
                                                         initWithTarget:self
                                                         action:@selector(oneFingerSwipeRight:)];
        [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        [[self view] addGestureRecognizer:oneFingerSwipeRight];
        
        UISwipeGestureRecognizer *oneFingerSwipeUp = [[UISwipeGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(oneFingerSwipeUp:)];
        [oneFingerSwipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
        [[self view] addGestureRecognizer:oneFingerSwipeUp];
        
        UISwipeGestureRecognizer *oneFingerSwipeDown = [[UISwipeGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(oneFingerSwipeDown:)];
        [oneFingerSwipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
        [[self view] addGestureRecognizer:oneFingerSwipeDown];
        
        _up.hidden = YES;
        _down.hidden = YES;
        _left.hidden = YES;
        _right.hidden = YES;
        
        //if ([motionManager isAccelerometerActive] == YES) {
            //[motionManager stopAccelerometerUpdates];
        //}
        
    } else {
        
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"isButtons"];
        
        accelArray = [[NSMutableArray alloc]init];
        motionManager = [[CMMotionManager alloc] init];
        
        
        // Handle Accelerometer
        motionManager.accelerometerUpdateInterval = 1.0/10.0;  // Update at 10Hz
        if (!motionManager.accelerometerAvailable) {
            NSLog(@"You're Not Accredited BRO!!!");
        } else {
            NSLog(@"Accel Available!!!");
            
            queue = [NSOperationQueue currentQueue];
            [motionManager startAccelerometerUpdatesToQueue:queue
                                                withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                    CMAcceleration acceleration = accelerometerData.acceleration;
                                                    if([[NSUserDefaults standardUserDefaults]integerForKey:@"isButtons"] < 2) {
                                                        if (acceleration.y < -0.5 && _snakeSideMovement) {
                                                            [self oneFingerSwipeDown:nil];
                                                        } else if ((acceleration.y > 0.5 && _snakeSideMovement)) {
                                                            [self oneFingerSwipeUp:nil];
                                                        } else if (acceleration.x < -0.5 && _snakeUpDownMovement) {
                                                            [self oneFingerSwipeLeft:nil];
                                                        } else if ((acceleration.x > 0.5 && _snakeUpDownMovement)) {
                                                            [self oneFingerSwipeRight:nil];
                                                        }
                                                    }
                                                }];
        }

        _up.hidden = YES;
        _down.hidden = YES;
        _left.hidden = YES;
        _right.hidden = YES;
        
    }
    
    /*
    // control audio playback
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isMusicOn"] == YES) {
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:@"music"
                                             ofType:@"wav"]];
        
        self.audioPlayer = [[AVAudioPlayer alloc]
                                      initWithContentsOfURL:url
                                      error:nil];
         self.audioPlayer.numberOfLoops = -1;

        [ self.audioPlayer play];
    }
     */

}

// control snake turns - left, right, up, down
-(void)oneFingerSwipeLeft:(UIGestureRecognizer*)recognizer {
    NSLog(@"Left");
    if(_snakeSideMovement == NO) {
        SnakeX = -snakeSize;
        SnakeY = 0;
        _snakeSideMovement = YES;
        _snakeUpDownMovement = NO;
    }
}
-(void)oneFingerSwipeRight:(UIGestureRecognizer*)recognizer {
    NSLog(@"Right");
    if(_snakeSideMovement == NO) {
        SnakeX = snakeSize;
        SnakeY = 0;
        _snakeSideMovement = YES;
        _snakeUpDownMovement = NO;
    }
}
-(void)oneFingerSwipeUp:(UIGestureRecognizer*)recognizer {
    NSLog(@"Up");
    if(_snakeUpDownMovement == NO) {
        SnakeX = 0;
        SnakeY = -snakeSize;
        _snakeUpDownMovement = YES;
        _snakeSideMovement = NO;
    }
}
-(void)oneFingerSwipeDown:(UIGestureRecognizer*)recognizer {
    NSLog(@"Down");
    if(_snakeUpDownMovement == NO) {
        SnakeX = 0;
        SnakeY = snakeSize;
        _snakeUpDownMovement = YES;
        _snakeSideMovement = NO;
    }

}

// control snake movement
-(void)snakeMoving {
    
    // define each block's position - control body movement
    for (int i = (int)[_snakeArray count]-1; i >= 0; i--) {
        //NSLog(@"%d",i); // for checking
        UIImageView* block = [_snakeArray objectAtIndex:i];
        if(i > 0) {
            UIImageView* previousBlock = [_snakeArray objectAtIndex:i - 1];
            block.center = CGPointMake(previousBlock.center.x, previousBlock.center.y);
        } else {
            block.center = CGPointMake(block.center.x + SnakeX, block.center.y + SnakeY);
        }
    }
    
    NSLog(@"%f",_snakeBlock1.center.x);
    
    // control snake eating
    if(CGRectIntersectsRect(_snakeBlock1.frame, _food.frame)) {
        [[MobileBuilder startBuilding]shake:self.view];
        [self snakeGrow];
        [self placeFood];
        if (_food6.hidden == NO) {
            _food6.hidden = YES;
        }
        _scoreNumber += 1;
        if (_isFlashActive) {
            _scoreNumber += 1;
        }
        NSString* score = [NSString stringWithFormat:@"Points: %i", _scoreNumber];
        _scoreLabel.text = score;
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"isMusicOn"] == YES) {
            [[MobileBuilder startBuilding]playSound:@"eat" type:@"wav"];
        }
    }
    else {
        _isGrowing = NO;
    }
    if(CGRectIntersectsRect(_snakeBlock1.frame, _food2.frame)) {
        [[MobileBuilder startBuilding]shake:self.view];
        [self snakeGrow];
        [self placeTheSecondFood];
        if (_food6.hidden == NO) {
            _food6.hidden = YES;
        }
        _scoreNumber += 1;
        if (_isFlashActive) {
            _scoreNumber += 1;
        }
        NSString* score = [NSString stringWithFormat:@"Points: %i", _scoreNumber];
        _scoreLabel.text = score;
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"isMusicOn"] == YES) {
            [[MobileBuilder startBuilding]playSound:@"eat" type:@"wav"];
        }
    }
    if(CGRectIntersectsRect(_snakeBlock1.frame, _food3.frame)) {
        [[MobileBuilder startBuilding]shake:self.view];
        [self snakeGrow];
        [self placeTheThirdFood];
        [self placeTheFifthFood];
        if (_food6.hidden == NO) {
            _food6.hidden = YES;
        }
        _scoreNumber += 1;
        if (_isFlashActive) {
            _scoreNumber += 1;
        }
        NSString* score = [NSString stringWithFormat:@"Points: %i", _scoreNumber];
        _scoreLabel.text = score;
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"isMusicOn"] == YES) {
            [[MobileBuilder startBuilding]playSound:@"eat" type:@"wav"];
        }
    }
    // Added for more food - to be altered later
    if(CGRectIntersectsRect(_snakeBlock1.frame, _food4.frame) && _food4.hidden == NO) {
        [[MobileBuilder startBuilding]shake:self.view];
        if ([_snakeArray count] > 2) {
            [self snakeShrink];
            [self snakeShrink];
            if (_isFlashActive && [_snakeArray count] > 2) {
                [self snakeShrink];
                [self snakeShrink];
            }
        }
        _isEaten = YES;
        //[self placeTheFourthFood];
        _food4.hidden = YES;
        if (_food6.hidden == NO) {
            _food6.hidden = YES;
        }
        //_scoreNumber += diffFactor*2;
        //NSString* score = [NSString stringWithFormat:@"Points: %i", _scoreNumber];
        //_scoreLabel.text = score;
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"isMusicOn"] == YES) {
            [[MobileBuilder startBuilding]playSound:@"scissors" type:@"wav"];
        }
    }
    if(CGRectIntersectsRect(_snakeBlock1.frame, _food5.frame) && _food5.hidden == NO) {
        [[MobileBuilder startBuilding]shake:self.view];
        [self snakeGrow];
        //[self placeTheFifthFood];
        _food5.hidden = YES;
        if (_food6.hidden == NO) {
            _food6.hidden = YES;
        }
        /*
        if (_food4.hidden == NO) {
            _food4.hidden = YES;
        }
         */
        //_scoreNumber += diffFactor*3;
        //NSString* score = [NSString stringWithFormat:@"Points: %i", _scoreNumber];
        //_scoreLabel.text = score;
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"isMusicOn"] == YES) {
            [[MobileBuilder startBuilding]playSound:@"eat" type:@"wav"];
        }
    }
    if(CGRectIntersectsRect(_snakeBlock1.frame, _food6.frame) && _food6.hidden == NO) {
        [[MobileBuilder startBuilding]shake:self.view];
        [self snakeGrow];
        [self snakeGrow]; // grows twice for bonus
        //[self placeTheSixthFood];
        _food6.hidden = YES;
        /*
        if (_food4.hidden == NO) {
            _food4.hidden = YES;
        }
         */
        _scoreNumber += diffFactor*5;
        NSString* score = [NSString stringWithFormat:@"Points: %i", _scoreNumber];
        _scoreLabel.text = score;
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"isMusicOn"] == YES) {
            [[MobileBuilder startBuilding]playSound:@"yum" type:@"wav"];
        }
    }


    // control wall behavior
    UIImageView* leadingBlock = [_snakeArray objectAtIndex:0];

    if(_isClassic == NO) {
        if(leadingBlock.center.x > self.view.frame.size.width) {
            leadingBlock.center = CGPointMake(0, leadingBlock.center.y);
        }
        if(leadingBlock.center.x < 0) {
            leadingBlock.center = CGPointMake(self.view.frame.size.width, leadingBlock.center.y);
        }
        if (leadingBlock.center.y > self.view.frame.size.height) {
            leadingBlock.center = CGPointMake(leadingBlock.center.x, 0);
        }
        if(leadingBlock.center.y < 0) {
            leadingBlock.center = CGPointMake(leadingBlock.center.x, self.view.frame.size.height);
        }
    } else {
        if(leadingBlock.center.x > self.view.frame.size.width) {
            [self gameOver];
        }
        if(leadingBlock.center.x < 0) {
            [self gameOver];
        }
        if (leadingBlock.center.y > self.view.frame.size.height) {
            [self gameOver];
        }
        if(leadingBlock.center.y < 0) {
            [self gameOver];
        }
    }
    
    // kill snake on tail hit
    for (int i = 1; i < [_snakeArray count]; i++) {
        UIImageView *_taleBlock = [_snakeArray objectAtIndex:i];
        if(CGRectIntersectsRect(leadingBlock.frame, _taleBlock.frame)) {
            [self gameOver];
        }
    }
    
    // define appearance of special fruit
    if (_scoreNumber % 25 < 4 && _scoreNumber > 4) {
        if (_food4.hidden == YES && _isEaten == NO) {
            [self placeTheFourthFood];
        }
    } else if (_scoreNumber % 25 >= 4) {
        _isEaten = NO;
        if (_food4.hidden == NO) {
            _food4.hidden = YES;
        }
    }
    if (_scoreNumber % 5 == 0 && _scoreNumber > 0) {
        if (_food5.hidden == YES) {
            [self placeTheFifthFood];
        }
    }
    if (_scoreNumber % 20 == 0 && _scoreNumber > 0) {
        if (_food6.hidden == YES) {
            [self placeTheSixthFood];
        }
    }
    
    // control flashes
    if (_scoreNumber >= pointsToActivateFlash1 && _scoreNumber <= pointsToActivateFlash1 + 5) {
        if(_isFlashActive == NO) {
            [self flashEffect];
            _isFlashActive = YES;
            [self placeTheSixthFood];
        }
    }
    if (_scoreNumber >= pointsToActivateFlash2 && _scoreNumber <= pointsToActivateFlash2 + 7) {
        if(_isFlashActive == NO) {
            [self flashEffect];
            _isFlashActive = YES;
            [self placeTheSixthFood];
        }
    }
    if (_scoreNumber >= pointsToActivateFlash3 && _scoreNumber <= pointsToActivateFlash3 + 10) {
        if(_isFlashActive == NO) {
            [self flashEffect];
            _isFlashActive = YES;
            [self placeTheSixthFood];
        }
    }
    if (_scoreNumber >= pointsToActivateFlash4 && _scoreNumber <= pointsToActivateFlash4 + 15) {
        if(_isFlashActive == NO) {
            [self flashEffect];
            _isFlashActive = YES;
            [self placeTheSixthFood];
        }
    }
    if (_scoreNumber >= pointsToActivateFlash5 && _scoreNumber <= pointsToActivateFlash5 + 20) {
        if(_isFlashActive == NO) {
            [self flashEffect];
            _isFlashActive = YES;
            [self placeTheSixthFood];
        }
    }
    if (_scoreNumber >= pointsToActivateFlash6 && _scoreNumber <= pointsToActivateFlash6 + 30) {
        if(_isFlashActive == NO) {
            [self flashEffect];
            _isFlashActive = YES;
            [self placeTheSixthFood];
        }
    }
    if (_scoreNumber >= pointsToActivateFlash7 && _scoreNumber <= pointsToActivateFlash7 + 30) {
        if(_isFlashActive == NO) {
            [self flashEffect];
            _isFlashActive = YES;
            [self placeTheSixthFood];
        }
    }
    if (_scoreNumber >= pointsToActivateFlash8 && _scoreNumber <= pointsToActivateFlash8 + 30) {
        if(_isFlashActive == NO) {
            [self flashEffect];
            _isFlashActive = YES;
            [self placeTheSixthFood];
        }
    }
    if (_scoreNumber >= pointsToActivateFlash9 && _scoreNumber <= pointsToActivateFlash9 + 30) {
        if(_isFlashActive == NO) {
            [self flashEffect];
            _isFlashActive = YES;
            [self placeTheSixthFood];
        }
    }
    if (_scoreNumber >= pointsToActivateFlash10) {
        if(_isFlashActive == NO) {
            [self flashEffect];
            _isFlashActive = YES;
            [self placeTheSixthFood];
        }
    }
}

-(void)gameOver {
    [self.audioPlayer stop];
    
    // Request to stop receiving accelerometer events and turn off accelerometer
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    //[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    // stop gyro mode
    if([[NSUserDefaults standardUserDefaults]integerForKey:@"isButtons"] == 1) {
        [motionManager stopDeviceMotionUpdates];
    }
    
    NSLog(@"Game Over");
    [_snakeMovement invalidate];
    _mainSquare.center = CGPointMake(_snakeBlock1.center.x, _snakeBlock1.center.y);
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isMusicOn"] == YES) {
        [[MobileBuilder startBuilding]playSound:@"youlose" type:@"wav"];
    }
    
    [UIView animateWithDuration:0.7
                          delay:0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _mainSquare.frame = CGRectMake(IS_IPAD?190:40,IS_IPAD?334:186, IS_IPAD?400:240, IS_IPAD?400:240);
                     }
                     completion:^(BOOL finished){
                         _startGame.hidden = YES;
                         _scoreLabel.hidden = YES;
                         _left.hidden = YES;
                         _right.hidden = YES;
                         _up.hidden = YES;
                         _down.hidden = YES;
                         
                         UIStoryboard *storyboard = self.storyboard;
                         GameOver *svc = [storyboard instantiateViewControllerWithIdentifier:@"gameover"];
                         svc._scoreNumber = _scoreNumber;
                         [self presentViewController:svc animated:NO completion:nil];
                         
                     }];

}

// control snake growth
-(void)snakeGrow {
    if(_isGrowing == NO) {
        UIImageView* lastBlock = [_snakeArray objectAtIndex:[_snakeArray count]-1];
        UIImageView *newBlock = [[UIImageView alloc]init];
        [self.view addSubview:newBlock];
        newBlock.frame = CGRectMake(0, 0, snakeSize, snakeSize); // needs to be changed on snake resize
        newBlock.center = CGPointMake(lastBlock.center.x, lastBlock.center.y);
        newBlock.backgroundColor = [UIColor blackColor];
        [_snakeArray addObject:newBlock];
        _isGrowing = YES;
    }
}
-(void)snakeShrink {
    UIImageView* lastBlock = [_snakeArray objectAtIndex:[_snakeArray count]-1];
    [lastBlock removeFromSuperview];
    [_snakeArray removeObject:lastBlock];
}

// place food
-(void)placeFood {
    FoodX = arc4random() % (IS_IPAD?600:249);
    FoodX = FoodX + 34;
    FoodY = arc4random() % (IS_IPAD?900:492);
    FoodY = FoodY + 39;
    
    _food.center = CGPointMake(FoodX, FoodY);
}
-(void)placeTheSecondFood {
    FoodX = arc4random() % (IS_IPAD?600:249);
    FoodX = FoodX + 34;
    FoodY = arc4random() % (IS_IPAD?900:492);
    FoodY = FoodY + 39;
    
    _food2.center = CGPointMake(FoodX, FoodY);
}
-(void)placeTheThirdFood {
    FoodX = arc4random() % (IS_IPAD?600:249);
    FoodX = FoodX + 34;
    FoodY = arc4random() % (IS_IPAD?900:492);
    FoodY = FoodY + 39;
    
    _food3.center = CGPointMake(FoodX, FoodY);
}
// Added for more food
-(void)placeTheFourthFood {
    FoodX = arc4random() % (IS_IPAD?600:249);
    FoodX = FoodX + 34;
    FoodY = arc4random() % (IS_IPAD?900:492);
    FoodY = FoodY + 39;
    
    _food4.center = CGPointMake(FoodX, FoodY);
    _food4.hidden = NO;
}
-(void)placeTheFifthFood {
    FoodX = arc4random() % (IS_IPAD?600:249);
    FoodX = FoodX + 34;
    FoodY = arc4random() % (IS_IPAD?900:492);
    FoodY = FoodY + 39;
    
    _food5.center = CGPointMake(FoodX, FoodY);
    _food5.hidden = NO;
}
-(void)placeTheSixthFood {
    FoodX = arc4random() % (IS_IPAD?600:249);
    FoodX = FoodX + 34;
    FoodY = arc4random() % (IS_IPAD?900:492);
    FoodY = FoodY + 39;
    
    _food6.center = CGPointMake(FoodX, FoodY);
    _food6.hidden = NO;
}

// set snake speed
-(void)setSpeed {
    // Change Snake Speed - Use this for difficulty level change
    // 0.2 is slower than 0.1
    //float baseSpeed;
    
    /*
    // Load Difficulty Level
    if([[NSUserDefaults standardUserDefaults]integerForKey:@"DifficultyLevel"] == 2) {
        baseSpeed = 0.6;
    } else if([[NSUserDefaults standardUserDefaults]integerForKey:@"DifficultyLevel"] == 3) {
        baseSpeed = 0.3;
    } else {
        baseSpeed = 0.1;
    }
     */
    
    if(IS_IPAD) {
        _snakeMovement = [NSTimer scheduledTimerWithTimeInterval:baseSpeed   target:self selector:@selector(snakeMoving) userInfo:nil repeats:YES];
    }
    else {
        _snakeMovement = [NSTimer scheduledTimerWithTimeInterval:baseSpeed   target:self selector:@selector(snakeMoving) userInfo:nil repeats:YES];
    }
}

// start game
-(IBAction)start:(id)sender {    
    _food.hidden = NO;
    _startGame.hidden = YES;
    _pauseGame.hidden = NO;
    _food2.hidden = NO;
    _food3.hidden = NO;
    _food4.hidden = YES; // Added for more food
    _food5.hidden = YES;
    _food6.hidden = YES;
    gyroModeLabel.hidden = YES;
    
    [self setSpeed];
    NSLog(@"@base speed: %f",baseSpeed);
    
    [self placeFood];
    [self placeTheSecondFood];
    [self placeTheThirdFood];
    //[self placeTheFourthFood];
    //[self placeTheFifthFood];
    //[self placeTheSixthFood];
}

// pause game
-(IBAction)pause:(id)sender {
    if(_isPaused == NO) {
        [self.audioPlayer stop];
        NSLog(@"Pause");
        [_snakeMovement invalidate];
        _isPaused = YES;
        
        // show play & quit buttons
        //playButton.hidden = NO;
        quitButton.hidden = NO;
        [[quitButton superview] bringSubviewToFront:quitButton]; //bring to front
        [[_scoreLabel superview] bringSubviewToFront:_scoreLabel]; //bring to front
        
        // change button image
        //_pauseGame.hidden = YES;
        UIImage *playButton = [UIImage imageNamed:@"play.png"];
        [_pauseGame setImage:playButton forState:UIControlStateNormal];
    } else {
        [self.audioPlayer play];
        NSLog(@"Play");
        //[_snakeMovement fire]; // doesn't work
        [self setSpeed];
        _isPaused = NO;
        
        // show play & quit buttons
        //playButton.hidden = YES;
        quitButton.hidden = YES;
        
        // change button image
        //_pauseGame.hidden = NO;
        UIImage *pauseButton = [UIImage imageNamed:@"pause.png"];
        [_pauseGame setImage:pauseButton forState:UIControlStateNormal];
    }
}

// quit game
- (IBAction)quit:(id)sender {
    
    UIStoryboard *storyboard = self.storyboard;
    MainMenu *svc = [storyboard instantiateViewControllerWithIdentifier:@"menu"];
    [self presentViewController:svc animated:NO completion:nil];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isPurchase"] == NO) {
        [[MobileBuilder startBuilding]initialiseRevMob:@"5490b1ee952976f713ec8099" testMode:NO];
        [[MobileBuilder startBuilding]revmobShowAd];
    }
    
    // stop gyro mode
    //if([[NSUserDefaults standardUserDefaults]integerForKey:@"isButtons"] == 1) {
        //[motionManager stopDeviceMotionUpdates];
    //}
}

// initialize game
-(void)prepareToStart {
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _mainSquare.frame = CGRectMake(_snakeBlock1.center.x, _snakeBlock1.center.y, 0, 0);
                     }
                     completion:^(BOOL finished){
                         _startGame.hidden = NO;
                     }];

}

// flash effect changed to vary color
-(void)flashEffect {
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         flashScreen.alpha = 1;
                         flashScreen.backgroundColor = [UIColor blueColor];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2
                                               delay:0
                                             options: UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              flashScreen.alpha = 0;
                                          }
                                          completion:^(BOOL finished){
                                              
                                              [UIView animateWithDuration:0.4
                                                                    delay:0
                                                                  options: UIViewAnimationOptionBeginFromCurrentState
                                                               animations:^{
                                                                   flashScreen.alpha = 1;
                                                                   flashScreen.backgroundColor = [UIColor blackColor];
                                                               }
                                                               completion:^(BOOL finished){
                                                                   
                                                                   [UIView animateWithDuration:0.2
                                                                                         delay:0
                                                                                       options: UIViewAnimationOptionBeginFromCurrentState
                                                                                    animations:^{
                                                                                        flashScreen.alpha = 0;
                                                                                    }
                                                                                    completion:^(BOOL finished){
                                                                                        [UIView animateWithDuration:0.2
                                                                                                              delay:0
                                                                                                            options: UIViewAnimationOptionBeginFromCurrentState
                                                                                                         animations:^{
                                                                                                             flashScreen.alpha = 1;
                                                                                                             flashScreen.backgroundColor = [UIColor redColor];
                                                                                                         }
                                                                                                         completion:^(BOOL finished){
                                                                                                             
                                                                                                             [UIView animateWithDuration:0.2
                                                                                                                                   delay:0
                                                                                                                                 options: UIViewAnimationOptionBeginFromCurrentState
                                                                                                                              animations:^{
                                                                                                                                  flashScreen.alpha = 0;
                                                                                                                              }
                                                                                                                              completion:^(BOOL finished){
                                                                                                                                  
                                                                                                                                  [UIView animateWithDuration:0.2
                                                                                                                                                        delay:0
                                                                                                                                                      options: UIViewAnimationOptionBeginFromCurrentState
                                                                                                                                                   animations:^{
                                                                                                                                                       flashScreen.alpha = 1;
                                                                                                                                                       flashScreen.backgroundColor = [UIColor orangeColor];
                                                                                                                                                   }
                                                                                                                                                   completion:^(BOOL finished){
                                                                                                                                                       
                                                                                                                                                       [UIView animateWithDuration:0.2
                                                                                                                                                                             delay:0
                                                                                                                                                                           options: UIViewAnimationOptionBeginFromCurrentState
                                                                                                                                                                        animations:^{
                                                                                                                                                                            flashScreen.alpha = 0;
                                                                                                                                                                        }
                                                                                                                                                                        completion:^(BOOL finished){
                                                                                                                                                                            [UIView animateWithDuration:0.4
                                                                                                                                                                                                  delay:0
                                                                                                                                                                                                options: UIViewAnimationOptionBeginFromCurrentState
                                                                                                                                                                                             animations:^{
                                                                                                                                                                                                 flashScreen.alpha = 1;
                                                                                                                                                                                                 flashScreen.backgroundColor = [UIColor blackColor];
                                                                                                                                                                                             }
                                                                                                                                                                                             completion:^(BOOL finished){
                                                                                                                                                                                                 
                                                                                                                                                                                                 [UIView animateWithDuration:0.2
                                                                                                                                                                                                                       delay:0
                                                                                                                                                                                                                     options: UIViewAnimationOptionBeginFromCurrentState
                                                                                                                                                                                                                  animations:^{
                                                                                                                                                                                                                      flashScreen.alpha = 0;
                                                                                                                                                                                                                  }
                                                                                                                                                                                                                  completion:^(BOOL finished){
                                                                                                                                                                                                                      flashScreen.alpha = 0;
                                                                                                                                                                                                                      _isFlashActive = NO;
                                                                                                                                                                                                                  }];
                                                                                                                                                                                                 
                                                                                                                                                                                             }];
                                                                                                                                                                            
                                                                                                                                                                        }];
                                                                                                                                                       
                                                                                                                                                   }];
                                                                                                                                  
                                                                                                                              }];
                                                                                                             
                                                                                                         }];
                                                                                        
                                                                                    }];
                                                                   
                                                               }];
                                              
                                          }];
                         
                     }];
    
}

// set direction button actions
-(IBAction)moveUp:(id)sender {
    [self oneFingerSwipeUp:nil];
}
-(IBAction)moveDown:(id)sender {
    [self oneFingerSwipeDown:nil];
}
-(IBAction)moveLeft:(id)sender {
    [self oneFingerSwipeLeft:nil];
}
-(IBAction)moveRight:(id)sender {
    [self oneFingerSwipeRight:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
