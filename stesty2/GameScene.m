//
//  GameScene.m
//  stesty2
//
//  Created by John Fred Davis on 11/25/17.
//  Copyright © 2017 Netskink Computing. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
    NSTimeInterval _lastUpdateTime;
    SKShapeNode *_spinnyNode;
    SKSpriteNode *_p_sprite1;
    SKSpriteNode *_p_sprite2;
    CGPoint _start_position;
}

- (void)sceneDidLoad {
    // Setup your scene here
    
    // Initialize update time
    _lastUpdateTime = 0;
    
    // Get label node from scene and store it for use later
    _p_sprite1 = (SKSpriteNode *)[self childNodeWithName:@"//sprite1"];
    _p_sprite2 = (SKSpriteNode *)[self childNodeWithName:@"//sprite2"];

    // hide intially then reveal in sequence
    _p_sprite1.alpha = 0.0;
    _p_sprite2.alpha = 0.0;
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
    
    // if dx positive move right
    if (_start_position.x > pos.x) {
        [_p_sprite1 runAction:[SKAction actionNamed:@"moveLeft"] withKey:@"moveLeft"];
    } else {
        [_p_sprite1 runAction:[SKAction actionNamed:@"moveRight"] withKey:@"moveRight"];
    }
    
    // if dy positive move up
    if (_start_position.y > pos.y) {
        [_p_sprite1 runAction:[SKAction actionNamed:@"moveDown"] withKey:@"moveDown"];
    } else {
        [_p_sprite1 runAction:[SKAction actionNamed:@"moveUp"] withKey:@"moveUp"];
        
    }

    
    
    
}





- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Run 'Pulse' action from 'Actions.sks'
    [_p_sprite2 runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];

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
