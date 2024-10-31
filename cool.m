brick = ConnectBrick('GROUP8');

ultra = 1;
leftMot = 'D';
rightMot = 'A';
colSen = 3;
gyro = 4;
moveSpeed = 62.5;
moveTime = 1.4;
turnSpeed = 79;
turnTime = 0.43;

brick.SetColorMode(colSen, 4);

driving = true;
while driving
    pause(0.5);
    %determine the direction to go right -> forward -> left -> back
    %rotate right
            brick.MoveMotor(leftMot, turnSpeed);
            brick.MoveMotor(rightMot, -turnSpeed);
            pause(turnTime);
            brick.MoveMotor(leftMot+rightMot, 0);
            pause(0.5)
    dist = brick.UltrasonicDist(ultra);
    if dist < 40 %if right is impossible, look forward
        %rotate left
            brick.MoveMotor(leftMot, -turnSpeed+3);
            brick.MoveMotor(rightMot, turnSpeed-3);
            pause(turnTime);
            brick.MoveMotor(leftMot+rightMot, 0);
        pause(0.5);
        dist = brick.UltrasonicDist(ultra);
        if dist < 40 %if forward is impossible, look left
            %rotate left
                brick.MoveMotor(leftMot, -turnSpeed+6);
                brick.MoveMotor(rightMot, turnSpeed-6);
                pause(turnTime);
                brick.MoveMotor(leftMot+rightMot, 0);
            pause(0.5);
            dist = brick.UltrasonicDist(ultra);
            if dist < 40 %if left is impossible, turn back
                 %rotate left
                    brick.MoveMotor(leftMot, -turnSpeed);
                    brick.MoveMotor(rightMot, turnSpeed);
                    pause(turnTime);
                    brick.MoveMotor(leftMot+rightMot, 0);
            end
        end
    end
    
    %move to next square (checking for red in between)
        brick.MoveMotor(leftMot+rightMot, moveSpeed);
        pause(moveTime);
        brick.MoveMotor(leftMot+rightMot, 0);
        pause(0.25);
        if rgb(1)>rgb(2)+rgb(3) %if red's seen, wait before moving forward
        pause(5);
        end
        brick.MoveMotor(leftMot+rightMot, moveSpeed);
        pause(moveTime);
        brick.MoveMotor(leftMot+rightMot, 0);
    
    rgb = brick.ColorRGB(colSen);
    if(rgb(2) > rgb(1) + rgb(3) + 100) %if it's in the endzone (currently green), stop
        driving = false;
    end
    if(rgb(1) + rgb(2) - rgb(3) > 350) %if it's in pickup area (currently yellow), pickup
        pickup=true;
        while pickup
            disp("pickup sequence");
            pickup=false;
        end
    end
end

dropoff=true;
while dropoff
    disp("dropoff sequence");
    dropoff=false;
end

brick.MoveMotor(leftMot+rightMot, 0);
DisconnectBrick(brick);
clear brick;