brick = ConnectBrick('GROUP8');

ultra = 1;
leftMot = 'D';
rightMot = 'A';
grabMot = 'C';
colSen = 3;
gyro = 4;
moveSpeed = 60;
moveTime = 1.4;
turnSpeed = 60;
turnTime = 0.4;
grabSpeed = 15;
correcter = 1.048;
correcter2 = 0.935;


brick.SetColorMode(colSen, 2);
InitKeyboard();

driving = true;
while driving
    pause(0.5);
    %determine the direction to go left -> forward -> right -> back
    %rotate right
            brick.MoveMotor(leftMot, -turnSpeed*correcter);
            brick.MoveMotor(rightMot, turnSpeed);
            pause(turnTime);
            brick.MoveMotor(leftMot+rightMot, 0);
            pause(0.5)
    dist = brick.UltrasonicDist(ultra);
    if dist < 40 %if left is impossible, look forward
        %rotate right
            brick.MoveMotor(leftMot, turnSpeed*correcter*correcter2);
            brick.MoveMotor(rightMot, -turnSpeed*correcter2);
            pause(turnTime);
            brick.MoveMotor(leftMot+rightMot, 0);
        pause(0.5);
        dist = brick.UltrasonicDist(ultra);
        if dist < 40 %if forward is impossible, look right
            %rotate right
                brick.MoveMotor(leftMot, turnSpeed*correcter*correcter2);
                brick.MoveMotor(rightMot, -turnSpeed*correcter2);
                pause(turnTime);
                brick.MoveMotor(leftMot+rightMot, 0);
            pause(0.5);
            dist = brick.UltrasonicDist(ultra);
            if dist < 40 %if right is impossible, turn back
                 %rotate right
                    brick.MoveMotor(leftMot, turnSpeed*correcter*correcter2);
                    brick.MoveMotor(rightMot, -turnSpeed*correcter2);
                    pause(turnTime);
                    brick.MoveMotor(leftMot+rightMot, 0);
                    pause(0.5);
            end
        end
    end
    
    %move to next square (checking for red in between)
        brick.MoveMotor(rightMot, moveSpeed);
        brick.MoveMotor(leftMot, moveSpeed*correcter);
        pause(moveTime);
        brick.MoveMotor(leftMot+rightMot, 0);
        pause(0.25);
        rgb = brick.ColorCode(colSen);
        if rgb == 5 %if red's seen, wait before moving forward
        pause(1.75);
        end
        brick.MoveMotor(rightMot, moveSpeed);
        brick.MoveMotor(leftMot, moveSpeed*correcter);
        pause(moveTime);
        brick.MoveMotor(leftMot+rightMot, 0);
    
    rgb = brick.ColorCode(colSen);
    if(rgb == 4) %if it's in dropoff area (currently yellow), dropoff
        dropoff=true;
        while dropoff
            %manual controls
            pause(0.1);
            switch key
                case 'uparrow'
                    brick.MoveMotor(rightMot, 20);
                    brick.MoveMotor(leftMot, 20);
                    pause(0.1);
                case 'downarrow'
                    brick.MoveMotor(leftMot, -20);
                    brick.MoveMotor(rightMot, -20);
                    pause(0.1);
                case 'leftarrow'
                    brick.MoveMotor(leftMot, -10);
                    brick.MoveMotor(rightMot, 10);
                    pause(0.1);
                case 'rightarrow'
                    brick.MoveMotor(leftMot, 10);
                    brick.MoveMotor(rightMot, -10);
                    pause(0.1);
                case 'z' %up
                    brick.MoveMotor(grabMot, grabSpeed);
                case 'x'%down
                    brick.MoveMotor(grabMot, -grabSpeed);
                case 'space'
                    dropoff=false;
                case 0
                    brick.MoveMotor(leftMot+rightMot+grabMot, 0); 
            end
        end
    end
    if(rgb == 2) %if it's in pickup area (currently blue), pickup
        pickup=true;
        while pickup
            %manual controls
            pause(0.1);
            switch key
                case 'uparrow'
                    brick.MoveMotor(leftMot, 30);
                    brick.MoveMotor(rightMot, 30);
                    pause(0.1);
                case 'downarrow'
                    brick.MoveMotor(leftMot, -30);
                    brick.MoveMotor(rightMot, -30);
                    pause(0.1);
                case 'leftarrow'
                    brick.MoveMotor(leftMot, -10);
                    brick.MoveMotor(rightMot, 10);
                    pause(0.1);
                case 'rightarrow'
                    brick.MoveMotor(leftMot, 10);
                    brick.MoveMotor(rightMot, -10);
                    pause(0.1);
                case 'z'
                    brick.MoveMotor(grabMot, grabSpeed);
                case 'x'
                    brick.MoveMotor(grabMot, -grabSpeed);
                case 'space'
                    pickup=false;
                case 0
                    brick.MoveMotor(leftMot+rightMot+grabMot, 0); 
            end
        end
    end
    if(rgb == 3) %if it's in end area (currently green), stop
        pause(0.25);
        brick.playTone(100, 300, 250);
        pause(.25);
        brick.playTone(100, 100, 250);
        pause(.25);
        driving=false;
    end
end
brick.MoveMotor(leftMot+rightMot, 0);
DisconnectBrick(brick);
clear brick;