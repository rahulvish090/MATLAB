clc;
clear;
close all;

% define ranges
t = linspace(0,5,100); % time axis
s = linspace(0.5,4,50); % s-axis

[T,S] = meshgrid(t,s);

% Function f(t)

f = exp(-2*T);

%laplace kernel
Z = exp(-S.*T).*f;

% Create figure
figure
h = surf(T,S,Z);
shading interp
colormap jet
colorbar

view(45,30)
grid on

% Animation loop
for angle = 0:2:360
    view(angle,30)
    drawnow
end

