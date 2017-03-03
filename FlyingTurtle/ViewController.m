//
//  ViewController.m
//  FlyingTurtle
//
//  Created by berk on 2/25/17.
//  Copyright © 2017 berk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _gameView.currentScore = 0;
    _gameView.highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"turtleHighScore"];
    _gameView.delegate = self;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:_gameView selector:@selector(play:)];
    [_displayLink setPreferredFramesPerSecond:60];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapped:(id)sender {
    _gameView.turtle.jump = [_gameView bounds].size.height/10;
}

- (IBAction)backed:(id)sender {
    [self.displayLink invalidate];
}

-(void)gameOver
{
    NSLog(@"Game over");
}

@end
