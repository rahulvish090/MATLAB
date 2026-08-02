clc;
clear;
close all;

x = linspace(0 ,4*pi,500);
t = linspace(0 ,2*pi,100);

figure
for k  = 1: length (t)
    y = sin(x);
    z = cos(x + t(k));

    plot3(x, y, z, 'lineWidth', 2)
    grid on

    xlabel('X axis')
    ylabel('Y axis')
    zlabel('Z axis')

    title ('3D Animated sine wave')

    axis([-1 4*pi -1 1 -1 1])

    view(45 + k, 30)
    drawnow
end