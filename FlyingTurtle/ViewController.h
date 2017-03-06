//
//  ViewController.h
//  FlyingTurtle
//
//  Created by berk on 2/25/17.
//  Copyright © 2017 berk. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "GameView.h"
@interface ViewController : UIViewController<GameOverDelegate>

@property (strong, nonatomic) IBOutlet GameView *gameView;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;

@end

