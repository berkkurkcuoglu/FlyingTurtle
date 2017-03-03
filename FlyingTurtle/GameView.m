//
//  GameView.m
//  FlyingTurtle
//
//  Created by berk on 2/25/17.
//  Copyright © 2017 berk. All rights reserved.
//

#import "GameView.h"

@implementation GameView

@synthesize turtle,bricks;
@synthesize delegate;
//@synthesize tilt;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    //counter = 0;
    _scoreLabel.adjustsFontSizeToFitWidth = YES;
    _scoreLabel.minimumScaleFactor = 0.4;
    _highScoreLabel.adjustsFontSizeToFitWidth = YES;
    _highScoreLabel.minimumScaleFactor = 0.4;
    [_highScoreLabel setText:[NSString stringWithFormat:@"Best: %ld",_highScore]];
    [self updateScore];
    [self setBackgroundColor:[UIColor purpleColor]];
    if (self)
    {
        CGRect bounds = [self bounds];
        turtle = [[Turtle alloc] initWithFrame:CGRectMake(50, bounds.size.height/2, 30 , 30)];        
        [turtle setImage:[UIImage imageNamed:@"turtle.jpg"]];
        [turtle setDy:2];
        [self addSubview:turtle];
        [turtle setDx:2];
        [turtle setJump:0];
        [self setup];
        //[self protectBricks];
    }
    return self;
}

-(void)updateScore{
    if(_currentScore > _highScore){
        _highScore = _currentScore;
        [[NSUserDefaults standardUserDefaults] setInteger:_highScore forKey:@"turtleHighScore"];
    }
    [_scoreLabel setText:[NSString stringWithFormat:@"Score: %ld",_currentScore]];
    [_highScoreLabel setText:[NSString stringWithFormat:@"Best: %ld",_highScore]];
}

-(void)setup{
    CGRect bounds = [self bounds];
    for (int i=0; i < [bricks count]; i++)
    {
        Brick *brick = [bricks objectAtIndex:i];
         [brick removeFromSuperview];
    }
    bricks = [[NSMutableArray alloc] init];
    for(int i =0; i < 2; i++){
    Brick *b = [[Brick alloc] initWithFrame:CGRectMake(0, 0, 20,(int)(bounds.size.width * .25))];
    [b setImage:[UIImage imageNamed:@"brick.png"]];
    [self addSubview:b];
    [b setCenter:CGPointMake((rand() % (int)(bounds.size.width * .5)+(bounds.size.width * .3)), rand() % (int)(bounds.size.height * .65))];
    //while([self isOverlapping:b])
       // [b setCenter:CGPointMake(rand() % (int)(bounds.size.width * .85), rand() % (int)(bounds.size.height * .65))];
    [bricks addObject:b];

    }
    for (int i=0; i < [_coins count]; i++)
    {
        Coin *coin = [_coins objectAtIndex:i];
        [coin removeFromSuperview];
    }
    _coins = [[NSMutableArray alloc] init];
    for(int i =0; i < 5; i++){
        Coin *c = [[Coin alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
        [c setImage:[UIImage imageNamed:@"coin.jpg"]];
        [self addSubview:c];
        [c setCenter:CGPointMake(rand() % (int)(bounds.size.width), rand() % (int)(bounds.size.height))];
        //while([self isOverlapping:b])
        // [b setCenter:CGPointMake(rand() % (int)(bounds.size.width * .85), rand() % (int)(bounds.size.height * .65))];
        [_coins addObject:c];
        
    }
}

-(void)play:(CADisplayLink *)sender{
    
    
    CGPoint p = [turtle center];
    CGRect f = [turtle frame];
    p.x += [turtle dx];
    p.y -= [turtle jump];
    [turtle setJump:0];
    //[turtle setDy:[turtle dy] - .3];
    p.y += [turtle dy];
    
    if(p.x + f.size.width/2 > [self bounds].size.width){
        p.x -=  [self bounds].size.width;
        [self setup];
        _currentScore += 100;
    }
    
    if(p.y > [self bounds].size.height - f.size.height/2){
        p.y = [self bounds].size.height - f.size.height/2 ;
    }
    if(p.y < f.size.height/2){
        p.y = f.size.height/2;
    }
    
    for (int i=0; i < [_coins count]; i++)
    {
        Coin *coin =[_coins objectAtIndex:i];
        CGRect cr = [coin frame];
        if (CGRectIntersectsRect(cr, f) && ![coin collected])
        {
            [coin setCollected:true];
            [coin removeFromSuperview];
            _currentScore += 50;
        }
    }

    for (int i=0; i < [bricks count]; i++)
    {
        CGRect b = [[bricks objectAtIndex:i] frame];
        if (CGRectIntersectsRect(b, f))
        {
            CGRect bounds = [self bounds];
            UILabel *gameOver = [[UILabel alloc]initWithFrame:CGRectMake(bounds.size.width/2, bounds.size.height/2, 200, 100)];
            [gameOver setTextColor:[UIColor whiteColor]];
            gameOver.text = @"GG WP";
            [self addSubview:gameOver];
            [delegate gameOver];
            [sender invalidate];
        }
    }

    [turtle setCenter:p];
    [self updateScore];
}

@end
