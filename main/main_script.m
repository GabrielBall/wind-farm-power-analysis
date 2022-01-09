% Clears all figures and variables in the workspace
clear all;
close all;

% Sets the physical properties of the turbines
bladeDiameter = 75;
shaftHeight = 120;

% Estabilishes an array of the positions of each turbine centre for each
% site
[positionsDeltling,positionsCollinfirth] = farm_layout(bladeDiameter,shaftHeight);
positions = [positionsDeltling;positionsCollinfirth];

% Plots each turbine centres position
figure;scatter(positions(:,1)/1000,positions(:,2)/1000,10,'red','filled');

% Sets range of axes
xlim([-4 6]);
ylim([-3 7]);

% Equalises the axes to get the correct distance scale
axis equal;

% Sets labels of the plot
title('Positions of each turbine');
xlabel('X position / km');
ylabel('Y position / km');

% Sets average air density
d0 = 1.225;

% Forms array of weather patterns across the months. First column
% represents wind speeds, second column the average direction and third
% column the average air density
weather = [ 10.5 180 1.05*d0; 9.94 180 1.05*d0; 9.36 180 1.05*d0; 7.83 180 d0; 6.75 0 d0; 6.25 270 d0; 5.97 180 0.99*d0; 6.42 180 0.99*d0; 7.86 180 0.99*d0; 9.17 180 d0; 9.67 180 d0; 9.89 180 d0];

% Sets the Hellmann coefficients for Deltling and Collinfirth respectively
hellmannDeltling = 0.11;
hellmannCollinfirth = 0.27;

% Establishes arrays for the velocity at each site at the given shaft
% height
velocityCentreDeltling = zeros(12,1);
velocityCentreCollinfirth = zeros(12,1);

% Fills the array with values given by the velocity distribution formula
for k = 1:12
    velocityCentreDeltling(k,1) = weather(k,1)*(shaftHeight/10)^hellmannDeltling;
    velocityCentreCollinfirth(k,1) = weather(k,1)*(shaftHeight/10)^hellmannCollinfirth;
end

% Estabilishes all necessary factors for our approximate power curve
efficiency = 0.57;
cutinVelocity = 3;
saturationVelocity = 15;
cutoffVelocity = 25;

% Estabilishes array for power curve
powerCurve = zeros(35,2);

% Fills the array with the correct values for all 4 sections of the curve
% respectively. For the range between the cut in and saturation velocities
% the power was estimated by using the Betz limit multiplied by a constant
% efficiency.
for k = 1:cutinVelocity
    powerCurve(k,2) = 0;
end
for k = cutinVelocity+1:saturationVelocity
    powerCurve(k,2) = pi*(8/27)*d0*(k-1)^3*(bladeDiameter/2)^2*efficiency;
end
for k = saturationVelocity+1:cutoffVelocity
    powerCurve(k,2) = powerCurve(saturationVelocity,2);
end
for k = cutoffVelocity+1:35
    powerCurve(k,2) = 0;
end
for k = 1:35
    powerCurve(k,1) = k-1;
end

% Estabilishes arrays for yaw angles of the turbines on each site
yawAnglesDeltling = zeros(76,1);
yawAnglesCollinfirth = zeros(54,1);
yawAngles = [yawAnglesDeltling;yawAnglesCollinfirth];

% Forms an array of blade diameters for the turbines
diametersDeltling = zeros(76,1); diametersDeltling(:,1) = bladeDiameter;
diametersCollinfirth = zeros(54,1); diametersCollinfirth(:,1) = bladeDiameter;
diameters = [diametersDeltling;diametersCollinfirth];

% Estabilishes an array for the coordinates at which velocity will be evaluated
location = zeros(100,3);

% Fills the array with ( x , y , z ) coordinates evenly spaced in a grid at
% 100m intervals at a height equal to the shaft height of the turbines
k=1;
for m = 1:100
    for n = 1:100
        location(k,2)=100*n-4000;
        location(k,1)=100*m-3000;
        k=k+1;
    end
end
location(:,3) = shaftHeight;

% Averages the wind speeds at the shaft height and also finds the overall
% average between both sites
avgSpeedDeltling = sum(velocityCentreDeltling)/12;
avgSpeedCollinfirth = sum(velocityCentreCollinfirth)/12;
avgSpeed = (avgSpeedDeltling+avgSpeedCollinfirth)/2;

% Calculates the velocity at each point in the location grid given the
% average speed across both sites and a Northernly wind direction
[power,velocity] = floris(avgSpeed,d0,0,positions,yawAngles,diameters,powerCurve,location);

% Estabilishes the x and y distances to be used for the velocity plot. This
% is used rather than directly using the location array since that is an
% array of ( x , y ) coordinates rather than two arrays of x and y
% respectively.
x = -3.9:0.1:6;
y = -2.9:0.1:7;

% Reshapes the velocity array from a 1 column list to a 100*100 array where
% the position in the array corresponds to the ( x , y ) coordinate
v=reshape(velocity,100,100);

% Plots the velocity over the x y plane
figure;surf(x,y,v);
xlabel('X distance /km')
ylabel('Y distance /km')
zlabel('Velocity / m/s')
title('Velocity plot across the wind farm for a Northerly wind of 12.5 m/s ')
set(gca, 'ZDir','reverse')

% Estabilishes an array for the average power across the months of the year
monthlyPower = zeros(12,1);

% Fills the array with the powers from the floris model given the monthly
% variations in wind speed and then combines them to get a total power
% output.
for k = 1:12
    powerDeltling=floris(velocityCentreDeltling(k,1),weather(k,3),weather(k,2),positionsDeltling,yawAnglesDeltling,diametersDeltling,powerCurve,[0 0 0]);
    powerCollinfirth=floris(velocityCentreCollinfirth(k,1),weather(k,3),weather(k,2),positionsCollinfirth,yawAnglesCollinfirth,diametersCollinfirth,powerCurve,[0 0 0]);
    monthlyPower(k,1) = sum(powerDeltling)+sum(powerCollinfirth);
end

% Plots these average power outputs against their months
figure;plot(monthlyPower*10^(-6))
xlabel('Months')
ylabel('Power / MW')
title('Average power output for each month')
axis([0.5 12.5 0 300])
xticks(1:1:12)

% Averages the power across the year to get a single value
avgPower = sum(monthlyPower)/12;

% Estabilishes an array of angles for wind direction
windDirections = [0:1:360];

% Estabilishes an array of average power across these varying angles
anglePower=zeros(1,361);

% Fills the array with average combined power output from both sites using the floris model given
% the wind angle
for k = 1:361
    powerDeltling=floris(avgSpeedDeltling,d0,windDirections(k),positionsDeltling,yawAnglesDeltling,diametersDeltling,powerCurve,[0 0 0]);
    powerCollinfirth=floris(avgSpeedDeltling,d0,windDirections(k),positionsCollinfirth,yawAnglesCollinfirth,diametersCollinfirth,powerCurve,[0 0 0]);
    anglePower(1,k) = sum(powerDeltling)+sum(powerCollinfirth);
end

% Plots this average power output across the different angles
figure;plot(windDirections,anglePower*10^(-6));
axis([0 360 0 200]);
xticks(0:60:360);
xlabel('Angle of wind direction/deg')
ylabel('Power output / MW')
title('Average power output for a given wind direction')
