clc;
clear;
close all;

% figure setup

figure('Color', 'k');
axis equal off
hold on
view(40,25)

lighting phong
camlight headlight
camlight right

%saturn sphere (ultra texture)

[theta,phi] = meshgrid(linspace(0,2*pi,400),linspace(0,pi,200));

R = 1.2;

X = R*cos(theta).*sin(phi);
Y = R*sin(theta).*sin(phi);
Z = R*cos(phi);

% procedural saturn bands (VERY REALISITIC)
bands = 0.6 + 0.25*sin(10*phi) + 0.1*sin(30*phi) + 0.05*randn(size(phi));

saturnTexture (:,:,1) = 0.85 * bands;
saturnTexture (:,:,2) = 0.72 * bands;
saturnTexture (:,:,3) = 0.45 * bands;

saturn = surf(X,Y,Z);
saturn.FaceColor = 'texturemap';
saturn.CData = saturnTexture;
saturn.EdgeColor = 'none';
saturn.SpecularStrength = 0.7;
saturn.DiffuseStrength = 0.8;
saturn.AmbientStrength = 0.3;

% SATURN RING

theta = linspace(0,2*pi,800);
r = linspace(1.6,3.2,250);
[Theta,Rr] = meshgrid(theta,r);

Xr = Rr .* cos(Theta);
Yr = Rr .*sin(Theta);
Zr = 0.02 * randn(size(Xr));

%Ring texture (multiple bands)

ringTex = 0.6 + 0.3*sin(40*Rr) + 0.15*sin(90*Rr);

ringsRGB(:,:,1) = 0.85 *ringTex;
ringsRGB(:,:,2) = 0.8 *ringTex;
ringsRGB(:,:,3) = 0.7 *ringTex;

rings = surf(Xr, Yr, Zr);
rings.FaceColor = 'texturemap';
rings.CData = ringsRGB;
rings.EdgeColor = 'none';

% Titlt rings (real Saturn ~26°)

rotate(rings,[1 0 0],26)

for k = 1:500
    rotate(saturn,[0 0 1],0.35)
    rotate(rings,[0 0 1],0.15)
    drawnow
end

