function[ptsDeltling,ptsCollinfirth] = farm_layout(bladeDiameter,shaftHeight);

% Checks all inputs and outputs the corresponding error message if
% incorrect
if isnumeric(bladeDiameter)~=1|bladeDiameter<=0
    disp('Invalid input for blade diameter')
elseif isnumeric(shaftHeight)~=1|shaftHeight<=0
    disp('Invalid input for shaft height')
else
    % Establishes an empty array for values to be added to
    ptsDeltling = zeros(1,3);
    ptsCollinfirth = zeros(1,3);
    % Sets the minimum distance between the wind turbines as a multiple of the
    % blade diameter
    d = bladeDiameter*(22/3);

    % Sets the horizontal distance between the lines of the triangular grid
    dy = sqrt(3)*d/2; 

    % Estabilishes the xy coordinates of each wind turbine. Each loop
    % represents one y position that turbines occupy. The x positions are then
    % estabilished as functions of k so that they are equally space. Each first
    % turbine on each row are offset from the origin by a certain amount in
    % order to fill the regions.
    for k = 1:6
        ptsDeltling(k,1)= d*(1-k);
    end

    for k = 7:12
        ptsDeltling(k,2) = dy;
        ptsDeltling(k,1) = d*(6.5-k);
    end

    for k = 13:19
        ptsDeltling(k,2) = 2*dy;
        ptsDeltling(k,1) = d*(13-k);
    end

    for k = 20:25
        ptsDeltling(k,2) = 3*dy;
        ptsDeltling(k,1) = d*(19.5-k);
    end

    for k = 26:31
        ptsDeltling(k,2) = 4*dy;
        ptsDeltling(k,1) = d*(26-k);
    end

    for k = 32:36
        ptsDeltling(k,2) = 5*dy;
        ptsDeltling(k,1) = d*(31.5-k);
    end

    for k = 37:40
        ptsDeltling(k,2) = 6*dy;
        ptsDeltling(k,1) = d*(37-k);
    end

    for k = 41:43
        ptsDeltling(k,2) = 7*dy;
        ptsDeltling(k,1) = d*(41.5-k);
    end

    for k = 44:45
        ptsDeltling(k,2) = 8*dy;
        ptsDeltling(k,1) = d*(45-k);
    end

    for k = 46:47
        ptsDeltling(k,2) = 9*dy;
        ptsDeltling(k,1) = d*(47.5-k);
    end

    for k = 48:50
        ptsDeltling(k,2) = 10*dy;
        ptsDeltling(k,1) = d*(51-k);
    end

    for k = 51:53
        ptsDeltling(k,2) = 11*dy;
        ptsDeltling(k,1) = d*(54.5-k);
    end

    for k = 54:57
        ptsDeltling(k,2) = 12*dy;
        ptsDeltling(k,1) = d*(59-k);
    end

    for k = 58:60
        ptsDeltling(k,2) = 13*dy;
        ptsDeltling(k,1) = d*(62.5-k);
    end

    for k = 61:65
        ptsDeltling(k,2) = -dy;
        ptsDeltling(k,1) = d*(60.5-k);
    end

    for k = 66:70
        ptsDeltling(k,2) = -2*dy;
        ptsDeltling(k,1) = d*(66-k);
    end

    for k = 71:74
        ptsDeltling(k,2) = -3*dy;
        ptsDeltling(k,1) = d*(70.5-k);
    end

    for k = 75:76
        ptsDeltling(k,2) = -4*dy;
        ptsDeltling(k,1) = d*(74-k);
    end

    % Estabilishes the position of the new origin for the Collinfirth site
    orig = [ 825 -0.25*d ]; 

    % Estabilishes the positions of each turbine for the Collinfirth site. The
    % same method is used as before but with the addition of an offset on each
    % turbine based on the new origin
    for k = 1:6
        ptsCollinfirth(k,2) = orig(2);
        ptsCollinfirth(k,1) = orig(1)+d*(k-1);
    end

    for k = 7:12
        ptsCollinfirth(k,2) = orig(2)+dy;
        ptsCollinfirth(k,1) = orig(1)+d*(k-5.5);
    end

    for k = 13:16
        ptsCollinfirth(k,2) = orig(2)+2*dy;
        ptsCollinfirth(k,1) = orig(1)+d*(k-10);
    end

    for k = 17:20
        ptsCollinfirth(k,2) = orig(2)+3*dy;
        ptsCollinfirth(k,1) = orig(1)+d*(k-13.5);
    end

    for k = 21:23
        ptsCollinfirth(k,2) = orig(2)+4*dy;
        ptsCollinfirth(k,1) = orig(1)+d*(k-17);
    end

    for k = 24:30
        ptsCollinfirth(k,2) = orig(2)-dy;
        ptsCollinfirth(k,1) = orig(1)+d*(k-23.5);
    end

    for k = 31:37
        ptsCollinfirth(k,2) = orig(2)-2*dy;
        ptsCollinfirth(k,1) = orig(1)+d*(k-30);
    end

    for k = 38:44
        ptsCollinfirth(k,2) = orig(2)-3*dy;
        ptsCollinfirth(k,1) = orig(1)+d*(k-37.5);
    end

    for k = 45:50
        ptsCollinfirth(k,2) = orig(2)-4*dy;
        ptsCollinfirth(k,1) = orig(1)+d*(k-44);
    end

    for k = 51:54
        ptsCollinfirth(k,2) = orig(2)-5*dy;
        ptsCollinfirth(k,1) = orig(1)+d*(k-49.5);
    end

    % Estabilishes the vertical heights of each turbine centres
    ptsCollinfirth(:,3) = shaftHeight;
    ptsDeltling(:,3) = shaftHeight;
end
end
    

