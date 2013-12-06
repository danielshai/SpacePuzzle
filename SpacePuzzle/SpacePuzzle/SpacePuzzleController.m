//
//  GViewViewController.m
//  SpacePuzzle

#import "SpacePuzzleController.h"
#import "BoardController.h"
#import "Element.h"
#import "Converter.h"
#import "Box.h"
#import "Star.h"
#import "Player.h"
#import "StarButton.h"
#import "BridgeButton.h"
#import "PlatformLever.h"
#import "Bridge.h"
#import "Path.h"
#import "Position.h"
#import "LoadSaveFile.h"

@implementation SpacePuzzleController
@synthesize board = _board;
@synthesize scene = _scene;
@synthesize currentUnit = _currentUnit;
@synthesize nextUnit = _nextUnit;
@synthesize bigL = _bigL;
@synthesize littleJohn = _littleJohn;
@synthesize player = _player;
@synthesize world = _world;
@synthesize level = _level;
@synthesize boardController = _boardController;

-(void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView *skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    _scene = [MainScene sceneWithSize:skView.bounds.size];
    _scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [LoadSaveFile saveFileWithWorld:0 andLevel:1];
    _boardController = [[BoardController alloc] init];
    
    [self setupNextLevel];
    
    // Present the scene.
    [skView presentScene:_scene];
    
    // Gesture recognizers.
    UITapGestureRecognizer *singleTapR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapR.numberOfTapsRequired = 1;
    [_scene.view addGestureRecognizer:singleTapR];
    
    UITapGestureRecognizer *doubleTapR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(doubleTap:)];
    doubleTapR.numberOfTapsRequired = 2;
    [_scene.view addGestureRecognizer:doubleTapR];
    
    UITapGestureRecognizer *trippleTapR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(trippleTap:)];
    trippleTapR.numberOfTapsRequired = 3;
    [_scene.view addGestureRecognizer:trippleTapR];

    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [_scene.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [_scene.view addGestureRecognizer:swipeDown];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [_scene.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [_scene.view addGestureRecognizer:swipeRight];
}

/*
 *  Called when the user taps once. */
-(void)singleTap:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && ![[_scene currentUnit] hasActions]) {
        CGPoint location = [sender locationInView:_scene.view];
        
        // Convert to board coordinates.
        location = [Converter convertMousePosToCoord:location];

        [self unitWantsToMoveTo:location WithSwipe:NO];
    }
}

/* 
 *  Called when the user double taps the view. */
-(void)doubleTap:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && ![[_scene currentUnit] hasActions]) {
        CGPoint location = [sender locationInView:_scene.view];
        
        location = [Converter convertMousePosToCoord:location];
    
        [self unitWantsToDoActionAt:location];
    }
}

-(void)trippleTap:(UIGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateEnded && ![[_scene currentUnit] hasActions]) {
        //[self changeUnit];
    }
}

-(void)swipeUp:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && ![[_scene currentUnit] hasActions]) {
        CGPoint location = CGPointMake(_currentUnit.x, _currentUnit.y);
        location.y -= 1;
        [self unitWantsToMoveTo:location WithSwipe:YES];
    }
}

-(void)swipeDown:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && ![[_scene currentUnit] hasActions]) {
        CGPoint location = CGPointMake(_currentUnit.x, _currentUnit.y);
        location.y += 1;
        [self unitWantsToMoveTo:location WithSwipe:YES];
    }
}

-(void)swipeLeft:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && ![[_scene currentUnit] hasActions]) {
        CGPoint location = CGPointMake(_currentUnit.x, _currentUnit.y);
        location.x -= 1;
        [self unitWantsToMoveTo:location WithSwipe:YES];
    }
}

-(void)swipeRight:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && ![[_scene currentUnit] hasActions]) {
        CGPoint location = CGPointMake(_currentUnit.x, _currentUnit.y);
        location.x += 1;
        [self unitWantsToMoveTo:location WithSwipe:YES];
    }
}

-(void)changeUnit {
    if (_currentUnit == _bigL) {
        if([_littleJohn isPlayingOnLevel]) {
            _currentUnit = _littleJohn;
            _nextUnit = _bigL;
            [_scene changeUnit];
            NSLog(@"Change unit");
        }
        NSLog(@"cant change, only L");
    } else if(_currentUnit == _littleJohn) {
        if([_bigL isPlayingOnLevel]) {
            _currentUnit = _bigL;
            _nextUnit = _littleJohn;
            [_scene changeUnit];
        }
    }
}

/*
 *  Loads the board according to the level. ADD LEVELFACTORY!!!. */
-(void)setupBoard {
    // Load the board.
    [self getNextLevel];
    NSString *currentLevel = @"Level";
    currentLevel = [currentLevel stringByAppendingString:[NSString stringWithFormat:@"%d", _world]];
    if(_level < 10) {
        currentLevel = [currentLevel stringByAppendingString:[NSString stringWithFormat:@"%d%d", 0, _level]];
    } else {
        currentLevel = [currentLevel stringByAppendingString:[NSString stringWithFormat:@"%d", _level]];
    }

    NSString *path = [[NSBundle mainBundle] pathForResource:currentLevel ofType:@"splvl"];
    NSLog(@"p %@", currentLevel);
    [_board loadBoard:path];
    
    for(int i = 0; i < BOARD_SIZE_Y; i++) {
        for(int j = 0; j < BOARD_SIZE_X; j++) {
            BoardCoord *bc = [_board.board objectAtIndex:BOARD_SIZE_X*i + j];
            [_scene setupBoardX:[bc x] Y:[bc y] Status:[bc status]];
        }
    }
    CGPoint p = CGPointMake(_board.finishPos.x, _board.finishPos.y);
    p = [Converter convertCoordToPixel:p];
    p.x += TILESIZE/2;
    p.y -= 2;
    [_scene finish].position = p;
}

-(void)setupElements {
    // Talk to the scene what to show.
    NSEnumerator *enumerator = [[_board elementDictionary] objectEnumerator];
    Element *obj;
    
    while(obj = [enumerator nextObject]) {
        CGPoint p = CGPointMake([obj x], [obj y]);
       // if([obj isKindOfClass:[Bridge class]]) {
        //    [_scene setupElement:p Name:@"BridgeOFF.png" Hidden:[obj hidden]];
        //} else if( ![obj isKindOfClass:[StarButton class]] && ![obj isKindOfClass:[BridgeButton class]] ) {
            [_scene setupElement:p Name:NSStringFromClass([obj class]) Hidden:[obj hidden]];
        //} else {
        //    [_scene setupElement:p Name:@"ButtonOFF" Hidden:[obj hidden]];
        //}
    }
}

/*
 *  Called when a unit wants to move to a location on the board. This method checks if the move is 
 *  possible, if so moves the unit. If unit moves to star, consume the star. */
-(void)unitWantsToMoveTo:(CGPoint)loc WithSwipe:(BOOL)swipe {
    // The position that the unit wants to move to.
    NSInteger x  = loc.x;
    NSInteger y = loc.y;

    // NSInteger nextPosIntKey = [nextPosKey integerValue];
    // The unit who wants to move's position.
    NSInteger unitX = _currentUnit.x;
    NSInteger unitY = _currentUnit.y;
    CGPoint from = CGPointMake(unitX, unitY);
    NSNumber *unitKey = [NSNumber numberWithInt:unitY*BOARD_SIZE_X + unitX];
    NSInteger unitIntKey = [unitKey integerValue];
    Element *eFrom = [[_board elementDictionary] objectForKey:unitKey];
    
    CGPoint to = CGPointMake(x, y);
    NSNumber *nextPosKey = [NSNumber numberWithInt:y*BOARD_SIZE_X + x];

    NSInteger dir = [Converter convertCoordsTo:to Direction:from];
    // First check if the movement is possible on the board and the move isn't to the same point or
    // diagonally.

    // Move unit in data model and view.
    CGPoint nextUnitPos = CGPointMake(_nextUnit.x, _nextUnit.y);
    if([_boardController unitWantsToMoveFrom:from To:to WithSwipe:swipe UnitWasAstronatut:_currentUnit == _bigL OtherUnitPosition:nextUnitPos]) {
        _currentUnit.x = x;
        _currentUnit.y = y;
        [_scene updateUnit:to inDirection:dir];
    }
     

        // UPDATE ELEMENTS AT from AND to
        /* ---------------------------------------------------------------------------------------------
         
        New structure of controller, model, and elements:
        -------------------------------------------------
          Board has functions that checks what elements are on a position, and updates them accordingly.
          The elements container will be either a) having an array in each BoardCoord that holds the
          elements on that position, or b) 2 (or 3) separate dictionaries. These separate dictionaries 
          would represent the different layers of elements on the board.
         
          Pros and Cons: (a) WAS THE CHOICE)
          ----------------------------------
            - a) is more dynamic in adding several elements on one point. Could theoretically have as
              many elements on a point as you want. Time complexity increases (O(n)) as well as space 
              usage. This should be a minor increase, though (I think), since the array is so small with
              a practical maximum of around 5, give or take.
            - b) is more static. For every new layer of element you want in the game, code has to be 
              updated. Time complexity (O(1)) is less as well as space usage.
         
          Counting stars with method a) (DONE)
          ------------------------------------
          At init, loop through all BoardCoords and count how many stars. Since this is O(n*n), this should
          only be done at init, and not every time a star is taken. Save amount of stars in a property.
          Every time (in Board unitMovedToPoint) a star is taken, subtract 1 from this propery.
         
          Interaction between SpacePuzzleController, MainScene, and data model
          --------------------------------------------------------------------
          For example, controller would call _boardController unitMovedFromPoint:fromPoint (after checking 
          if a move can be done, like the code above). In unitMovedFromPoint, board would check what 
          elements are on that point and update them accordingly. Then controller would call
          _scene updateElementsAtPosition:fromPoint withArrayOfElements:elements. 
          _scene updateElementsAtPosition will first remove the sprites at that position, and then add new
          ones according to the array argument (could be empty, which means no sprites there).
         
          Then, the same procedure is repeated for toPoint. For example, after moving this controller can 
          ask the board how many star elements are left, and update the player model accordingly.
         
          To wrap the Board's methods of moving etc, create BoardController class which does all changes
          in board (that are at present done in this controller). Pseudo code (in SpaceController):
          if boardController isPointMovableTo
            currentUnitPos = toPos;
            boardController unitMovedFrom:from To:to
            scene updateTileAtPosition...
            scene updateElementAtPosition:from withArray:boardController elementsAtPosition:from
            scene updateElementAtPosition:to withArray:boardController elementsAtPosition:to
            scene updateUnit:to Dir:dir
            player.stars = boardController starstaken
         
         ----------------------------------------------------------------------------------------------*/
        
    // If the player moved to the finish, new level.
    if([self areUnitsOnFinish]) {
        // THIS CODE NEEDS TO ACCOUNT FOR WORLDS.
        _level++;
        [LoadSaveFile saveFileWithWorld:_world andLevel:_level];
        [self setupNextLevel];
        return;
    }
        
    // [self unitWantsToDoActionAt:to];
}

/*
 *  Called when a unit (i.e. the user) wants to do an action. First checks if the action is possible,
 *  then chooses an action based on what element the action is performed on. */
-(void)unitWantsToDoActionAt:(CGPoint)loc {
    NSInteger x = loc.x;
    NSInteger y = loc.y;

    NSNumber *actionPointKey = [NSNumber numberWithInt:y*BOARD_SIZE_X + x];
    NSInteger unitX = _currentUnit.x;
    NSInteger unitY = _currentUnit.y;
    
    CGPoint unitPoint = CGPointMake(unitX, unitY);
    CGPoint actionPoint = CGPointMake(x, y);
 
    Element *e = [[_board elementDictionary] objectForKey:actionPointKey];
    // If the element exists.
    if(e) {
        // Do action depending on element type and current unit.
        /*if ([e isKindOfClass:[Box class]] && _currentUnit == _bigL && [Converter isPoint:actionPoint NextToPoint:unitPoint]) {
            NSInteger dir = [Converter convertCoordsTo:actionPoint Direction:unitPoint];
            [self doActionOnBox:e InDirection:dir];
        } else*/
        
        if ([e isKindOfClass:[Box class]] && _currentUnit == _bigL && [Converter isPoint:unitPoint NextToPoint:actionPoint]){
            [self doActionOnBoxSmash:e];
        } else if ([e isKindOfClass:[StarButton class]] && [Converter isPoint:unitPoint sameAsPoint:actionPoint]) {
            //[self doActionOnStarButton:e];
        } else if ([e isKindOfClass:[BridgeButton class]] && [Converter isPoint:unitPoint sameAsPoint:actionPoint]) {
            [self doActionOnBridgeButton:e];
        } else if ([e isKindOfClass:[PlatformLever class]] && [Converter isPoint:unitPoint sameAsPoint:actionPoint]) {
            [self doActionOnPlatformLever:e];
        }
    }
}

-(void)doActionOnBoxSmash:(Element*)box {
    NSNumber *elementKey = [NSNumber numberWithInteger:box.y*BOARD_SIZE_X + box.x];
    [[_board elementDictionary] removeObjectForKey:elementKey];
    [_scene removeElementAtPosition:elementKey];
}

/*
 *  Does an action on a box based on the direction. The action moves the box to a tile. */
-(void)doActionOnBox:(Element *)rock InDirection:(NSInteger)dir{
    NSNumber *nextKey;
    CGPoint nextPos;
    Element *e;
    NSNumber *elementKey = [NSNumber numberWithInteger:rock.y*BOARD_SIZE_X + rock.x];

    if (dir == RIGHT) {
        // Check if at the edge of the board, if so do nothing.
        if(rock.x >= BOARD_SIZE_X-1) {
            return;
        }
        nextKey = [NSNumber numberWithInt:rock.y*BOARD_SIZE_X + rock.x + 1];
        e = [[_board elementDictionary] objectForKey:nextKey];
        nextPos = CGPointMake(rock.x + 1, rock.y);
    } else if (dir == LEFT) {
        if(rock.x <= 0) {
            return;
        }
        nextKey = [NSNumber numberWithInt:rock.y*BOARD_SIZE_X + rock.x - 1];
        e = [[_board elementDictionary] objectForKey:nextKey];
        nextPos = CGPointMake(rock.x - 1, rock.y);
    } else if (dir == UP) {
        if(rock.y <= 0) {
            return;
        }
        nextKey = [NSNumber numberWithInt:(rock.y - 1)*BOARD_SIZE_X + rock.x];
        e = [[_board elementDictionary] objectForKey:nextKey];
        nextPos = CGPointMake(rock.x, rock.y - 1);
    } else if (dir == DOWN){
        if(rock.y >= BOARD_SIZE_Y-1) {
            return;
        }
        nextKey = [NSNumber numberWithInt:(rock.y + 1)*BOARD_SIZE_X + rock.x];
        e = [[_board elementDictionary] objectForKey:nextKey];
        nextPos = CGPointMake(rock.x, rock.y + 1);
    }
    // Add more elements which cannot be pushed upon to if-statement.
    // ![e isKindOfClass:[Box class]] ---> !e isBlocking
    CGPoint nextUnitPos = CGPointMake(_nextUnit.x, _nextUnit.y);
    CGPoint finishPos = CGPointMake([_board finishPos].x, [_board finishPos].y);
    
    if (![e isKindOfClass:[Box class]] && ![Converter isPoint:nextPos sameAsPoint:nextUnitPos] &&
        ![Converter isPoint:finishPos sameAsPoint:nextPos]) {
        NSInteger intKey = [nextKey integerValue];
        NSInteger nextTile = [[[_board board] objectAtIndex:intKey] status];

        CGPoint posPreMove = CGPointMake(rock.x, rock.y);
        [rock doMoveAction:dir];

        if(nextTile != MAPSTATUS_SOLID) {
            [[_board elementDictionary] removeObjectForKey:elementKey];
            [_scene removeElementAtPosition:elementKey];
            if(nextTile == MAPSTATUS_CRACKED) {
                [[_board elementDictionary] removeObjectForKey:nextKey];
                [_scene removeElementAtPosition:nextKey];
                [[[_board board] objectAtIndex:intKey] setStatus:MAPSTATUS_VOID];
                [_scene refreshTileAtFlatIndex:intKey WithStatus:MAPSTATUS_VOID];
            }
        } else {
            NSNumber *index = [NSNumber numberWithInteger:nextPos.y * BOARD_SIZE_X + nextPos.x];
            // CHANGE THIS WHEN TWO OR MORE OBJECTS CAN BE PLACED ON THE SAME TILE!
            [[_board elementDictionary] removeObjectForKey:index];
            [_board moveElementFrom:posPreMove To:nextPos];
            [_scene removeElementAtPosition:index];
            [_scene moveElement:posPreMove NewCoord:nextPos];
        }
        //nextTile should invoke its "doAction"...
    }
}

/*
 *  Does action on a star button, i.e. turns it on/off. */
-(void)doActionOnStarButton:(Element *)button {
    StarButton *sb = (StarButton*)button;
    [sb movedTo];
    
    // Updates the button on the scene.
    [_scene refreshElementAtPosition:sb.key OfClass:CLASS_STARBUTTON WithStatus:sb.state];
    // Updates the star connected to the button on the scene, i.e. showing it.
    if(!sb.star.taken) {
        [_scene setElementAtPosition:sb.star.key IsHidden:sb.star.hidden];
        
        CGPoint starPos = CGPointMake(sb.star.x, sb.star.y);
        CGPoint nextUnitPos = CGPointMake(_nextUnit.x, _nextUnit.y);
        // If the other unit is standing on the same spot as the star and button is on the star should be
        // taken by the player.
        if([Converter isPoint:starPos sameAsPoint:nextUnitPos] && sb.state) {
            [self takeStar:sb.star];
        }
    }
}

-(void)doActionOnBridgeButton: (Element*)button {
    BridgeButton *bb = (BridgeButton*)button;
    [bb movedTo];
    
    // Updates the button on the scene.
    [_scene refreshElementAtPosition:bb.bridge.key OfClass:CLASS_BRIDGE WithStatus:bb.state];
    [_scene refreshElementAtPosition:bb.key OfClass:CLASS_BRIDGEBUTTON WithStatus:bb.state];
    // Updates the bridge connected to the button on the scene, i.e. showing it.
    [_scene setElementAtPosition:bb.bridge.key IsHidden:NO];
}

// Moving platform should have TIMER in it.
-(void)doActionOnPlatformLever:(Element *)lever {
    PlatformLever *pl = (PlatformLever*)lever;
    [pl doAction];
    // Updates the lever on the scene.
    [_scene refreshElementAtPosition:pl.key OfClass:CLASS_LEVER WithStatus:pl.state];
    // Updates the moving platform connected to the lever on the scene, i.e. moving it.
    [_scene setElementAtPosition:pl.movingPlatform.key IsHidden:NO];
    [_scene refreshElementAtPosition:pl.movingPlatform.key OfClass:CLASS_MOVING_PLATFORM WithStatus:pl.movingPlatform.blocking];
    
    [NSTimer scheduledTimerWithTimeInterval:0.6 target:self
                                   selector:@selector(movePlatform:)  userInfo:pl.movingPlatform
                                    repeats:YES];
}

-(void)movePlatform:(NSTimer *)timer {
    MovingPlatform *mp = [timer userInfo];
    [[_board elementDictionary] removeObjectForKey:mp.key];
    
    CGPoint prevPoint = CGPointMake(mp.x, mp.y);
    if(mp) {
        CGPoint p = mp.path.nextPoint;
        mp.x = p.x;
        mp.y = p.y;
        
        NSInteger dir = [Converter convertCoordsTo:prevPoint Direction:p];
        
        if(_littleJohn.x == prevPoint.x && _littleJohn.y == prevPoint.y) {
            _littleJohn.x = mp.x;
            _littleJohn.y = mp.y;
            [_scene updateUnit:CGPointMake(_littleJohn.x, _littleJohn.y) inDirection:dir];
        }
        
        if(_bigL.x == prevPoint.x && _bigL.y == prevPoint.y) {
            _bigL.x = mp.x;
            _bigL.y = mp.y;
            [_scene updateUnit:CGPointMake(_bigL.x, _bigL.y) inDirection:dir];
        }
    }
    [[_board elementDictionary] setObject:mp forKey:mp.key];
    NSLog(@"%f %f --- %ld %ld",prevPoint.x,prevPoint.y,(long)mp.x,(long)mp.y);
    
    // Check if unit is on platform, if so move it.
    NSLog(@"%ld %ld", (long)_bigL.x, (long)_bigL.y);
    
    [_scene moveElement:prevPoint NewCoord:CGPointMake(mp.x, mp.y)];
}

-(void)takeStar:(Star *)star {
    [star movedTo];
    _player.starsTaken += 1;
    [_scene removeElementAtPosition:star.key];
}

/*
 *  Checks if the |currentUnit| is on the finish position. */
-(BOOL)areUnitsOnFinish {
    CGPoint finishPoint = CGPointMake(_board.finishPos.x, _board.finishPos.y);
    CGPoint currentUnitPoint = CGPointMake(_currentUnit.x, _currentUnit.y);
    CGPoint nextUnitPoint = CGPointMake(_nextUnit.x, _nextUnit.y);
    
    return [Converter isPoint:finishPoint sameAsPoint:currentUnitPoint]
        && [Converter isPoint:finishPoint sameAsPoint:nextUnitPoint];
}

-(NSArray*) getDataFromNotification:(NSNotification *)notif Key:(NSString *)key {
    NSDictionary *userInfo = notif.userInfo;
    NSSet *objectSent = [userInfo objectForKey:key];
    return [objectSent allObjects];
}

-(void)getNextLevel {
    if([LoadSaveFile loadFile]) {
        NSString *currentState = [LoadSaveFile loadFile];
        _world = [[currentState substringWithRange:NSMakeRange(5, 1)] integerValue];
        if([[currentState substringWithRange:NSMakeRange(6, 1)] integerValue] != 0){
            _level = [[currentState substringWithRange:NSMakeRange(6, 2)] integerValue];
        } else {
            _level = [[currentState substringWithRange:NSMakeRange(7, 1)] integerValue];
        }
        _player = [[Player alloc] initWithWorld:_world andLevel:_level];
    } else {
        _player = [[Player alloc] initWithWorld:0 andLevel:1];
    }
}

/*
 *  Creates the units. */
-(void)setupUnits {
    _bigL = [[BigL alloc] init];
    _bigL.x = _boardController.board.startPosAstronaut.x;
    _bigL.y = _boardController.board.startPosAstronaut.y;
 
    // If the unit has a valid starting position, it is playing.
    if(_bigL.x >= 0 && _bigL.y >= 0) {
        _bigL.isPlayingOnLevel = YES;
    } else {
        _bigL.isPlayingOnLevel = NO;
    }
    
    _littleJohn = [[LittleJohn alloc] init];
    _littleJohn.x = _boardController.board.startPosAlien.x;
    _littleJohn.y = _boardController.board.startPosAlien.y;
    
    if(_littleJohn.x >= 0 && _littleJohn.y >= 0) {
        _littleJohn.isPlayingOnLevel = YES;
    } else {
        _littleJohn.isPlayingOnLevel = NO;
    }
    
    if(_bigL.isPlayingOnLevel && !_littleJohn.isPlayingOnLevel) {
        NSLog(@"Only L");
        _currentUnit = _bigL;
        _nextUnit = _bigL;
    } else if(!_bigL.isPlayingOnLevel && _littleJohn.isPlayingOnLevel) {
        NSLog(@"Only John");
        _currentUnit = _littleJohn;
        _nextUnit = _littleJohn;
    } else if([_bigL isPlayingOnLevel] && [_littleJohn isPlayingOnLevel]) {
        // If both are playing, set astronaut as starting unit as default.
        _currentUnit = _bigL;
        _nextUnit = _littleJohn;
    }
}

-(NSInteger)currentUnitToMacro {
    if(_currentUnit == _bigL) {
        return BIG_L;
    } else if(_currentUnit == _littleJohn) {
        return LITTLE_JOHN;
    }
    return -1;
}

-(void)setupNextLevel {
    [self getNextLevel];
    [_boardController setupBoardWithWorld:_world AndLevel:_level];
    [self setupElements];
    [self setupUnits];
    [self setupScene];
}

-(void)setupScene {
    [_scene cleanScene];
    // Board in scene.
    for(int i = 0; i < BOARD_SIZE_Y; i++) {
        for(int j = 0; j < BOARD_SIZE_X; j++) {
            CGPoint p = CGPointMake(j, i);
            [_scene setupBoardX:j Y:i Status:[_boardController getBoardStatusAtPosition:p]];
        }
    }
    CGPoint p = CGPointMake(_boardController.board.finishPos.x, _boardController.board.finishPos.y);
    p = [Converter convertCoordToPixel:p];
    p.x += TILESIZE/2;
    p.y -= 2;
    [_scene finish].position = p;
    
    // Elements in scene.
    
    // Units in scene.
    CGPoint pA = CGPointMake(_bigL.x, _bigL.y);
    [_scene setupAstronaut:pA];
    CGPoint pAl = CGPointMake(_littleJohn.x, _littleJohn.y);
    [_scene setupAlien:pAl];
    [_scene setCurrentUnitWithMacro:[self currentUnitToMacro]];
}

/*
 *  Adds a notification to listen to from this class. */
-(void)observeText:(NSString *)text Selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:text object:nil];
}

-(BOOL)shouldAutorotate {
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(BOOL)prefersStatusBarHidden {
    return true;
}

-(IBAction)changeUnitAction:(id)sender {
    [self changeUnit];
}

- (IBAction)restartAction:(id)sender {
    [self setupNextLevel];
}
@end
