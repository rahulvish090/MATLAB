clc;
clear;
close all;

% ===== Lower resolution (FAST) =====
[u,v] = meshgrid(linspace(0,2*pi,120), linspace(-2.2,2.2,120));

b = 0.7;
r = b * cosh(v);

X = r .* cos(u);
Y = r .* sin(u);
Z = v;

figure('Color','black');
hold on;

% Wormhole surface
surf(X,Y,Z, ...
    'EdgeColor',[1 0.5 0.2], ...
    'LineWidth',0.3, ...
    'FaceColor','interp');

% ===== TIME LINE =====
x_line = linspace(-1.2,1.2,200);
y_line = zeros(size(x_line));
z_line = zeros(size(x_line));

plot3(x_line,y_line,z_line,'c','LineWidth',3);

% ===== Simple stars (lightweight) =====
numStars = 200;
xs = (rand(1,numStars)-0.5)*10;
ys = (rand(1,numStars)-0.5)*10;
zs = (rand(1,numStars)-0.5)*10;
scatter3(xs,ys,zs,5,'w','filled');

% ===== Look =====
colormap(hot);
lighting phong;
camlight headlight;
shading interp;

set(gca,'Color','black');
axis off;
daspect([1 1 1]);
view(40,18);

title('Wormhole with Time Line ','Color','white');