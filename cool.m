brick = ConnectBrick('GROUP8');

ultra = 'C';
leftMot = 'D';
rightMot = 'A';
colSen = 3;
gyro = 4;

brick.SetColorMode(colSen, 4);

pickup = true;
while pickup

    disp(pickup);
    pickup = false;
end

driving = true;
while driving
    rgb = brick.ColorRGB(colSen);
    dist = brick.UltrasonicDist(ultra);
    brick.GyroCalibrate(gyro);
    disp(dist);
    disp(brick.GyroAngle(gyro))
    disp(angle);
    pause(1);
        if dist > 1
            brick.MoveMotor(leftMot+rightMot, 50);
            pause(2);
        else
            angle = brick.GyroAngle(gyro);
            while abs(brick.GyroAngle(gyro))<abs(angle)+90
                brick.MoveMotor(rightMot, 25);
                brick.MoveMotor(leftMot, -25);
            end
            brick.MoveMotor(leftMot+rightMot, 0);
            dist = brick.UltrasonicDist(1);
            if dist > 1
                brick.MoveMotor(leftMot+rightMot, 50);
                pause(2);
            else
                angle = brick.GyroAngle(gyro);
                while abs(brick.GyroAngle(gyro))<abs(angle)+90
                brick.MoveMotor(leftMot, 25);
                brick.MoveMotor(rightMot, -25);
                end
                brick.MoveMotor(leftMot+rightMot, 0);
                dist = brick.UltrasonicDist(ultra);
                if dist > 1
                    brick.MoveMotor(leftMot+rightMot, 50);
                    pause(2);
                else
                    angle = brick.GyroAngle(gyro);
                    while abs(brick.GyroAngle(gyro))<abs(angle)+90
                    brick.MoveMotor(leftMot, 25);
                    brick.MoveMotor(rightMot, -25);
                    end
                    brick.MoveMotor(leftMot+rightMot, 0);
                    brick.MoveMotor(leftMot+rightMot, 50);
                    pause(2);
                end
            end            
        end
        disp(rgb);
        if rgb(1)>rgb(2)+rgb(3)+50
            brick.MoveMotor(leftMot+rightMot, 0);
            pause(5);
            brick.MoveMotor('AD', 50);
            pause(3);
            brick.MoveMotor('AD', 0);
        elseif rgb(1)+rgb(2)-rgb(3)>500
            brick.MoveMotor('AD', 100);
            pause(1.5);
            brick.MoveMotor('AD', 0);
            driving = false;
        else
            brick.MoveMotor('AD', 50);
            pause(3);
            brick.MoveMotor('AD', 0);
        end
end
dropoff=true;
while dropoff
    disp(dropoff);
    dropoff=false;
end
DisconnectBrick(brick);
clear brick;