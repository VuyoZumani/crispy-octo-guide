%ugrad_sim
%deploy ugradnet to investigate trends

clear all
close all
clc
load ugrad_train.mat

%vary Swedish points
x(1,:)=linspace(24,46,91);
%fix school quality
x(2,:)=repmat(5,1,91);
%vary test results
x(3,:)=[10:100]; 

%deploy nn
y=ugradnet(x);

%plots
figure
plot(x(3,:),y(1,:))
title('Semester 1 vs test mark')

figure
plot(x(3,:),y(2,:))
title('Semester 2 vs test mark')

figure
plot(x(1,:),y(1,:))
title('Semester 1 vs Swidish points')

figure
plot(x(1,:),y(2,:))
title('Semester 2 vs Swidish points')