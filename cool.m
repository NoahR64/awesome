brick = ConnectBrick('GROUP8');

ultra = 1;
leftMot = 'D';
rightMot = 'A';
colSen = 3;
gyro = 4;
moveSpeed = 50;
moveTime = 1.36;
turnSpeed = 75;
turnTime = 0.432;

brick.SetColorMode(colSen, 4);

driving = true;
while driving
    pause(0.5);

    %determine the direction to go
    dist = brick.UltrasonicDist(ultra);
    if dist < 30 %if forward is impossible, look right
        %rotate right
            brick.MoveMotor(leftMot, turnSpeed);
            brick.MoveMotor(rightMot, -turnSpeed);
            pause(turnTime);
            brick.MoveMotor(leftMot+rightMot, 0);
        dist = brick.UltrasonicDist(ultra);
        if dist < 30 %if right is impossible, look left
            %rotate left x2
                brick.MoveMotor(leftMot, -turnSpeed);
                brick.MoveMotor(rightMot, turnSpeed);
                pause(turnTime*2);
                brick.MoveMotor(leftMot+rightMot, 0);
            dist = brick.UltrasonicDist(ultra);
            if dist < 30 %if left is impossible, turn back
                 %rotate left
                    brick.MoveMotor(leftMot, -turnSpeed);
                    brick.MoveMotor(rightMot, turnSpeed);
                    pause(turnTime);
                    brick.MoveMotor(leftMot+rightMot, 0);
            end
        end
    end
    %go
        brick.MoveMotor(leftMot+rightMot, moveSpeed);
        pause(moveTime);
        rgb = brick.ColorRGB(colSen);
        if rgb(1)>rgb(2)+rgb(3) %if red's seen wait before moving forward, wait longer
        pause(5);
        end
        brick.MoveMotor(leftMot+rightMot, moveSpeed);
        pause(moveTime);

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