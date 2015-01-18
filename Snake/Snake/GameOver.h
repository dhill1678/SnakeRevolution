//
//  GameOver.h
//  Snake
//
//  Created by Viktor Todorov on 8/13/14.
//  Copyright (c) 2014 Viktor Todorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameOver : UIViewController {
    IBOutlet UIImageView* _square1;
    IBOutlet UIImageView* _square2;
    IBOutlet UIImageView* _square3;
    IBOutlet UIImageView* _square4;
    IBOutlet UIImageView* _titleLeftLine;
    IBOutlet UIImageView* _titleRightLine;
    IBOutlet UILabel* _titleLabel;
    IBOutlet UILabel* _scoreLabel;
    IBOutlet UILabel* _bestScoreLabel;
    IBOutlet UILabel* _againLabel;
    IBOutlet UILabel* _menuLabel;
    BOOL _isClassic;
}
@property int _scoreNumber;
@end
