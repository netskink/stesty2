//
//  GameScene.m
//  stesty2
//
//  Created by John Fred Davis on 11/25/17.
//  Copyright © 2017 Netskink Computing. All rights reserved.
//

#import "GameScene.h"
//#import "UIGestureRecognizerSubclass.h"


@interface GameScene() <UIGestureRecognizerDelegate> {
    UISwipeGestureRecognizer *swipeGestureLeft;
    UISwipeGestureRecognizer *swipeGestureRight;
    UITapGestureRecognizer *doubleTapGesture;
}
@end

@implementation GameScene {
    NSTimeInterval _lastUpdateTime;
    SKShapeNode *_spinnyNode;
    SKSpriteNode *_p_sprite1;
    SKSpriteNode *_p_sprite1a;
    SKSpriteNode *_p_sprite2;
    SKSpriteNode *_p_sprite3;
    CGPoint _start_position;
//    int _turrentAngle;
//    int _hullAngle;
    bool _rotate_tank;
}



-(void)swipeLeft:(UISwipeGestureRecognizer*) recognizer{
    
    [_p_sprite3 runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
    NSLog(@"Left");
    
}

-(void)swipeRight:(UISwipeGestureRecognizer*) recognizer{
    
    [_p_sprite2 runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
    NSLog(@"Right");
    
}



-(void)tapTap:(UITapGestureRecognizer*) recognizer{
    
    [_p_sprite2 runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
    [_p_sprite3 runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];

    _p_sprite1.zRotation += 0.1;

    _rotate_tank = !_rotate_tank;
    
    if (_rotate_tank) {
        _p_sprite2.color = [SKColor greenColor];
        _p_sprite3.color = [SKColor greenColor];

    } else {
        _p_sprite2.color = [SKColor blueColor];
        _p_sprite3.color = [SKColor blueColor];

    }
    
    NSLog(@"Tap tap");
    
}


-(void) didMoveToView:(SKView *)view {

    //You should use UISwipeGestureRecognizer instead of UIGestureRecognizer here.
    
    swipeGestureLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
    [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [view addGestureRecognizer:swipeGestureLeft];
    
    
    //Note that swipeRight has a parameter, so you  have to change swipeRight to swipeRight: to silent the compiler warning.
    swipeGestureRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [view addGestureRecognizer:swipeGestureRight];
    
    
    //double tap detection
    doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [view addGestureRecognizer:doubleTapGesture];
    
    
    
}






- (void) willMoveFromView: (SKView *) view {
    
    
    [view removeGestureRecognizer: swipeGestureLeft ];
    
    [view removeGestureRecognizer: swipeGestureRight];
    
    [view removeGestureRecognizer: doubleTapGesture];
}





- (void)sceneDidLoad {
    // Setup your scene here
    
    
    // Initialize update time
    _lastUpdateTime = 0;
    
    // Get label node from scene and store it for use later
    _p_sprite1 = (SKSpriteNode *)[self childNodeWithName:@"//sprite1"];
    _p_sprite1a = (SKSpriteNode *)[self childNodeWithName:@"//sprite1a"];
    _p_sprite2 = (SKSpriteNode *)[self childNodeWithName:@"//sprite2"];
    _p_sprite3 = (SKSpriteNode *)[self childNodeWithName:@"//sprite3"];

    // hide intially then reveal in sequence
    _p_sprite1.alpha = 0.0;
    _p_sprite2.alpha = 0.0;
    
    _p_sprite1.zRotation = -M_PI_2;
    
    [_p_sprite1 runAction:[SKAction fadeInWithDuration:1.0]];
    [_p_sprite2 runAction:[SKAction fadeInWithDuration:1.0]];

    CGFloat w = (self.size.width + self.size.height) * 0.05;
    
    // Create shape node to use during mouse interaction
    _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];
    _spinnyNode.lineWidth = 2.5;
    
    [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
    [_spinnyNode runAction:[SKAction sequence:@[
                                                [SKAction waitForDuration:0.5],
                                                [SKAction fadeOutWithDuration:0.5],
                                                [SKAction removeFromParent],
                                                ]]];
    
    _rotate_tank = true;
}


// Called by call back touchesBegin
- (void)touchDownAtPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor greenColor];
    [self addChild:n];
    
    
    // save this intial position
    _start_position = pos;
}

- (void)touchMovedToPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor blueColor];
    [self addChild:n];
    
    // Draw line to moved point
}

- (void)touchUpAtPoint:(CGPoint)pos {
    SKShapeNode *n = [_spinnyNode copy];
    n.position = pos;
    n.strokeColor = [SKColor redColor];
    [self addChild:n];
    
    
    if (_rotate_tank) {
        // if dx positive move right
        int delta_x = _start_position.x - pos.x;
        if (delta_x > 100) {
            [_p_sprite1 runAction:[SKAction actionNamed:@"moveLeft"] withKey:@"moveLeft"];
        } else if (delta_x < -100) {
            [_p_sprite1 runAction:[SKAction actionNamed:@"moveRight"] withKey:@"moveRight"];
        }
        
        // if dy positive move up
        int delta_y = _start_position.y - pos.y;
        if (delta_y > 100) {
            [_p_sprite1 runAction:[SKAction actionNamed:@"moveDown"] withKey:@"moveDown"];
        } else if (delta_y < -100) {
            [_p_sprite1 runAction:[SKAction actionNamed:@"moveUp"] withKey:@"moveUp"];
        }
    } else {
        // if dx positive move right
        int delta_x = _start_position.x - pos.x;
        if (delta_x > 100) {
            [_p_sprite1a runAction:[SKAction actionNamed:@"rotateRight"] withKey:@"rotateRight"];
        } else if (delta_x < -100) {
            [_p_sprite1a runAction:[SKAction actionNamed:@"rotateLeft"] withKey:@"rotateLeft"];
        }
        
//        // if dy positive move up
//        int delta_y = _start_position.y - pos.y;
//        if (delta_y > 100) {
//            [_p_sprite1a runAction:[SKAction actionNamed:@"rotateDown"] withKey:@"rotateDown"];
//        } else if (delta_y < -100) {
//            [_p_sprite1a runAction:[SKAction actionNamed:@"rotateUp"] withKey:@"rotateUp"];
//        }

    }
    
    
    
}





- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Run 'Pulse' action from 'Actions.sks'
//    [_p_sprite2 runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];

    // Call lower
    for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    
    // Initialize _lastUpdateTime if it has not already been
    if (_lastUpdateTime == 0) {
        _lastUpdateTime = currentTime;
    }

    // Calculate time since last update
    CGFloat dt = currentTime - _lastUpdateTime;

    // Update entities
    for (GKEntity *entity in self.entities) {
        [entity updateWithDeltaTime:dt];
    }

    _lastUpdateTime = currentTime;
}

@end
