//
//  GameScene.h
//  stesty2
//
//  Created by John Fred Davis on 11/25/17.
//  Copyright © 2017 Netskink Computing. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@interface GameScene : SKScene

@property (nonatomic) NSMutableArray<GKEntity *> *entities;
@property (nonatomic) NSMutableDictionary<NSString*, GKGraph *> *graphs;

@end
