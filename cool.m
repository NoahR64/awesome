brick = ConnectBrick('GROUP8');

ultra = 1;
leftMot = 'D';
rightMot = 'A';
grabMot = 'C';
colSen = 3;
gyro = 4;
moveSpeed = 63;
moveTime = 1.45;
turnSpeed = 80;
turnTime = 0.43;
grabSpeed = 15;
correcter = 1.024;


brick.SetColorMode(colSen, 2);
InitKeyboard();

driving = true;
while driving
    pause(0.5);
    %determine the direction to go right -> forward -> left -> back
    %rotate right
            brick.MoveMotor(leftMot, turnSpeed*correcter);
            brick.MoveMotor(rightMot, -turnSpeed);
            pause(turnTime);
            brick.MoveMotor(leftMot+rightMot, 0);
            pause(0.5)
    dist = brick.UltrasonicDist(ultra);
    if dist < 40 %if right is impossible, look forward
        %rotate left
            brick.MoveMotor(leftMot, -turnSpeed*correcter);
            brick.MoveMotor(rightMot, turnSpeed);
            pause(turnTime);
            brick.MoveMotor(leftMot+rightMot, 0);
        pause(0.5);
        dist = brick.UltrasonicDist(ultra);
        if dist < 40 %if forward is impossible, look left
            %rotate left
                brick.MoveMotor(leftMot, -turnSpeed*correcter);
                brick.MoveMotor(rightMot, turnSpeed);
                pause(turnTime);
                brick.MoveMotor(leftMot+rightMot, 0);
            pause(0.5);
            dist = brick.UltrasonicDist(ultra);
            if dist < 40 %if left is impossible, turn back
                 %rotate left
                    brick.MoveMotor(leftMot, -turnSpeed*correcter);
                    brick.MoveMotor(rightMot, turnSpeed);
                    pause(turnTime);
                    brick.MoveMotor(leftMot+rightMot, 0);
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
                    brick.MoveMotor(rightMot, 50);
                    brick.MoveMotor(leftMot, 50);
                    pause(0.1);
                case 'downarrow'
                    brick.MoveMotor(leftMot, -50);
                    brick.MoveMotor(rightMot, -50);
                    pause(0.1);
                case 'leftarrow'
                    brick.MoveMotor(leftMot, -40);
                    brick.MoveMotor(rightMot, 40);
                    pause(0.1);
                case 'rightarrow'
                    brick.MoveMotor(leftMot, grabSpeed);
                    brick.MoveMotor(rightMot, -grabSpeed);
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
    if(rgb == 3) %if it's in pickup area (currently green), pickup
        pickup=true;
        while pickup
            %manual controls
            pause(0.1);
            switch key
                case 'uparrow'
                    brick.MoveMotor(leftMot, 20);
                    brick.MoveMotor(rightMot, 20);
                    pause(0.1);
                case 'downarrow'
                    brick.MoveMotor(leftMot, -20);
                    brick.MoveMotor(rightMot, -20);
                    pause(0.1);
                case 'leftarrow'
                    brick.MoveMotor(leftMot, -20);
                    brick.MoveMotor(rightMot, 20);
                    pause(0.1);
                case 'rightarrow'
                    brick.MoveMotor(leftMot, 20);
                    brick.MoveMotor(rightMot, -20);
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
    if(rgb == 2) %if it's in end area (currently blue), stop
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