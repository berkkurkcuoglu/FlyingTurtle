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
#include "Pizza.h"

@protocol GameOverDelegate;

@interface GameView : UIImageView

@property (nonatomic, strong) Turtle *turtle;
@property (nonatomic, strong) NSMutableArray *bricks;
@property (nonatomic, strong) NSMutableArray *coins;
@property (nonatomic, strong) NSArray* backgroundImages;
@property (nonatomic) NSInteger backgroundIndex;
@property (nonatomic, strong) Pizza *pizza;
@property (nonatomic) NSInteger highScore;
@property (nonatomic) NSInteger currentScore;
@property (nonatomic) NSInteger counter;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *livesLabel;
@property (strong, nonatomic) id<GameOverDelegate>delegate;

-(void)play:(CADisplayLink *)sender;
@end


@protocol GameOverDelegate
-(void)gameOver;
@end
