//
//  MainMenu.h
//  Snake
//
//  Created by Viktor Todorov on 8/13/14.
//  Copyright (c) 2014 Viktor Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MainMenu : UIViewController <AVAudioPlayerDelegate> {
    
    //Image Views
    IBOutlet UIImageView* _square1;
    IBOutlet UIImageView* _square2;
    IBOutlet UIImageView* _square3;
    IBOutlet UIImageView* _square4;
    //IBOutlet UIImageView* _titleLeftLine;
    //IBOutlet UIImageView* _titleRightLine;
    IBOutlet UIImageView* _homeButton;
    
    //Title
    IBOutlet UILabel* _titleLabel;
    
    IBOutlet UIButton *_playGame;
    IBOutlet UIButton *_gameSettings;
    IBOutlet UIButton *_gameCenter;
    
    //Gestures
    UITapGestureRecognizer *openSettings;
    UITapGestureRecognizer *backHome;
    UITapGestureRecognizer *classic;
    UITapGestureRecognizer *nowalls;
    //UITapGestureRecognizer *removeads;
    //UITapGestureRecognizer *restore;
    UITapGestureRecognizer *classChange;
    UITapGestureRecognizer *difficulty;
    UITapGestureRecognizer *music;
    UITapGestureRecognizer *controlls;
    UITapGestureRecognizer *gameCenter;
}
@end
