clc;
clear;
close all;

[x, y] = meshgrid(linspace(-3,3,200));

% Dipole equations
Bx = (3*x.*y) ./ (x.^2 + y.^2 + eps).^2;
By = (2*y.^2 - x.^2) ./ (x.^2 + y.^2 + eps).^2;

figure('Color','w')
streamline(x, y, Bx, By, x(:), y(:))
axis equal tight
grid on
title('Magnetic Field of a Dipole','FontSize',14)
xlabel('X')
ylabel('Y')
