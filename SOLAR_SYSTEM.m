clc;
clear;
close all;

%% ===================== PLANET DATA =====================
planetNames = {'Mercury','Venus','Earth','Mars','Jupiter','Saturn','Uranus','Neptune'};
R = [2 3 4 5 7 9 11 13];            % orbital radius (visual)
Psize = [0.15 0.22 0.25 0.20 0.6 0.5 0.4 0.4];

% Kepler 3rd law (omega ∝ 1/r^(3/2))
omega = 1 ./ (R.^(3/2));
omega = omega / max(omega) * 0.4;

colors = [
    0.7 0.7 0.7
    1.0 0.7 0.3
    0.2 0.6 1.0
    1.0 0.3 0.3
    1.0 0.8 0.5
    1.0 0.9 0.6
    0.6 0.9 1.0
    0.3 0.4 1.0
];

planetInfo = {
 'Mercury','Mass: 3.3e23 kg','Radius: 2440 km'
 'Venus','Mass: 4.87e24 kg','Radius: 6052 km'
 'Earth','Mass: 5.97e24 kg','Radius: 6371 km'
 'Mars','Mass: 6.4e23 kg','Radius: 3390 km'
 'Jupiter','Mass: 1.9e27 kg','Radius: 69911 km'
 'Saturn','Mass: 5.7e26 kg','Radius: 58232 km'
 'Uranus','Mass: 8.6e25 kg','Radius: 25362 km'
 'Neptune','Mass: 1.0e26 kg','Radius: 24622 km'
};

%% ===================== FIGURE =====================
figure('Color','k');
hold on
axis equal off
lighting gouraud
camlight headlight
camproj('perspective')

%% ===================== CAMERA STATE =====================
camDist = 32;
camAz   = -45;
camEl   = 25;

%% ===================== STARS =====================
Nstars = 1500;
stars = 50*(rand(Nstars,3)-0.5);
scatter3(stars(:,1),stars(:,2),stars(:,3),2,'w','filled');

%% ===================== SUN =====================
[su,sv] = sphere(80);
SunR = 1.2;
surf(SunR*su,SunR*sv,SunR*sv,...
    'FaceColor',[1 0.7 0.1],'EdgeColor','none');
light('Position',[0 0 0],'Style','infinite','Color',[1 1 0.9])

%% ===================== ORBITS =====================
theta = linspace(0,2*pi,600);
for i = 1:length(R)
    plot3(R(i)*cos(theta),R(i)*sin(theta),zeros(size(theta)),...
        'Color',[0.4 0.4 0.4],'LineStyle','--');
end

%% ===================== PLANETS =====================
[px,py,pz] = sphere(30);
for i = 1:length(R)
    planets(i) = surf(Psize(i)*px+R(i),Psize(i)*py,Psize(i)*pz,...
        'FaceColor',colors(i,:),'EdgeColor','none');
    set(planets(i),'PickableParts','all',...
        'ButtonDownFcn',@(src,~) showInfo(i,planetInfo));
end

%% ===================== SATURN RINGS =====================
rr = linspace(0.7,1.2,40);
tt = linspace(0,2*pi,200);
[RR,TT] = meshgrid(rr,tt);
RX = RR.*cos(TT);
RY = RR.*sin(TT);
RZ = zeros(size(RX));
rings = surf(RX+R(6),RY,RZ,...
    'FaceColor',[0.9 0.8 0.6],'FaceAlpha',0.4,'EdgeColor','none');

%% ===================== EARTH–MOON =====================
moonR = 0.06;
moonDist = 0.45;
[msx,msy,msz] = sphere(20);
moon = surf(moonR*msx+R(3)+moonDist,moonR*msy,moonR*msz,...
    'FaceColor',[0.8 0.8 0.8],'EdgeColor','none');

%% ===================== UI CONTROLS =====================
startDate = datetime(2025,1,1);
simDays = 0;
dt = 0.02;

uicontrol('Style','text','String','Speed','ForegroundColor','w',...
    'BackgroundColor','k','Position',[20 60 50 20]);
speedSlider = uicontrol('Style','slider','Min',0.1,'Max',5,'Value',1,...
    'Position',[80 60 200 20]);

dateText = uicontrol('Style','text','String','Date: 01-Jan-2025',...
    'ForegroundColor','w','BackgroundColor','k',...
    'Position',[20 20 300 25]);

pauseBtn = uicontrol('Style','togglebutton','String','Pause',...
    'Position',[300 60 80 30]);

uicontrol('Style','pushbutton','String','Reset Date',...
    'Position',[390 60 90 30],...
    'Callback',@(~,~) simDaysReset());

uicontrol('Style','text','String','Jump to (dd-mmm-yyyy)',...
    'ForegroundColor','w','BackgroundColor','k',...
    'Position',[20 90 200 20]);
dateBox = uicontrol('Style','edit','String','01-Jan-2030',...
    'Position',[230 90 120 25]);
uicontrol('Style','pushbutton','String','Jump',...
    'Position',[360 90 60 25],...
    'Callback',@(~,~) jumpDate());

%% ===================== CAMERA BUTTONS =====================
uicontrol('Style','pushbutton','String','Zoom +',...
    'Position',[500 60 70 30],'Callback',@(~,~) zoomIn());
uicontrol('Style','pushbutton','String','Zoom -',...
    'Position',[580 60 70 30],'Callback',@(~,~) zoomOut());
uicontrol('Style','pushbutton','String','◄ Rotate',...
    'Position',[500 20 70 30],'Callback',@(~,~) rotateLeft());
uicontrol('Style','pushbutton','String','Rotate ►',...
    'Position',[580 20 70 30],'Callback',@(~,~) rotateRight());
uicontrol('Style','pushbutton','String','Reset Cam',...
    'Position',[660 40 90 30],'Callback',@(~,~) resetCamera());

updateCamera();

%% ===================== ANIMATION LOOP =====================
while ishandle(speedSlider)

    if pauseBtn.Value
        pauseBtn.String = 'Resume';
        drawnow; continue
    else
        pauseBtn.String = 'Pause';
    end

    simDays = simDays + speedSlider.Value;
    dateText.String = ['Date: ' datestr(startDate + days(simDays))];

    for i = 1:length(R)
        ang = omega(i)*simDays*dt;
        x = R(i)*cos(ang);
        y = R(i)*sin(ang);
        z = 0.1*sin(ang);

        set(planets(i),'XData',Psize(i)*px+x,...
                       'YData',Psize(i)*py+y,...
                       'ZData',Psize(i)*pz+z);

        if i == 6
            set(rings,'XData',RX+x,'YData',RY+y,'ZData',RZ+z);
        end

        if i == 3
            mx = x + moonDist*cos(12*ang);
            my = y + moonDist*sin(12*ang);
            set(moon,'XData',moonR*msx+mx,...
                     'YData',moonR*msy+my,...
                     'ZData',moonR*msz+z);
        end
    end
    drawnow
end

%% ===================== FUNCTIONS =====================
function showInfo(i,info)
    msgbox(info(i,:),info{i,1});
end
function simDaysReset()
    assignin('base','simDays',0);
end
function jumpDate()
    sd = evalin('base','startDate');
    box = evalin('base','dateBox');
    assignin('base','simDays',days(datetime(box.String,'InputFormat','dd-MMM-yyyy')-sd));
end
function updateCamera()
    cd = evalin('base','camDist');
    az = evalin('base','camAz');
    el = evalin('base','camEl');
    campos([cd*cosd(az)*cosd(el) cd*sind(az)*cosd(el) cd*sind(el)]);
    camtarget([0 0 0]);
    camva(18);
end
function zoomIn()
    assignin('base','camDist',max(evalin('base','camDist')-3,15)); updateCamera();
end
function zoomOut()
    assignin('base','camDist',min(evalin('base','camDist')+3,80)); updateCamera();
end
function rotateLeft()
    assignin('base','camAz',evalin('base','camAz')-5); updateCamera();
end
function rotateRight()
    assignin('base','camAz',evalin('base','camAz')+5); updateCamera();
end
function resetCamera()
    assignin('base','camDist',32);
    assignin('base','camAz',-45);
    assignin('base','camEl',25);
    updateCamera();
end
