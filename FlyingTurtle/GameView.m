//
//  GameView.m
//  FlyingTurtle
//
//  Created by berk on 2/25/17.
//  Copyright © 2017 berk. All rights reserved.
//

#import "GameView.h"

@implementation GameView

@synthesize turtle,bricks,coins,pizza;
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
    _livesLabel.adjustsFontSizeToFitWidth = YES;
    _livesLabel.minimumScaleFactor = 0.4;
    _scoreLabel.adjustsFontSizeToFitWidth = YES;
    _scoreLabel.minimumScaleFactor = 0.4;
    _highScoreLabel.adjustsFontSizeToFitWidth = YES;
    _highScoreLabel.minimumScaleFactor = 0.4;
    [_highScoreLabel setText:[NSString stringWithFormat:@"Best: %ld",_highScore]];
    [self updateScore];
    _backgroundImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"back1.png"],[UIImage imageNamed:@"back2.png"],[UIImage imageNamed:@"back3.png"], nil];
    [self setImage:[_backgroundImages objectAtIndex:0]];
    _backgroundIndex = 0;
    if (self)
    {
        CGRect bounds = [self bounds];
        turtle = [[Turtle alloc] initWithFrame:CGRectMake(50, bounds.size.height/2, 40 , 40)];
        [turtle setImage:[UIImage imageNamed:@"turtle.png"]];
        [self addSubview:turtle];
        [turtle setDy:1.6];
        [turtle setDx:2];
        [turtle setJump:0];
        [turtle setLives:3];
        [self setup];
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
    for(int i =0; i < 3; i++){
    Brick *b = [[Brick alloc] initWithFrame:CGRectMake(0, 0, (int)(bounds.size.width * .05),(int)(bounds.size.height * .25))];
    [b setImage:[UIImage imageNamed:@"brick.png"]];
    [self addSubview:b];
    [b setTouched:false];
    [b setCenter:CGPointMake((rand() % (int)(bounds.size.width * .5)+(bounds.size.width * .3)), rand() % (int)(bounds.size.height - b.frame.size.height) + b.frame.size.height/2)];
        int tries = 10;
    while([self brickIsOverlapping:b] || --tries > 0)
        [b setCenter:CGPointMake((rand() % (int)(bounds.size.width * .5)+(bounds.size.width * .3)), rand() % (int)(bounds.size.height - b.frame.size.height) + b.frame.size.height/2)];
    [bricks addObject:b];

    }
    for (int i=0; i < [coins count]; i++)
    {
        Coin *coin = [coins objectAtIndex:i];
        [coin removeFromSuperview];
    }
    coins = [[NSMutableArray alloc] init];
    for(int i =0; i < 5; i++){
        Coin *c = [[Coin alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
        [c setImage:[UIImage imageNamed:@"coin.png"]];
        [self addSubview:c];
        [c setCollected:false];
        [c setCenter:CGPointMake(rand() % (int)(bounds.size.width-c.frame.size.width) + c.frame.size.width/2, rand() % (int)(bounds.size.height-c.frame.size.height) + c.frame.size.height/2)];
        while([self coinIsOverlapping:c])
         [c setCenter:CGPointMake(rand() % (int)(bounds.size.width-c.frame.size.width) + c.frame.size.width/2, rand() % (int)(bounds.size.height-c.frame.size.height) + c.frame.size.height/2)];
        [coins addObject:c];
        
    }
    
    if(_currentScore % 400 == 0){
        [pizza removeFromSuperview];
        pizza = [[Pizza alloc] initWithFrame:CGRectMake(0, 0,20, 20)];
        [pizza setImage:[UIImage imageNamed:@"pizza.png"]];
        [self addSubview:pizza];
        [pizza setCenter:CGPointMake(rand() % (int)(bounds.size.width-pizza.frame.size.width) + pizza.frame.size.width/2, rand() % (int)(bounds.size.height-pizza.frame.size.height) + pizza.frame.size.height/2)];
        [pizza setCollected:false];
    }
}

-(BOOL)brickIsOverlapping:(Brick*) brick{
    CGRect theFrame = [brick frame];
    for (int i=0; i < [bricks count]; i++){
        Brick *otherBrick = [bricks objectAtIndex:i];
        CGRect otherFrame = [otherBrick frame];
        if(brick != otherBrick && (CGRectIntersectsRect(theFrame, otherFrame) || (fabs(brick.center.x-otherBrick.center.x) < (turtle.frame.size.width*1.6+theFrame.size.width) && fabs(brick.center.y-otherBrick.center.y) < (turtle.frame.size.height*2+theFrame.size.height))))
            return true;
    }
    for (int i=0; i < [coins count]; i++){
        Coin *otherCoin = [coins objectAtIndex:i];
        CGRect otherFrame = [otherCoin frame];
        if(CGRectIntersectsRect(theFrame, otherFrame))
            return true;
    }
    if(CGRectIntersectsRect(theFrame, [pizza frame]))
        return true;
    
    return false;
}

-(BOOL)coinIsOverlapping:(Coin*) coin{
    CGRect theFrame = [coin frame];
    
    for (int i=0; i < [coins count]; i++){
        Coin *otherCoin = [coins objectAtIndex:i];
        CGRect otherFrame = [otherCoin frame];
        if(coin != otherCoin && CGRectIntersectsRect(theFrame, otherFrame))
            return true;
    }
    
    for (int i=0; i < [bricks count]; i++){
        Brick *otherBrick = [bricks objectAtIndex:i];
        CGRect otherFrame = [otherBrick frame];
        if(CGRectIntersectsRect(theFrame, otherFrame))
            return true;
    }
    if(CGRectIntersectsRect(theFrame, [pizza frame]))
        return true;
    
    return false;
}

-(void)play:(CADisplayLink *)sender{
    
    
    CGPoint p = [turtle center];
    CGRect f = [turtle frame];
    p.x += [turtle dx];
    p.y -= [turtle jump];
    [turtle setJump:0];
    //[turtle setDy:[turtle dy] - .3];
    p.y += [turtle dy];
    CGRect fakeFrame = CGRectMake(turtle.center.x-f.size.width/2, turtle.center.y-f.size.height/2, turtle.frame.size.width-12, turtle.frame.size.height-12);
    
    if(p.x + f.size.width/2 > [self bounds].size.width){
        p.x -=  [self bounds].size.width;
        [self setup];
        _backgroundIndex = (_backgroundIndex+1) % 3;
        [self setImage:[_backgroundImages objectAtIndex:_backgroundIndex]];
        _currentScore += 100;
    }
    
    if(p.y > [self bounds].size.height - f.size.height/2){
        p.y = [self bounds].size.height - f.size.height/2 ;
    }
    if(p.y < f.size.height/2){
        p.y = f.size.height/2;
    }
    
    for (int i=0; i < [coins count]; i++)
    {
        Coin *coin =[coins objectAtIndex:i];
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
        Brick *brick =[bricks objectAtIndex:i];
        CGRect b = [brick frame];
        if (CGRectIntersectsRect(b, fakeFrame) && ![brick touched] && _counter < 0)
        {
            if([turtle lives] <= 1){
                [delegate gameOver];
                [sender invalidate];
            }
            else{
                [turtle setLives:[turtle lives]-1];
                [_livesLabel setText:[NSString stringWithFormat:@"Lives: %d",[turtle lives]]];
                _counter = 60;
            }
        }
    }
    
    if (CGRectIntersectsRect([pizza frame], f) && ![pizza collected])
    {
        [pizza setCollected:true];
        [pizza removeFromSuperview];
        [turtle setLives:[turtle lives]+1];
        [_livesLabel setText:[NSString stringWithFormat:@"Lives: %d",[turtle lives]]];
    }


    [turtle setCenter:p];
    [self updateScore];
    _counter--;
}

@end
