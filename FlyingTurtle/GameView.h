//
//  GameView.h
//  FlyingTurtle
//
//  Created by berk on 2/25/17.
//  Copyright © 2017 berk. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Turtle.h"
#include "Brick.h"
#include "Coin.h"

@protocol GameOverDelegate;

@interface GameView : UIView

@property (nonatomic, strong) Turtle *turtle;
@property (nonatomic, strong) NSMutableArray *bricks;
@property (nonatomic, strong) NSMutableArray *coins;
@property (nonatomic) NSInteger highScore;
@property (nonatomic) NSInteger currentScore;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (strong, nonatomic) id<GameOverDelegate>delegate;
@end


@protocol GameOverDelegate
-(void)gameOver;
@end
